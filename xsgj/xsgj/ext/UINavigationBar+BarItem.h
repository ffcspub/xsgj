//
//  UINavigationBar+BarItem.h
//  jiulifang
//
//  Created by hesh on 13-10-29.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNavigationBar : UINavigationBar

@end

@interface UINavigationBar (Codoon)
-(void)drawRect:(CGRect)rect;
@end

@interface UIViewController (Codoon)

- (void)showLeftBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action ;

- (void)showRightBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action ;

- (void)showLeftBarButtonItemWithImage:(NSString *)image target:(id)target action:(SEL)action ;

- (void)showRightBarButtonItemWithImage:(NSString *)image target:(id)target action:(SEL)action ;

- (void)setTitleButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end