//
//  VisitProjectCell.h
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNCustomerInfo.h"
#import "BNVistRecord.h"

@interface VisitProjectCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;

- (void)setCellWithValue:(BNCustomerInfo *)customerInfo VistRecord:(NSArray *)visitRecord;

@end
