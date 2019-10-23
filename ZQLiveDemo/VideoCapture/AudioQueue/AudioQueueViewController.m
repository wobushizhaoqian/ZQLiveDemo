//
//  AudioQueueViewController.m
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import "AudioQueueViewController.h"

@interface AudioQueueViewController ()
@property (nonatomic, strong)UIButton *startButton;
@property (nonatomic, strong)UIButton *stopButton;

@end

@implementation AudioQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
}


#pragma mark -- evevts
- (void)respondsToStartButton:(UIButton *)sender{
}
- (void)respondsToStopButton:(UIButton *)sender{
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
