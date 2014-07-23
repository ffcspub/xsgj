//
//  CornerCell.h
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CornerCellStyle) {
    TOP = 0,
    MID = 1,
    BOT = 2,
    SINGLE
};

/**
 *  圆角带有选中效果的Cell
 */
@interface CornerCell : UITableViewCell

@property (nonatomic, assign) CornerCellStyle cellStyle;

@end
