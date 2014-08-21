//
//  VisitProjectCell.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "VisitProjectCell.h"
#import "OfflineRequestCache.h"

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
        NSArray *aryCache = [OfflineRequestCache searchWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@'",record.VISIT_NO] orderBy:@"VISIT_DATE desc" offset:0 count:100];
        if(aryCache.count > 0)
        {
            strState = @"上报中";
        }
        else
        {
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
    }
    
    if([strState isEqualToString:@"未拜访"])
    {
        _ivStatus.image = [UIImage imageNamed:@"statebtnicon_wait"];
        self.lbStatus.textColor = MCOLOR_BLUE;
    }
    else if([strState isEqualToString:@"上报中"])
    {
        _ivStatus.image = [UIImage imageNamed:@"stateicon_nopass"];
        self.lbStatus.textColor = MCOLOR_ORGLE;
    }
    else
    {
        _ivStatus.image = [UIImage imageNamed:@"statebtnicon_finish"];
        self.lbStatus.textColor = MCOLOR_GRAY;
    }
    
    self.lbStatus.text = strState;
}

@end
