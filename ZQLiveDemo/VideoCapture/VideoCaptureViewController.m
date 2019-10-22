//
//  VideoCaptureViewController.m
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import "VideoCaptureViewController.h"

@interface VideoCaptureViewController ()

@end

@implementation VideoCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    // 检查相机权限
    if (![ZQUtil isCanUsePhotos]) {
         [ZQUtil showAlertWithMessage:@"请打开您的相机权限"];
    }
}


@end
