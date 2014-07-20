//
//  BorderView.m
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "BorderView.h"
#import "NSString+URL.h"

@interface BorderView ()

- (void)_initialize;

@property (nonatomic, strong) UIImageView *ivBackground;

@end

@implementation BorderView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
    
	return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
	[self _initialize];
}
 
#pragma mark - Private

- (void)_initialize
{
    if (!self.ivBackground) {
        UIImageView *ivBackground = [[UIImageView alloc] initWithFrame:self.bounds];
        ivBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:ivBackground];
        [self sendSubviewToBack:ivBackground];
        self.ivBackground = ivBackground;
    }
    
    self.borderStyle = BorderViewStyleRoundCorner;
}

#pragma mark - 访问器

- (void)setBorderStyle:(BorderViewStyle)style
{
    if (_borderStyle != style) {
        _borderStyle = style;
        
		switch (style) {
			case BorderViewStyleGroupSingle:
			{
				UIImage *imgOrigin = [UIImage imageNamed:@"table_main"];
				self.ivBackground.image = [imgOrigin resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
			}
			break;
			case BorderViewStyleGroupTop:
			{
                UIImage *imgOrigin = [UIImage imageNamed:@"table_part1"];
				self.ivBackground.image = [imgOrigin resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
			}
			break;
            case BorderViewStyleGroupMiddle:
			{
                UIImage *imgOrigin = [UIImage imageNamed:@"table_part2"];
				self.ivBackground.image = [imgOrigin resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
			}
                break;
            case BorderViewStyleGroupBottom:
			{
                UIImage *imgOrigin = [UIImage imageNamed:@"table_part3"];
				self.ivBackground.image = [imgOrigin resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
			}
            break;
            case BorderViewStyleMutableColumn:
			{
                UIImage *imgOrigin = [UIImage imageNamed:@"bgNo2"];
				self.ivBackground.image = [imgOrigin resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 5) resizingMode:UIImageResizingModeStretch];
			}
            break;
            case BorderViewStyleMutableColumn1:
			{
                UIImage *imgOrigin = [UIImage imageNamed:@"bgNo1"];
				self.ivBackground.image = [imgOrigin resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 5) resizingMode:UIImageResizingModeStretch];
			}
            break;
            case BorderViewStyleRoundCorner:
			{
                UIImage *imgOrigin = [UIImage imageNamed:@"日期选择控件背板"];
				self.ivBackground.image = [imgOrigin resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
			}
            break;
			default:
				break;
		}
    }
}

@end
