//
//  ZQUtil.h
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZQUtil : NSObject

// 判断相机权限
+ (BOOL)isCanUsePhotos;

// 判断麦克风权限
+ (BOOL)isCanUseAudio;

// 弹框
+ (void)showAlertWithMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
