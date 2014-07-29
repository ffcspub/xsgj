//
//  KcEditCell.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KcEditCell.h"

@implementation KcCommitData
@end


@implementation KcEditCell

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

- (void)setCellWithValue:(KcCommitData *)commitBean
{
    self.commitData = commitBean;
    self.lbName.text = [NSString stringWithFormat:@"%@(%@)",commitBean.PROD_NAME,commitBean.SPEC];
    self.lbNumber.text = [NSString stringWithFormat:@"%d",commitBean.STOCK_NUM];
    self.tfNumber.text = [NSString stringWithFormat:@"%d",commitBean.STOCK_NUM];
    self.lbUnit.text = commitBean.PRODUCT_UNIT_NAME;
    self.lbDate.text = commitBean.STOCK_NO;
    self.ivPhoto.image = commitBean.PhotoImg;
    
    if(commitBean.STOCK_NUM < 0)
    {
        self.lbNumber.text = @"0";
        self.tfNumber.text = @"";
    }
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

- (IBAction)handleBtnUnitClicked:(id)sender {
    NSMutableArray *unitNames = [[NSMutableArray alloc] init];
    NSArray *aryUnitBean = [BNUnitBean searchWithWhere:[NSString stringWithFormat:@"PROD_ID=%D",self.commitData.PROD_ID] orderBy:@"UNIT_ORDER" offset:0 count:100];
    for(BNUnitBean *bean in aryUnitBean)
    {
        [unitNames addObject:bean.UNITNAME];
    }
    
    LeveyPopListView *popView = [[LeveyPopListView alloc] initWithTitle:@"选择单位" options:unitNames handler:^(NSInteger anIndex) {
        self.lbUnit.text = [unitNames objectAtIndex:anIndex];
        self.commitData.PRODUCT_UNIT_NAME = [unitNames objectAtIndex:anIndex];
    }];
    
    [popView showInView:[UIApplication sharedApplication].delegate.window animated:NO];
}

- (IBAction)handleBtnDate:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnDateClicked:)])
    {
        [self.delegate onBtnDateClicked:self];
    }
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
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.commitData.STOCK_NUM = textField.text.intValue;
    self.lbNumber.text = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tfNumber resignFirstResponder];
    return NO;
}

@end
