//
//  ZQAlertView.h
//  GSCB
//
//  Created by 赵前 on 2019/9/11.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ZQAlertView : UIView

-(instancetype)initWithMessage:(NSString *)message title:(NSString *)title buttonIndex:(void(^)(NSInteger index))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION ;


@property(nonatomic,copy) UIFont *font;
@property(nonatomic,copy) UIColor *fontColor;


-(void)show;
-(void)hide;
@end
