//
//  PreviweDetailCell.h
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockCommitBean.h"

#define NOTIFICATION_MODIFY_DATA @"NOTIFICATION_MODIFY_DATA"

@protocol PreviweDetailCellDelegate;

@interface PreviweDetailCell : UITableViewCell


@property (weak, nonatomic) id<PreviweDetailCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbUnit;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (strong, nonatomic) StockCommitBean *cellCommitBean;

- (void)setCellValue:(StockCommitBean *)commitData;
- (IBAction)handleBtnModifyClicked:(id)sender;
- (IBAction)handleBtnCancelClicked:(id)sender;

@end

@protocol PreviweDetailCellDelegate <NSObject>

- (void)onBtnModifyClicked:(PreviweDetailCell *)cell;
- (void)onBtnCancelClicked:(PreviweDetailCell *)cell;

@end
