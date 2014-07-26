//
//  DhPreviweDetailCell.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DhPreviweDetailCell.h"

@implementation DhPreviweDetailCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellValue:(OrderItemBean *)commitData
{
    commitData.GIFT_TOTAL = commitData.GIFT_NUM * commitData.GIFT_PRICE;
    commitData.TOTAL_PRICE = commitData.ITEM_NUM * commitData.ITEM_PRICE;
    
    self.cellCommitBean = commitData;
    self.lbPrice.text = [NSString stringWithFormat:@"%0.001f",commitData.ITEM_PRICE];
    self.lbNumber.text = [NSString stringWithFormat:@"%d",commitData.ITEM_NUM];
    self.lbUnit.text = commitData.UNIT_NAME;
    self.lbZpName.text = commitData.GIFT_NAME;
    self.lbZpNumber.text = [NSString stringWithFormat:@"%d",commitData.GIFT_NUM];
    self.lbZpUnit.text = commitData.GIFT_UNIT_NAME;
    self.lbZpTotalPrice.text = [NSString stringWithFormat:@"%0.001f",commitData.GIFT_TOTAL];
    self.lbProductPrice.text = [NSString stringWithFormat:@"%0.001f",commitData.TOTAL_PRICE];
}

- (IBAction)handleBtnModifyClicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnModifyClicked:)])
    {
        [self.delegate onBtnModifyClicked:self];
    }
}

- (IBAction)handleBtnCancelClicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnCancelClicked:)])
    {
        [self.delegate onBtnCancelClicked:self];
    }
}

@end
