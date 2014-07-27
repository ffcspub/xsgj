//
//  DistributionCell.m
//  xsgj
//
//  Created by xujunwen on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DistributionCell.h"
#import "MobileInfoDisBean.h"

@interface DistributionCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTel;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblState;

- (void)_initialize;

@end

@implementation DistributionCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([DistributionCell class]) bundle:nil];
}

+ (CGFloat)cellHeight
{
    return 40.f;
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

@implementation DistributionCell (BindData)

- (void)configureForData:(id)data;
{
    // TODO: 设置数据
    MobileInfoDisBean *bean = (MobileInfoDisBean *)data;
    self.lblOrderNumber.text = bean.DATE_ID;
    self.lblName.text = bean.CUST_NAME;
    self.lblTel.text = bean.PHONE;
    self.lblTime.text = bean.YY_TIME;
    self.lblState.text = bean.STATE_NAME;
}

@end

