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
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = kCFNumberFormatterRoundFloor;
    [numberFormatter setPositiveFormat:@"0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:0.99696]];
    
    self.tfPrice.text = [NSString stringWithFormat:@"%0.001f",commitBean.ITEM_PRICE];
    self.tfSubNum.text = [NSString stringWithFormat:@"%d",commitBean.ITEM_NUM];
    self.lbUnit.text = commitBean.UNIT_NAME;
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
        self.lbUnit.text = [unitNames objectAtIndex:anIndex];
        self.commitData.UNIT_NAME = [unitNames objectAtIndex:anIndex];
    }];
    
    [popView showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view animated:NO];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _tfPrice)
    {
        self.commitData.ITEM_PRICE = textField.text.doubleValue;
        
    }
    else if(textField == _tfSubNum)
    {
        self.commitData.ITEM_NUM = textField.text.intValue;
        self.lbNumber.text = textField.text;
    }
    else if(textField == _tfZpName)
    {
        self.commitData.GIFT_NAME = textField.text;
    }
    else if(textField == _tfZpPrice)
    {
        self.commitData.GIFT_PRICE = textField.text.intValue;
    }
    else if(textField == _tfZpNum)
    {
        self.commitData.GIFT_NUM = textField.text.intValue;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tfPrice resignFirstResponder];
    [_tfSubNum resignFirstResponder];
    [_tfZpName resignFirstResponder];
    [_tfZpPrice resignFirstResponder];
    [_tfZpNum resignFirstResponder];
    return NO;
}


@end
