//
//  AVCaptureSessionViewController.m
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import "AVCaptureSessionViewController.h"

#import "Views/CaptureSessionVideo/CaptureSessionVideoView.h"
#import "Views/CaptureSessionAudio/CaptureSessionAudioView.h"

#define SegmentControlWidth 300

@interface AVCaptureSessionViewController()<UIScrollViewDelegate>;

@property (nonatomic, copy)NSArray *dataSource;

// 视频采集View
@property (nonatomic, strong)CaptureSessionVideoView *captureSessionVideoView;
// 音频采集View
@property (nonatomic, strong)CaptureSessionAudioView *captureSessionAudioView;

@end

@implementation AVCaptureSessionViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.dataSource = @[@"视频采集",@"音频采集"];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.segmentControl];
}

#pragma mark -- system methods
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.segmentControl.frame = CGRectMake((self.view.bounds.size.width - SegmentControlWidth)/2, getRectNavAndStatusHight + 5, SegmentControlWidth, 40);
    _scrollView.frame = self.view.bounds;
    
    // todo 添加视频采集View和音频采集View的frame
}

#pragma mark -- evevts
- (void)respondsToSegmentControl:(UISegmentedControl *)sender{
    NSInteger t = sender.selectedSegmentIndex;
    self.scrollView.contentOffset = CGPointMake(self.view.bounds.size.width * t, 0);
}


#pragma mark -- scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    self.segmentControl.selectedSegmentIndex = point.x / self.view.bounds.size.width;
}



#pragma mark -- lazy loading
- (UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc]initWithItems:self.dataSource];
        [_segmentControl addTarget:self action:@selector(respondsToSegmentControl:) forControlEvents:UIControlEventValueChanged];
        _segmentControl.selectedSegmentIndex = 0;
    }
    return _segmentControl;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * self.dataSource.count, self.view.bounds.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (CaptureSessionVideoView *)captureSessionVideoView{
    if (!_captureSessionVideoView) {
        _captureSessionVideoView = [CaptureSessionVideoView new];
    }
    return _captureSessionVideoView;
}

- (CaptureSessionAudioView *)captureSessionAudioView{
    if (!_captureSessionAudioView) {
        _captureSessionAudioView = [CaptureSessionAudioView new];
    }
    return _captureSessionAudioView;
}
@end
