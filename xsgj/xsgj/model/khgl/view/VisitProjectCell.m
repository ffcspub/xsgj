//
//  VisitProjectCell.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "VisitProjectCell.h"

@implementation VisitProjectCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithValue:(BNCustomerInfo *)customerInfo VistRecord:(NSArray *)visitRecord
{
    self.lbName.text = customerInfo.CUST_NAME;
    self.lbAddress.text = customerInfo.ADDRESS;
    
    NSString *strState = @"";
    if(visitRecord.count < 1)
    {
        strState = @"未拜访";
    }
    else
    {
        BNVistRecord *record = [visitRecord objectAtIndex:0];
        if(record.END_TIME.length > 0)
        {
            if(record.VISIT_TYPE == 0)
            {
                strState = @"已临时拜访";
            }
            else
            {
                strState = @"已计划拜访";
            }
        }
        else
        {
            strState = @"未拜访";
        }
    }
    
    if([strState isEqualToString:@"未拜访"])
    {
        self.lbStatus.textColor = [UIColor colorWithRed:146/255.0 green:221/255.0 blue:253/255.0 alpha:1];
    }
    else
    {
        self.lbStatus.textColor = [UIColor lightGrayColor];
    }
    
    self.lbStatus.text = strState;
}

@end
