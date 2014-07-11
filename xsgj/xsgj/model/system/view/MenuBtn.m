//
//  MenuBtn.m
//  xsgj
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "MenuBtn.h"
#import "BNMobileMenu.h"
#import "UIImage+External.h"

@implementation MenuBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.imageView setContentMode:UIViewContentModeCenter];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return self;
}

-(void)setMenu:(BNMobileMenu *)menu{
    _menu = menu;
    CGSize titileSize = [_menu.MENU_NAME sizeWithFont:[UIFont systemFontOfSize:14]];
    UIImage *image = [UIImage imageNamed:menu.ICON];
    image = [image imageByScaleForSize:CGSizeMake(60, 60)];
    [self setImage:image  forState:UIControlStateNormal];
    [self setTitle:menu.MENU_NAME forState:UIControlStateNormal];
    CGSize imageSize = image.size;
//    self.imageEdgeInsets = UIEdgeInsetsMake(0, (selfSize.width - imageSize.width)/2, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height + 15, -imageSize.width - (imageSize.width - titileSize.width)/2 - 11, 0, 0) ;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
