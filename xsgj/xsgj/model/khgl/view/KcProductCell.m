//
//  KcProductCell.m
//  xsgj
//
//  Created by chenzf on 14-7-22.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KcProductCell.h"

@implementation KcProductCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleBtnSelect:(id)sender {
    self.btnSelect.selected = !self.btnSelect.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnSelectClicked:)])
    {
        [self.delegate onBtnSelectClicked:self];
    }
}

@end
