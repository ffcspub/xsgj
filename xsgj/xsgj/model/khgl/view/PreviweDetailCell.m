//
//  PreviweDetailCell.m
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "PreviweDetailCell.h"

@implementation PreviweDetailCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellValue:(NSArray *)test
{
    self.lbNumber.text = [test objectAtIndex:0];
    self.lbUnit.text = [test objectAtIndex:1];
    self.lbDate.text = [test objectAtIndex:2];
}

- (IBAction)handleBtnModifyClicked:(id)sender {
}

- (IBAction)handleBtnCancelClicked:(id)sender {
}

@end
