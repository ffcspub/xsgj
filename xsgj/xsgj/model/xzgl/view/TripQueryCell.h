//
//  TripQueryCell.h
//  xsgj
//
//  Created by xujunwen on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, TripQueryCellStyle) {
    TOP = 0,
    MID = 1,
    BOT = 2
};

/**
 *  出差查询cell
 */
@interface TripQueryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivState;
@property (weak, nonatomic) IBOutlet UILabel *lblState;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@property (nonatomic, assign) TripQueryCellStyle cellStyle;

+ (UINib *)nib;

@end

@interface TripQueryCell (BindData)

- (void)configureForData:(id)data;

@end


