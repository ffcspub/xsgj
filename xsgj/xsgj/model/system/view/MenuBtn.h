//
//  MenuBtn.h
//  xsgj
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNMobileMenu;

@interface MenuButton : UIButton

@property(nonatomic,strong) BNMobileMenu *menu;

@end

@interface MenuBtn : UIView{
    MenuButton *_btn;
    UILabel *_lable;
}

@property(nonatomic,strong) BNMobileMenu *menu;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
