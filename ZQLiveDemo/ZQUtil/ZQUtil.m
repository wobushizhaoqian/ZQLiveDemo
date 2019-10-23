//
//  ZQUtil.m
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import "ZQUtil.h"
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>


@implementation ZQUtil

+ (BOOL)isCanUsePhotos{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            return NO;
        }
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            return NO;
        }
    }
    return YES;
}


+ (BOOL)isCanUseAudio{
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioAuthStatus == PHAuthorizationStatusRestricted ||
        audioAuthStatus == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}



+ (void)showAlertWithMessage:(NSString *)message{
    ZQAlertView *alertView =[[ZQAlertView alloc]initWithMessage:message title:AlertTitle buttonIndex:^(NSInteger index) {
        
    } cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alertView show];
}


@end
