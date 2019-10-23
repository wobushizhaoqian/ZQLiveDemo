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
#define ScrollViewHeight self.view.bounds.size.height-getRectNavAndStatusHight

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
    [self.scrollView addSubview:self.captureSessionVideoView];
    [self.scrollView addSubview:self.captureSessionAudioView];
    
}

#pragma mark -- system methods
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.segmentControl.frame = CGRectMake((self.view.bounds.size.width - SegmentControlWidth)/2, getRectNavAndStatusHight + 5, SegmentControlWidth, 40);
    self.scrollView.frame = CGRectMake(0, getRectNavAndStatusHight, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.captureSessionVideoView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, ScrollViewHeight);
    self.captureSessionAudioView.frame = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, ScrollViewHeight);
}

#pragma mark -- evevts
- (void)respondsToSegmentControl:(UISegmentedControl *)sender{
    NSInteger t = sender.selectedSegmentIndex;
    self.scrollView.contentOffset = CGPointMake(self.view.bounds.size.width * t, 0);
}


#pragma mark -- scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = CGPointMake(scrollView.contentOffset.x, getRectNavAndStatusHight);
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
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
- (CaptureSessionVideoView *)captureSessionVideoView{
    if (!_captureSessionVideoView) {
        _captureSessionVideoView = [CaptureSessionVideoView new];
        _captureSessionVideoView.backgroundColor = [UIColor grayColor];
    }
    return _captureSessionVideoView;
}

- (CaptureSessionAudioView *)captureSessionAudioView{
    if (!_captureSessionAudioView) {
        _captureSessionAudioView = [CaptureSessionAudioView new];
        _captureSessionAudioView.backgroundColor = [UIColor whiteColor];
    }
    return _captureSessionAudioView;
}
@end
