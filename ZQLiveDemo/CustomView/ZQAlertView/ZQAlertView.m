//
//  ZQAlertView.m
//  GSCB
//
//  Created by 赵前 on 2019/9/11.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import "ZQAlertView.h"


@interface ZQAlertView()

@property(nonatomic,strong) UIImageView *bgImgView;

@property(nonatomic,strong) UIView *contentView;


@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *lbOfMessages;

@property(nonatomic,copy) void (^selectedBlock)(NSInteger index);

@property(nonatomic,strong) NSMutableArray *arrayOfBtns;

@end


@implementation ZQAlertView

-(id)initWithFrame:(CGRect)frame{
    
    self =[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setup{
    
    if (self.bgImgView ==nil) {
        self.bgImgView =[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    self.bgImgView.backgroundColor =[UIColor colorWithHex:0x000000 alpha:0.6];
    [self addSubview:self.bgImgView];
    
    self.font =[UIFont systemFontOfSize:16];
    self.fontColor =[UIColor blackColor];
}

- (instancetype)initWithMessage:(NSString *)message title:(NSString *)title buttonIndex:(void (^)(NSInteger))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    self =[[ZQAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self setup];
    
    va_list args;
    va_start(args, otherButtonTitles);
    _arrayOfBtns= [[NSMutableArray alloc] init];
    for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
        [_arrayOfBtns addObject:str];
    }
    va_end(args);
    
    [self initContentViewWith:message title:title cancelButtonTitle:cancelButtonTitle blue:NO];
    
    self.selectedBlock =block;
    
    return self;
}

-(void)initContentViewWith:(NSString *)strMessage title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle blue:(BOOL)isBlue{
    
    NSInteger allCount = cancelButtonTitle.length >0 ? _arrayOfBtns.count+1 : _arrayOfBtns.count;
    
    CGFloat messageHeight =[strMessage sizeWithFont:_font constrainedToSize:CGSizeMake(MainScreenWidth*0.8-30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height+10;
    CGFloat itemBtnWidth =MainScreenWidth-70;
    NSInteger itemBtnHeight =itemBtnWidth*2/13;
    CGFloat contentHeight =messageHeight+80+(itemBtnHeight+10)*allCount;
    
    if (self.contentView ==nil) {
        self.contentView =[[UIView alloc]initWithFrame:CGRectMake(20, (MainScreenHeight-contentHeight)/2, MainScreenWidth-40, contentHeight)];
    }
    self.contentView.layer.cornerRadius =3;
    self.contentView.backgroundColor =[UIColor whiteColor];
    [self addSubview:_contentView];
    
    if (self.lbOfMessages ==nil) {
        self.lbOfMessages =[[UILabel alloc]initWithFrame:CGRectMake(15, 60, MainScreenWidth-70, messageHeight)];
    }
    self.lbOfMessages.numberOfLines =0;
    self.lbOfMessages.backgroundColor =[UIColor clearColor];
    self.lbOfMessages.textAlignment = NSTextAlignmentCenter;
    self.lbOfMessages.text =strMessage;
    [self.contentView addSubview:_lbOfMessages];
    
    if (self.titleLabel== nil) {
        self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth-40, 40)];
    }
    self.titleLabel.backgroundColor =[UIColor colorWithRed:255/255.0 green:74/255.0 blue:78/255.0 alpha:1];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.titleLabel.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.titleLabel.bounds;
    maskLayer.path = path.CGPath;
    self.titleLabel.layer.mask = maskLayer;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_titleLabel];
   
    
    for (int i =0 ; i <  allCount; i++) {
        UIButton *itemBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
        if (i ==_arrayOfBtns.count ) {
            //cancelBtn
            itemBtn.tag =0;
            [itemBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
            if (isBlue) {
                [itemBtn setBackgroundImage:[UIImage imageNamed:@"gyAlertView_03.png"] forState:UIControlStateNormal];
                [itemBtn setTitleColor:[self colorWithHexString:@"#0D68B6"] forState:UIControlStateNormal];
            }else{
                [itemBtn setBackgroundImage:[UIImage imageNamed:@"gyAlertView_02.png"] forState:UIControlStateNormal];
                [itemBtn setTitleColor:[UIColor colorWithHex:0xa40000] forState:UIControlStateNormal];
            }
        }else{
            //otherBtn
            itemBtn.tag =i +1;
            [itemBtn setTitle:_arrayOfBtns[i] forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            if (isBlue) {
                [itemBtn setBackgroundColor:[self colorWithHexString:@"#0D68B6"]];
                [itemBtn setBackgroundImage:nil forState:UIControlStateNormal];
                itemBtn.layer.cornerRadius=4;
                itemBtn.layer.masksToBounds=YES;
            }else{
                [itemBtn setBackgroundImage:[UIImage imageNamed:@"gyAlertView_01.png"] forState:UIControlStateNormal];
                [itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        itemBtn.frame =CGRectMake(15, messageHeight+80+i*(itemBtnHeight+10),itemBtnWidth , itemBtnHeight);
        [itemBtn addTarget:self action:@selector(functionButtonPreesed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:itemBtn];
    }
}


-(void)functionButtonPreesed:(id)sender{
    
    UIButton *btn =(UIButton *)sender;
    
    if ([self selectedBlock]) {
        [self selectedBlock](btn.tag);
    }
    [self hide];
}

-(void)show{
    
    UIWindow *window =[[[UIApplication sharedApplication] delegate] window];
    self.contentView.center =CGPointMake(window.center.x, window.center.y*0.9);
    
    if (self.frame.origin.x <=0) {
        self.contentView.center = window.center;
    }
    self.lbOfMessages.font =_font;
    self.lbOfMessages.textColor =_fontColor;
    [window addSubview:self];
    self.contentView.transform =CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform =CGAffineTransformMakeScale(1, 1);
    }];
}




-(void)hide{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha =0;
    } completion:^(BOOL finished){
        if ([self superview]) {
            [self removeFromSuperview];
        }
    }];
}
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
