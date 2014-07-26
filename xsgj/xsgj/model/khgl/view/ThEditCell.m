//
//  ThEditCell.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ThEditCell.h"

@implementation ThEditCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithValue:(OrderBackDetailBean *)commitBean
{
    self.thCommitData = commitBean;
    self.lbName.text = [NSString stringWithFormat:@"%@(%@)",commitBean.PRODUCT_NAME,commitBean.SPEC];
    self.lbNumber.text = [NSString stringWithFormat:@"%d",commitBean.ITEM_NUM];
    self.tfNumber.text = [NSString stringWithFormat:@"%d",commitBean.ITEM_NUM];
    self.tfUnit.text = commitBean.PRODUCT_UNIT_NAME;
    self.tfDate.text = commitBean.BATCH;
    self.tfReson.text = commitBean.REMARK;
}

- (IBAction)handleBtnUnitClicked:(id)sender {
    NSMutableArray *unitNames = [[NSMutableArray alloc] init];
    NSArray *aryUnitBean = [BNUnitBean searchWithWhere:[NSString stringWithFormat:@"PROD_ID=%D",self.thCommitData.PROD_ID] orderBy:@"UNIT_ORDER" offset:0 count:100];
    for(BNUnitBean *bean in aryUnitBean)
    {
        [unitNames addObject:bean.UNITNAME];
    }
    
    LeveyPopListView *popView = [[LeveyPopListView alloc] initWithTitle:@"选择单位" options:unitNames handler:^(NSInteger anIndex) {
        self.tfUnit.text = [unitNames objectAtIndex:anIndex];
        self.thCommitData.PRODUCT_UNIT_NAME = [unitNames objectAtIndex:anIndex];
    }];
    
    [popView showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view animated:NO];
}

//- (IBAction)handleBtnAddClicked:(id)sender {
//    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnAddClicked:)])
//    {
//        [self.delegate onBtnAddClicked:self];
//    }
//}
//
//- (IBAction)handleBtnReduceClicked:(id)sender {
//    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnDelClicked:)])
//    {
//        [self.delegate onBtnDelClicked:self];
//    }
//}
//
//- (IBAction)handleBtnPhotoClicked:(id)sender {
//    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnPhotoClicked:)])
//    {
//        [self.delegate onBtnPhotoClicked:self];
//    }
//}

@end
