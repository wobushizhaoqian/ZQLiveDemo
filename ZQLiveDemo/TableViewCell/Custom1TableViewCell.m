//
//  Custom1TableViewCell.m
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import "Custom1TableViewCell.h"

#define ImageHeight 30

@interface Custom1TableViewCell()
@property (nonatomic,assign)CGSize PSize;
@end


@implementation Custom1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ------------------- system methods -------------------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier parentSize:(CGSize)parentSize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.PSize = parentSize;
        [self.contentView addSubview:self.headrImageView];
        [self.contentView addSubview:self.label];
        self.backgroundColor = [self randomColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.headrImageView.frame = CGRectMake(10 , (self.PSize.height - ImageHeight)/2, ImageHeight, ImageHeight);
    self.label.frame = CGRectMake(self.PSize.height + 10, (self.PSize.height - ImageHeight)/2, self.PSize.width - self.PSize.height, ImageHeight);
}

#pragma mark ------------------- private methods -------------------
- (UIColor *)randomColor{
    NSInteger r = arc4random() % 256;
    NSInteger g = arc4random() % 256;
    NSInteger b = arc4random() % 256;
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.3];
    return color;
}

#pragma mark ------------------- lazy loading -------------------

- (UIImageView *)headrImageView{
    if (!_headrImageView) {
        _headrImageView = [UIImageView new];
    }
    return _headrImageView;
}
- (UILabel *)label{
    if (!_label) {
        _label = [UILabel new];
    }
    return _label;
}

@end
