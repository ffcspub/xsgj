//
//  VisitRecordCell.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "VisitRecordCell.h"
#import "VisistRecordVO.h"

@interface VisitRecordCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ivBg;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRealName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEnterTime;
@property (weak, nonatomic) IBOutlet UILabel *lblLeaveTime;

- (void)_initialize;

@end

@implementation VisitRecordCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([VisitRecordCell class]) bundle:nil];
}

+ (CGFloat)cellHeight
{
    return 60.f;
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
}

@end

@implementation VisitRecordCell (BindData)

- (void)configureForData:(id)data;
{
    // TODO: 设置数据
    VisistRecordVO *bean = (VisistRecordVO *)data;
    self.lblTitle.text = bean.CUST_NAME;
    self.lblDate.text = bean.START_DATE;
    self.lblEnterTime.text = [NSString stringWithFormat:@"进店:%@", bean.START_TIME_M];
    self.lblLeaveTime.text = [NSString stringWithFormat:@"进店:%@", bean.END_TIME_M];
    self.lblRealName.text = bean.REALNAME;
}

@end
