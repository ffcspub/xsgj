//
//  UINavigationBar+BarItem.m
//  jiulifang
//
//  Created by hesh on 13-10-29.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "UINavigationBar+BarItem.h"

@implementation MyNavigationBar

- (void)drawRect:(CGRect)rect {
   [super drawRect:rect];
}
@end

@implementation UINavigationBar (Codoon)

+ (Class)class {
    if (IOS7_OR_LATER) {
        return [super class];
    }else{
        return NSClassFromString(@"MyNavigationBar");
    }
}

-(void)drawRect:(CGRect)rect
{
    if (IOS7_OR_LATER) {
        [super drawRect:rect];
    }else{
        [[UIImage imageNamed:@"MyNavigationBar"]drawInRect:rect];
    }
}

@end


@implementation UIViewController (Codoon)

- (void)showLeftBarButtonItemWithImage:(NSString *)imageName target:(id)target action:(SEL)action {
    UIImage *image = [UIImage imageNamed:imageName];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width + 10.0f, self.navigationController.navigationBar.frame.size.height);
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentMode = UIViewContentModeScaleAspectFit;
	button.backgroundColor = [UIColor clearColor];
    button.frame = buttonFrame;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)showRightBarButtonItemWithImage:(NSString *)imageName target:(id)target action:(SEL)action {
    UIImage *image = [UIImage imageNamed:imageName];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width + 10.0f, self.navigationController.navigationBar.frame.size.height);
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentMode = UIViewContentModeScaleAspectFit;
	button.backgroundColor = [UIColor clearColor];
    button.frame = buttonFrame;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)showLeftBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100, 44)];
    CGRect buttonFrame = CGRectMake(0, 0, size.width + 20.0f, self.navigationController.navigationBar.frame.size.height);
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentMode = UIViewContentModeScaleAspectFit;
	button.backgroundColor = [UIColor clearColor];
    button.frame = buttonFrame;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)showRightBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100, 44)];
    CGRect buttonFrame = CGRectMake(0, 0, size.width + 20.0f, self.navigationController.navigationBar.frame.size.height);
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentMode = UIViewContentModeScaleAspectFit;
	button.backgroundColor = [UIColor clearColor];
    button.frame = buttonFrame;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)setTitleButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
}

@end