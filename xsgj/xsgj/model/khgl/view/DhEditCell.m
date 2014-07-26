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

- (void)setCellWithValue:(OrderItemBean *)commitBean
{    
    self.commitData = commitBean;
    self.lbName.text = commitBean.PROD_NAME;
    self.lbNumber.text = [NSString stringWithFormat:@"%d",commitBean.ITEM_NUM];
    self.tfPrice.text = [NSString stringWithFormat:@"%f",commitBean.ITEM_PRICE];
    self.tfSubNum.text = [NSString stringWithFormat:@"%d",commitBean.ITEM_NUM];
    self.tfUnit.text = commitBean.UNIT_NAME;
    self.tfZpName.text = commitBean.GIFT_NAME;
    self.tfZpPrice.text = [NSString stringWithFormat:@"%d",commitBean.GIFT_PRICE];
    self.tfZpNum.text = [NSString stringWithFormat:@"%d",commitBean.GIFT_NUM];
}

- (IBAction)handleDelete:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnDelClicked:)])
    {
        [self.delegate onBtnDelClicked:self];
    }
}

- (IBAction)handleBtnUnitClicked:(id)sender {
    NSMutableArray *unitNames = [[NSMutableArray alloc] init];
    NSArray *aryUnitBean = [BNUnitBean searchWithWhere:[NSString stringWithFormat:@"PROD_ID=%D",self.commitData.PROD_ID] orderBy:@"UNIT_ORDER" offset:0 count:100];
    for(BNUnitBean *bean in aryUnitBean)
    {
        [unitNames addObject:bean.UNITNAME];
    }
    
    LeveyPopListView *popView = [[LeveyPopListView alloc] initWithTitle:@"选择单位" options:unitNames handler:^(NSInteger anIndex) {
        self.tfUnit.text = [unitNames objectAtIndex:anIndex];
        self.commitData.UNIT_NAME = [unitNames objectAtIndex:anIndex];
    }];
    
    [popView showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view animated:NO];
}

@end
