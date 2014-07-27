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
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###0.##"];
    
    self.commitData = commitBean;
    self.lbName.text = [NSString stringWithFormat:@"%@(%@)",commitBean.PROD_NAME,commitBean.SPEC];
    self.lbNumber.text = [NSString stringWithFormat:@"%d",commitBean.ITEM_NUM];
    self.tfPrice.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:commitBean.ITEM_PRICE]];
    self.tfSubNum.text = [NSString stringWithFormat:@"%d",commitBean.ITEM_NUM];
    self.lbUnit.text = commitBean.UNIT_NAME;
    self.tfZpName.text = commitBean.GIFT_NAME;
    self.tfZpNum.text = commitBean.GIFT_NUM;
    self.tfZpUnit.text = commitBean.GIFT_UNIT_NAME;
    self.tfZpPrice.text = commitBean.GIFT_PRICE;
    self.lbTotalPrice.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:commitBean.TOTAL_PRICE]];
    
    if(commitBean.ITEM_NUM < 0)
    {
        self.lbNumber.text = @"0";
        self.tfSubNum.text = @"";
    }
    
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
    
    [popView showInView:[UIApplication sharedApplication].delegate.window animated:NO];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _tfPrice ||
       textField == _tfZpPrice ||
       textField == _tfSubNum ||
       textField == _tfZpNum)
    {
        NSString *strRule = @"0123456789.\n";
        if(textField == _tfSubNum || textField == _tfZpNum)
        {
            strRule = @"0123456789\n";
        }
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:strRule] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL bNumber = [string isEqualToString:filtered];
        if(!bNumber)
        {
            return NO;
        }
        
        if([textField.text rangeOfString:@"."].length > 0)
        {
            if([string isEqualToString:@"."])
            {
                return NO;
            }
        }
    }
    
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    if(textField == _tfPrice || textField == _tfZpPrice)
    {
        const NSInteger limited = 2;
        for (int i = futureString.length-1; i>=0; i--) {
            if ([futureString characterAtIndex:i] == '.') {
            
                if (flag > limited) {
                    return NO;
                }
                
                break;
            }
            flag++;
        }
    }

    return YES;
}

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
    else if(textField == _tfZpNum)
    {
        self.commitData.GIFT_NUM = textField.text;
    }
    else if(textField == _tfZpUnit)
    {
        self.commitData.GIFT_UNIT_NAME = textField.text;
    }
    else if(textField == _tfZpPrice)
    {
        self.commitData.GIFT_PRICE = textField.text;
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###0.##"];
    
    self.commitData.TOTAL_PRICE  = self.commitData.ITEM_PRICE * self.commitData.ITEM_NUM + self.commitData.GIFT_PRICE.doubleValue * self.commitData.GIFT_NUM.intValue;
    self.lbTotalPrice.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:self.commitData.TOTAL_PRICE]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tfPrice resignFirstResponder];
    [_tfSubNum resignFirstResponder];
    [_tfZpName resignFirstResponder];
    [_tfZpUnit resignFirstResponder];
    [_tfZpPrice resignFirstResponder];
    [_tfZpNum resignFirstResponder];
    return NO;
}


@end
