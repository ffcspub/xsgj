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
    BOT = 2,
    SINGLE
};

/**
 *  出差查询cell
 */
@interface TripQueryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivState;
@property (weak, nonatomic) IBOutlet UILabel *lblState;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblPrompt;

@property (nonatomic, assign) TripQueryCellStyle cellStyle;

@property (nonatomic, assign) BOOL isApproval;

+ (UINib *)nib;

+ (CGFloat)cellHeight;

@end

@interface TripQueryCell (BindData)

- (void)configureForData:(id)data;

@end


