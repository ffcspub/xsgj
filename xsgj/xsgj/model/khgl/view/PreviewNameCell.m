//
//  PreviewNameCell.m
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "PreviewNameCell.h"

@implementation PreviewNameCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellValue:(KcCommitData *)commitData
{
    self.lbName.text = commitData.PROD_NAME;
}

@end
