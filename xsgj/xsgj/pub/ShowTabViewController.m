//
//  ShowTabViewController.m
//  yikezhong
//
//  Created by hesh on 14-1-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ShowTabViewController.h"
#import "AppDelegate.h"

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
	// Do any additional setup after loading the view.
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
