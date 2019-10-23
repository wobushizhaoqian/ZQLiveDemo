//
//  CaptureSessionVideoView.m
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import "CaptureSessionVideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface CaptureSessionVideoView()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong)UIButton *startButton;
@property (nonatomic, strong)UIButton *stopButton;

@property (nonatomic, strong)AVCaptureSession *captureSession;

@end

@implementation CaptureSessionVideoView

#pragma mark -- system methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.startButton];
        [self addSubview:self.stopButton];
    }
    return self;
}

- (void)layoutSubviews{
    self.startButton.frame = CGRectMake(0, 0, 150, 30);
    self.startButton.center = CGPointMake(self.bounds.size.width/4, self.bounds.size.height - 30);
    
    self.stopButton.frame = CGRectMake(0, 0, 150, 30);
    self.stopButton.center = CGPointMake(self.bounds.size.width *3/4, self.bounds.size.height - 30);
}



#pragma mark -- evevts
- (void)respondsToStartButton:(UIButton *)sender{
    // 检查相机权限
    if (![ZQUtil isCanUsePhotos]) {
        [ZQUtil showAlertWithMessage:@"请打开您的相机权限"];
        return;
    }
    // 取后置摄像头
    AVCaptureDevice *device = [self getVideoDeviceWithPosition:AVCaptureDevicePositionBack];
    NSError *error;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!videoInput) {
        [ZQUtil showAlertWithMessage:@"输入设备不可用"];
        return;
    }
    [self.captureSession addInput:videoInput];
    AVCaptureVideoDataOutput *outPut = [AVCaptureVideoDataOutput new];
    dispatch_queue_t queue = dispatch_queue_create("captureQueue", DISPATCH_QUEUE_SERIAL);
    [outPut setSampleBufferDelegate:self queue:queue];
    if (!outPut) {
        [ZQUtil showAlertWithMessage:@"输出设备不可用"];
        return;
    }
    [self.captureSession addOutput:outPut];
    AVCaptureVideoPreviewLayer *previedLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    previedLayer.frame = [UIScreen mainScreen].bounds;
    [self.layer insertSublayer:previedLayer atIndex:0];
    [self.captureSession startRunning];
    
}

- (void)respondsToStopButton:(UIButton *)sender{
    [self.captureSession stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"采集到视频数据！");
}


#pragma mark -- private methods
- (AVCaptureDevice *)getVideoDeviceWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark -- lazy loading
- (UIButton *)startButton{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setTitle:@"开始采集视频" forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(respondsToStartButton:) forControlEvents:UIControlEventTouchUpInside];
        _startButton.backgroundColor = [UIColor randomColor];
    }
    return _startButton;
}

- (UIButton *)stopButton{
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton setTitle:@"停止采集视频" forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(respondsToStopButton:) forControlEvents:UIControlEventTouchUpInside];
        _stopButton.backgroundColor = [UIColor randomColor];
    }
    return _stopButton;
}

- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [AVCaptureSession new];
    }
    return _captureSession;
}

@end
