//
//  CornerCell.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "CornerCell.h"

@interface CornerCell ()

@property (strong, nonatomic) UIImageView *ivBackground;
@property (strong, nonatomic) UIImageView *ivBackgroundSelect;

- (void)_setup;

@end

@implementation CornerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _setup];
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)_setup
{
    self.ivBackground = [[UIImageView alloc] initWithFrame:self.bounds];
    self.ivBackgroundSelect = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundView = self.ivBackground;
    self.selectedBackgroundView = self.ivBackgroundSelect;
    
    self.cellStyle = SINGLE;
}

- (void)setCellStyle:(CornerCellStyle)cellStyle
{
    _cellStyle = cellStyle;
    switch (cellStyle) {
        case TOP:{
            UIImage *image = [UIImage imageNamed:@"table_part1"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            self.ivBackground.image = image;
            
            UIImage *imageSelect = [UIImage imageNamed:@"table_part1_s"];
            imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            self.ivBackgroundSelect.image = imageSelect;
        }
        break;
        case MID:{
            UIImage *image = [UIImage imageNamed:@"table_part2"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            self.ivBackground.image = image;
            
            UIImage *imageSelect = [UIImage imageNamed:@"table_part2_s"];
            imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            self.ivBackgroundSelect.image = imageSelect;
        }
        break;
        case BOT:{
            UIImage *image = [UIImage imageNamed:@"table_part3"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            self.ivBackground.image = image;
            
            UIImage *imageSelect = [UIImage imageNamed:@"table_part3_s"];
            imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            self.ivBackgroundSelect.image = imageSelect;
        }
        break;
        case SINGLE:{
            UIImage *image = [UIImage imageNamed:@"table_main_n"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            self.ivBackground.image = image;
            
            UIImage *imageSelect = [UIImage imageNamed:@"table_main_s"];
            imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            self.ivBackgroundSelect.image = imageSelect;
        }
        break;
        default:
            break;
    }
}

@end
