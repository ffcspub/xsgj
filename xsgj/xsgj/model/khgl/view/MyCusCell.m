//
//  MyCusCell.m
//  xsgj
//
//  Created by chenzf on 14-7-28.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "MyCusCell.h"

@implementation MyCusCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithValue:(CustDetailBean *)customerInfo
{
    self.lbName.text = customerInfo.CUST_NAME;
    self.lbType.text = customerInfo.TYPE_NAME;
    if(customerInfo.LASTEST_VISIT.length > 10)
    {
        self.lbVisitTime.text = customerInfo.LASTEST_VISIT;
    }
    else
    {
        self.lbVisitTime.text = @"一周前";
    }
}

@end
