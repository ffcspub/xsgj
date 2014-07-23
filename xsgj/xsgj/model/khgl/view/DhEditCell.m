//
//  DhEditCell.m
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DhEditCell.h"

@implementation DhEditCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleDelete:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnDelClicked:)])
    {
        [self.delegate onBtnDelClicked:self];
    }
}

@end
