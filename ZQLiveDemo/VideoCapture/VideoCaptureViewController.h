//
//  VideoCaptureViewController.h
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, CaptureSelected) {
    CaptureSelectedAVCaptureSession = 0,
    CaptureSelectedAudioQueue,
    CaptureSelectedAudioUnit,
};

@interface VideoCaptureViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
