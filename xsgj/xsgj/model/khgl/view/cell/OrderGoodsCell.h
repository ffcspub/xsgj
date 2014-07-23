//
//  OrderGoodsCell.h
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CornerCell.h"

@interface OrderGoodsCell : CornerCell

+ (UINib *)nib;

+ (CGFloat)cellHeight;

@end

@interface OrderGoodsCell (BindData)

- (void)configureForData:(id)data;

@end
