//
//  Custom1TableViewCell.h
//  ZQLiveDemo
//
//  Created by 赵前 on 2019/10/22.
//  Copyright © 2019年 赵前. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Custom1TableViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView *headrImageView;
@property (nonatomic, strong)UILabel *label;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier parentSize:(CGSize)parentSize;

@end

NS_ASSUME_NONNULL_END
