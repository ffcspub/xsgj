//
//  SellTaskCell.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SellTaskCell.h"
#import "SaleTaskInfoBean.h"

@interface SellTaskCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTargetMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblCompleteMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblPrecent;


- (void)_initialize;

@end

@implementation SellTaskCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([SellTaskCell class]) bundle:nil];
}

+ (CGFloat)cellHeight
{
    return 45.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _initialize];
    
    [super awakeFromNib];
}

- (void)_initialize
{
    //TODO: 设置所有控件默认风格
    
}

@end

@implementation SellTaskCell (BindData)

- (void)configureForData:(id)data;
{
    // TODO: 设置数据
    SaleTaskInfoBean *bean = (SaleTaskInfoBean *)data;
    self.lblTime.text = bean.SALE_MONTH;
    self.lblTargetMoney.text = bean.SALE_TARGET;
    self.lblCompleteMoney.text = bean.SALE_FINISH;
    self.lblPrecent.text = bean.SALE_PERCENT;
}

@end
