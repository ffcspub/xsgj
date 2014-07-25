//
//  DhPreviweDetailCell.h
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItemBean.h"

@interface DhPreviweDetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbUnit;
@property (weak, nonatomic) IBOutlet UILabel *lbZpName;
@property (weak, nonatomic) IBOutlet UILabel *lbZpNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbZpUnit;
@property (weak, nonatomic) IBOutlet UILabel *lbZpTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbProductPrice;


- (void)setCellValue:(OrderItemBean *)commitData;
- (IBAction)handleBtnModifyClicked:(id)sender;
- (IBAction)handleBtnCancelClicked:(id)sender;

@end
