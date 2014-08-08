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
            self.ivBackground.image = [ShareValue tablePart1];
            self.ivBackgroundSelect.image = [ShareValue tablePart1S];
        }
        break;
        case MID:{
            self.ivBackground.image = [ShareValue tablePart2];
            self.ivBackgroundSelect.image = [ShareValue tablePart2S];
        }
        break;
        case BOT:{
            self.ivBackground.image = [ShareValue tablePart3];
            self.ivBackgroundSelect.image = [ShareValue tablePart3S];
        }
        break;
        case SINGLE:{
            self.ivBackground.image = [ShareValue tablePart];
            self.ivBackgroundSelect.image = [ShareValue tablePartS];;
        }
        break;
        default:
            break;
    }
}

@end
