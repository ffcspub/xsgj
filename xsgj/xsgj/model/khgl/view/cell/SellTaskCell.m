//
//  SellTaskCell.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SellTaskCell.h"

@interface SellTaskCell ()

- (void)_initialize;

@end

@implementation SellTaskCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([SellTaskCell class]) bundle:nil];
}

+ (CGFloat)cellHeight
{
    return 56.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _initialize];
    
    [super awakeFromNib];
}

- (void)_initialize
{
    //TODO: 设置所有控件默认风格
    
}

@end

@implementation SellTaskCell (BindData)

- (void)configureForData:(id)data;
{
    // TODO: 设置数据
    
}

@end
