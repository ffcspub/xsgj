//
//  CusVisitCell.m
//  xsgj
//
//  Created by chenzf on 14-7-16.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "CusVisitCell.h"

@implementation CusVisitCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSyncState:(int)syncState{
    _syncState = syncState;
    if (syncState == 1) {
        _ivStatus.image = [UIImage imageNamed:@"stateicon_nopass"];
    }else if (syncState == 2){
        _ivStatus.image = [UIImage imageNamed:@"CheckBox_Selected"];
    }else{
        _ivStatus.image = [UIImage imageNamed:@"CheckBox_unSelected"];
    }
}

@end
