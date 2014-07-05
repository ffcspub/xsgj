//
//  HideTabViewController.m
//  yikezhong
//
//  Created by hesh on 14-1-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"
#import "AppDelegate.h"

@interface HideTabViewController ()

@end

@implementation HideTabViewController

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
    [self showLeftBarButtonItemWithImage:@"btn_back" target:self action:@selector(backAction)];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_OR_LATER) {
         [self.navigationController.navigationBar setTranslucent:NO];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //        self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    }
#endif
//    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont, nil];
//    if (!IOS7_OR_LATER) {
//        self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
//    }
	// Do any additional setup after loading the view.
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [((AppDelegate *)[UIApplication sharedApplication].delegate) hideTabView];
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    self.navigationItem.titleView = button;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)titleButton{
    if ([self.navigationItem.titleView isKindOfClass:[UIButton class]]) {
        return (UIButton *)self.navigationItem.titleView;
    }
    return nil;
}

@end
