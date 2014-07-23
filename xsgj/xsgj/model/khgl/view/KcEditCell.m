//
//  KcEditCell.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KcEditCell.h"

@implementation KcEditCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleBtnAddClicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnAddClicked:)])
    {
        [self.delegate onBtnAddClicked:self];
    }
}

- (IBAction)handleBtnReduceClicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnDelClicked:)])
    {
        [self.delegate onBtnDelClicked:self];
    }
}

- (IBAction)handleBtnPhotoClicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnPhotoClicked:)])
    {
        [self.delegate onBtnPhotoClicked:self];
    }
}

@end
