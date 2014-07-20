//
//  TripQueryCell.m
//  xsgj
//
//  Created by xujunwen on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TripQueryCell.h"
#import "TripInfoBean.h"

@interface TripQueryCell ()

@property (strong, nonatomic) UIImageView *ivBackground;
@property (strong, nonatomic) UIImageView *ivBackgroundSelect;

- (void)_initialize;

@end

@implementation TripQueryCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([TripQueryCell class]) bundle:nil];
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
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    //TODO: 设置所有控件默认风格
    self.lblTitle.backgroundColor = [UIColor clearColor];
    self.lblDetail.backgroundColor = [UIColor clearColor];
    
    // 设置选中效果
    self.ivBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 56)];
    self.ivBackgroundSelect = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 56)];
    self.backgroundView = self.ivBackground;
    self.selectedBackgroundView = self.ivBackgroundSelect;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.cellStyle = TOP;
}

- (void)setCellStyle:(TripQueryCellStyle)cellStyle
{
    _cellStyle = cellStyle;
    switch (cellStyle) {
        case TOP:{
            UIImage *image = [UIImage imageNamed:@"table_part1"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5,5, 5) ];
            self.ivBackground.image = image;
            
            UIImage *imageSelect = [UIImage imageNamed:@"table_part1_s"];
            imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5,5, 5) ];
            self.ivBackgroundSelect.image = imageSelect;
        }
            break;
        case MID:{
            UIImage *image = [UIImage imageNamed:@"table_part2"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) ];
            self.ivBackground.image = image;
            
            UIImage *imageSelect = [UIImage imageNamed:@"table_part2_s"];
            imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5,5, 5) ];
            self.ivBackgroundSelect.image = imageSelect;
        }
            break;
        case BOT:{
            UIImage *image = [UIImage imageNamed:@"table_part3"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) ];
            self.ivBackground.image = image;
            
            UIImage *imageSelect = [UIImage imageNamed:@"table_part3_s"];
            imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5,5, 5) ];
            self.ivBackgroundSelect.image = imageSelect;
        }
            break;
        default:
            break;
    }
}

@end

@implementation TripQueryCell (BindData)

- (void)configureForData:(id)data;
{
    // TODO: 设置数据
    TripInfoBean *bean = (TripInfoBean *)data;
    self.lblTitle.text = bean.USER_NAME;
    self.lblDetail.text = bean.APPLY_TIME;
    
    // 0:未审批 1:已通过 2:未通过
    if ([bean.APPROVE_STATE intValue] == 0) {
        self.lblState.text = @"待审";
        self.ivState.image = [UIImage imageNamed:@"stateicon_wait"];
    } else if ([bean.APPROVE_STATE intValue] == 1) {
        self.lblState.text = @"通过";
        self.ivState.image = [UIImage imageNamed:@"stateicon_pass"];
    } else {
        self.lblState.text = @"驳回";
        self.ivState.image = [UIImage imageNamed:@"stateicon_nopass"];
    }
}

@end
