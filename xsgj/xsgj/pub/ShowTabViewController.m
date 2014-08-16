//
//  ShowTabViewController.m
//  yikezhong
//
//  Created by hesh on 14-1-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ShowTabViewController.h"
#import "AppDelegate.h"
#import "SIAlertView.h"

@interface ShowTabViewController ()

@end

@implementation ShowTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_OR_LATER) {
        [self.navigationController.navigationBar setTranslucent:NO];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
#endif
//    UIButton *button = [self defaultBackButtonWithTitle:@"退出"];
//    [button addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	// Do any additional setup after loading the view.
}

-(UIButton *)defaultBackButtonWithTitle:(NSString *)title{
    UIButton *button = [self defaultRightButtonWithTitle:title];
    return button;
}

-(UIButton *)defaultRightButtonWithTitle:(NSString *)title{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 35)];
    [btn setBackgroundImage:IMG_BTN_BLUE forState:UIControlStateNormal];
    [btn setBackgroundImage:IMG_BTN_BLUE_S forState:UIControlStateHighlighted];
    [btn setBackgroundImage:IMG_BTN_BLUE_D forState:UIControlStateDisabled];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}


-(void)exitAction{
    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"确定退出系统？"
                                          cancelButtonTitle:@"取消"
                                              cancelHandler:^(SIAlertView *alertView) {}
                                     destructiveButtonTitle:@"确定"
                                         destructiveHandler:^(SIAlertView *alertView) {
                                             [self exitApplication];
                                         }];
    [alert show];
}

// 退出程序
- (void)exitApplication
{
    UIWindow *window =  [UIApplication sharedApplication].delegate.window;
    [UIView animateWithDuration:0.5f animations:^
     {
         window.alpha = 0;
         window.frame = CGRectMake(CGRectGetWidth(window.frame)/2,CGRectGetHeight(window.frame)/2,1, 1);
     }
                     completion:^(BOOL finished)
     {
         exit(0);
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//    if (IOS7_OR_LATER) {
//        self.navigationController.navigationBar.translucent = YES;
//    }
//#endif
    [((AppDelegate *)[UIApplication sharedApplication].delegate) showTabView];
    [super viewWillAppear:animated];
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    self.navigationItem.titleView = button;
}

- (UIButton *)titleButton{
    if ([self.navigationItem.titleView isKindOfClass:[UIButton class]]) {
        return (UIButton *)self.navigationItem.titleView;
    }
    return nil;
}

@end
