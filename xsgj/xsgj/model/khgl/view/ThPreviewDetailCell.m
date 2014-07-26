//
//  ThPreviewDetailCell.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ThPreviewDetailCell.h"

@implementation ThPreviewDetailCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellValue:(OrderBackDetailBean *)commitData
{
    self.cellCommitBean = commitData;
    self.lbNumber.text = [NSString stringWithFormat:@"%d",commitData.ITEM_NUM];
    self.lbUnit.text = commitData.PRODUCT_UNIT_NAME;
    self.lbDate.text = commitData.BATCH;
    self.lbReson.text = commitData.REMARK;
    //self.ivPhoto;
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
