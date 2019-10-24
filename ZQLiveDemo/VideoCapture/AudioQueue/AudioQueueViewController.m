//
//  AudioQueueViewController.m
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import "AudioQueueViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define ZBufferCount 3
#define ZDefaultSampleRate 8000
#define ZDefalutChannel 1
#define ZBitsPerChannel 16

#define ZBufferDurationSeconds  0.2
@interface AudioQueueViewController (){
    AudioQueueRef audioQRef;       //音频队列对象指针
    AudioStreamBasicDescription recordFormat;   //音频流配置
    AudioQueueBufferRef audioBuffers[ZBufferCount];  //音频流缓冲区对象
    
}
@property (nonatomic, strong)UIButton *startButton;
@property (nonatomic, strong)UIButton *stopButton;


@property(nonatomic,assign)BOOL isRecording;;

@property(nonatomic,strong)NSString* recordFileName;  //音频目录
@property(nonatomic,assign)AudioFileID recordFileID;   //音频文件标识  用于关联音频文件
@property(nonatomic,assign)SInt64 recordPacket;  //录音文件的当前包

@end

@implementation AudioQueueViewController

#pragma mark -- system methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
    [self initFile];
    [self initFormat];
}

- (void)dealloc {
    AudioQueueDispose(audioQRef, TRUE);
    AudioFileClose(_recordFileID);
}

#pragma mark -- private methods
+ (instancetype)sharedManager{
    static  AudioQueueViewController*manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         manager = [[AudioQueueViewController alloc]init];
    });
    return manager;
}

-  (void)initFormat {
    recordFormat.mSampleRate =  ZDefaultSampleRate;  //采样率
    recordFormat.mChannelsPerFrame = ZDefalutChannel; //声道数量
    //编码格式
    recordFormat.mFormatID = kAudioFormatLinearPCM;
    recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    //每采样点占用位数
    recordFormat.mBitsPerChannel = ZBitsPerChannel;
    //每帧的字节数
    recordFormat.mBytesPerFrame = (recordFormat.mBitsPerChannel / 8) * recordFormat.mChannelsPerFrame;
    //每包的字节数
    recordFormat.mBytesPerPacket = recordFormat.mBytesPerFrame;
    //每帧的字节数
    recordFormat.mFramesPerPacket = 1;
}
- (void)initFile {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    self.recordFileName = [documentPath stringByAppendingPathComponent:@"tempRecordPath/tempRecord.wav"];
}

- (void)initAudio {
    //设置音频输入信息和回调
    OSStatus status = AudioQueueNewInput(&recordFormat, inputBufferHandler, (__bridge void *)(self), NULL, NULL, 0, &audioQRef);
    
    if( status != kAudioSessionNoError )
    {
        NSLog(@"初始化出错");
        return ;
    }
    
    //计算估算的缓存区大小
    int frames = [self computeRecordBufferSize:&recordFormat seconds:ZBufferDurationSeconds];
    int bufferByteSize = frames * recordFormat.mBytesPerFrame;
    for (int i = 0; i < ZBufferCount; i++){
        AudioQueueAllocateBuffer(audioQRef, bufferByteSize, &audioBuffers[i]);
        AudioQueueEnqueueBuffer(audioQRef, audioBuffers[i], 0, NULL);
    }
}

- (int)computeRecordBufferSize:(const AudioStreamBasicDescription*)format seconds:(float)seconds{
    int packets, frames, bytes = 0;
    frames = (int)ceil(seconds * format->mSampleRate);
    if (format->mBytesPerFrame > 0){
        bytes = frames * format->mBytesPerFrame;
    }
    else{
        UInt32 maxPacketSize = 0;
        if (format->mBytesPerPacket > 0){
            maxPacketSize = format->mBytesPerPacket;    // constant packet size
        }
        if (format->mFramesPerPacket > 0){
            packets = frames / format->mFramesPerPacket;
        }
        else{
            packets = frames;    // worst-case scenario: 1 frame in a packet
        }
        if (packets == 0) {       // sanity check{
            packets = 1;
        }
        bytes = packets * maxPacketSize;
    }
    return bytes;
}

//回调
void inputBufferHandler(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime,UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc){
     AudioQueueViewController*audioManager = [AudioQueueViewController sharedManager];
    if (inNumPackets > 0) {
        //写入文件
        AudioFileWritePackets(audioManager.recordFileID, FALSE, inBuffer->mAudioDataByteSize,inPacketDesc, audioManager.recordPacket, &inNumPackets, inBuffer->mAudioData);
        audioManager.recordPacket += inNumPackets;
    }
    if (audioManager.isRecording) {
        //将缓冲器重新放入缓冲队列，以便重复使用该缓冲器
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    }
}

#pragma mark -- evevts
- (void)respondsToStartButton:(UIButton *)sender{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.recordFileName]) {
        [fileManager removeItemAtPath:self.recordFileName error:nil];
    }
    [self initAudio];
    CFURLRef url = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)self.recordFileName, NULL);
    //创建音频文件夹
    AudioFileCreateWithURL(url, kAudioFileCAFType, &recordFormat, kAudioFileFlags_EraseFile,&_recordFileID);
    CFRelease(url);
    
    self.recordPacket = 0;
    
    //当有音频设备（比如播放音乐）导致改变时 需要配置
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    //开始录音
    OSStatus status = AudioQueueStart(audioQRef, NULL);
    if( status != kAudioSessionNoError ){
        NSLog(@"开始出错");
        return;
    }
    self.isRecording = true;
    // 设置可以更新声道的power信息
    [self performSelectorOnMainThread:@selector(enableUpdateLevelMetering) withObject:nil waitUntilDone:NO];
}
- (BOOL)enableUpdateLevelMetering{
    UInt32 val = 1;
    //kAudioQueueProperty_EnableLevelMetering的setter
    OSStatus status = AudioQueueSetProperty(audioQRef, kAudioQueueProperty_EnableLevelMetering, &val, sizeof(UInt32));
    if( status == kAudioSessionNoError ){
        return YES;
    }
    return NO;
}

- (void)respondsToStopButton:(UIButton *)sender{
    
    if (self.isRecording)
    {
        self.isRecording = NO;
        AudioQueueStop(audioQRef, true);
        AudioFileClose(_recordFileID);
        AudioQueueDispose(audioQRef, TRUE);
    }
}
#pragma mark -- system methods
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.startButton.frame = CGRectMake(0, 0, 150, 30);
    self.startButton.center = CGPointMake(self.view.bounds.size.width/4, self.view.bounds.size.height - 30);
    
    self.stopButton.frame = CGRectMake(0, 0, 150, 30);
    self.stopButton.center = CGPointMake(self.view.bounds.size.width *3/4, self.view.bounds.size.height - 30);
}
#pragma mark -- lazy loading
- (UIButton *)startButton{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setTitle:@"开始采集音频" forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(respondsToStartButton:) forControlEvents:UIControlEventTouchUpInside];
        _startButton.backgroundColor = [UIColor randomColor];
    }
    return _startButton;
}

- (UIButton *)stopButton{
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton setTitle:@"停止采集音频" forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(respondsToStopButton:) forControlEvents:UIControlEventTouchUpInside];
        _stopButton.backgroundColor = [UIColor randomColor];
    }
    return _stopButton;
}

@end
