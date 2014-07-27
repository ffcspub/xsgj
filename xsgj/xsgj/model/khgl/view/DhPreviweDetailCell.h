//
//  DhPreviweDetailCell.h
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItemBean.h"
#import "PreviweDetailCell.h"

@protocol DhPreviweDetailCellDelegate;

@interface DhPreviweDetailCell : UITableViewCell


@property (weak, nonatomic) id<DhPreviweDetailCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *lbSpec;

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbUnit;
@property (weak, nonatomic) IBOutlet UILabel *lbZpName;
@property (weak, nonatomic) IBOutlet UILabel *lbZpNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbZpUnit;
@property (weak, nonatomic) IBOutlet UILabel *lbZpTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbProductPrice;
@property (strong, nonatomic) OrderItemBean *cellCommitBean;

- (void)setCellValue:(OrderItemBean *)commitData;
- (IBAction)handleBtnModifyClicked:(id)sender;
- (IBAction)handleBtnCancelClicked:(id)sender;

@end

@protocol DhPreviweDetailCellDelegate <NSObject>

- (void)onBtnModifyClicked:(DhPreviweDetailCell *)cell;
- (void)onBtnCancelClicked:(DhPreviweDetailCell *)cell;

@end
