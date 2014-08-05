//
//  DistributionCell.m
//  xsgj
//
//  Created by xujunwen on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DistributionCell.h"
#import "MobileInfoDisBean.h"
#import "UIImage+External.h"

@interface DistributionCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTel;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UIImageView *ivBg;

@property (weak, nonatomic) IBOutlet UILabel *vSP1;
@property (weak, nonatomic) IBOutlet UILabel *vSP2;
@property (weak, nonatomic) IBOutlet UILabel *vSP3;
@property (weak, nonatomic) IBOutlet UILabel *vSP4;


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
    [self.ivBg setImage:[[UIImage imageNamed:@"bgNo2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 20, 20)]];
    [self.ivBg setHighlightedImage:[UIImage imageWithColor:HEX_RGB(0xebf6ff) size:self.ivBg.bounds.size]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.vSP1 setHighlighted:NO];
        [self.vSP2 setHighlighted:NO];
        [self.vSP3 setHighlighted:NO];
        [self.vSP4 setHighlighted:NO];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self.vSP1 setHighlighted:NO];
        [self.vSP2 setHighlighted:NO];
        [self.vSP3 setHighlighted:NO];
        [self.vSP4 setHighlighted:NO];
    }
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

