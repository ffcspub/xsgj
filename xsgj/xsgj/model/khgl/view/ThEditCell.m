//
//  ThEditCell.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ThEditCell.h"

@implementation ThCommitData
@end

@implementation ThEditCell

- (void)awakeFromNib
{
    // Initialization code
    [self.btnPhoto setBackgroundImage:IMG_BTN_BLUE forState:UIControlStateNormal];
    [self.btnPhoto setBackgroundImage:IMG_BTN_BLUE_S forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithValue:(ThCommitData *)commitBean
{
    self.thCommitData = commitBean;
    self.lbName.text = [NSString stringWithFormat:@"%@(%@)",commitBean.PRODUCT_NAME,commitBean.SPEC];
    self.lbNumber.text = [NSString stringWithFormat:@"%d",commitBean.ITEM_NUM];
    self.tfNumber.text = [NSString stringWithFormat:@"%d",commitBean.ITEM_NUM];
    self.lbUnit.text = commitBean.PRODUCT_UNIT_NAME;
    self.lbDate.text = commitBean.BATCH;
    self.tfReson.text = commitBean.REMARK;
    self.ivPhoto.image = commitBean.PhotoImg;
    
    if(commitBean.ITEM_NUM < 0)
    {
        self.lbNumber.text = @"0";
        self.tfNumber.text = @"";
    }
}

- (IBAction)handleBtnUnitClicked:(id)sender {
    NSMutableArray *unitNames = [[NSMutableArray alloc] init];
    NSArray *aryUnitBean = [BNUnitBean searchWithWhere:[NSString stringWithFormat:@"PROD_ID=%D",self.thCommitData.PROD_ID] orderBy:@"UNIT_ORDER" offset:0 count:100];
    for(BNUnitBean *bean in aryUnitBean)
    {
        [unitNames addObject:bean.UNITNAME];
    }
    
    LeveyPopListView *popView = [[LeveyPopListView alloc] initWithTitle:@"选择单位" options:unitNames handler:^(NSInteger anIndex) {
        self.lbUnit.text = [unitNames objectAtIndex:anIndex];
        self.thCommitData.PRODUCT_UNIT_NAME = [unitNames objectAtIndex:anIndex];
    }];
    
    [popView showInView:[UIApplication sharedApplication].delegate.window animated:NO];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == self.tfNumber)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL bNumber = [string isEqualToString:filtered];
        
        if(!bNumber)
        {
            return NO;
        }
        
        if(textField.text.length < 9 || [string isEqualToString:@""])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    if(textField == self.tfReson)
    {
        if(textField.text.length < 25 || [string isEqualToString:@""])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.tfNumber)
    {
        self.thCommitData.ITEM_NUM = textField.text.intValue;
        self.lbNumber.text = textField.text;
    }
    else if(textField == self.tfReson)
    {
        self.thCommitData.REMARK = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tfNumber resignFirstResponder];
    [self.tfReson resignFirstResponder];
    return NO;
}


@end
