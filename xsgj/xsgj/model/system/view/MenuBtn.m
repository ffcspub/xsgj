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

@implementation MenuButton

@end

@implementation MenuBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _btn = [[MenuButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_btn.imageView setContentMode:UIViewContentModeCenter];
        [_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:_btn];
        _lable = [[UILabel alloc]init];
        [_lable setFont:[UIFont systemFontOfSize:12]];
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.textColor = [UIColor darkTextColor];
        _lable.backgroundColor = [UIColor clearColor];
        [self addSubview:_lable];
    }
    return self;
}

-(void)setMenu:(BNMobileMenu *)menu{
    _menu = menu;
    UIImage *image = [UIImage imageNamed:menu.ICON];
    image = [image imageByScaleForSize:CGSizeMake(55, 55)];
    CGSize imageSize = image.size;
    [_btn setImage:image  forState:UIControlStateNormal];
    _btn.menu = menu;
    _lable.text = menu.MENU_NAME;
    CGSize titileSize = [_menu.MENU_NAME sizeWithFont:[UIFont systemFontOfSize:12]];
    if (titileSize.width > self.frame.size.width) {
        _lable.frame =CGRectMake(-(titileSize.width - self.frame.size.width)/2, imageSize.height + 20, titileSize.width, 17);
    }else{
        _lable.frame =CGRectMake(0, imageSize.height + 20, self.frame.size.width, 17);
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [_btn addTarget:target action:action forControlEvents:controlEvents];
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
