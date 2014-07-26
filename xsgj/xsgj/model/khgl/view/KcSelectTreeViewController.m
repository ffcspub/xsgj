//
//  KcSelectTreeViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KcSelectTreeViewController.h"

@interface KcSelectTreeViewController ()

@end

@implementation KcSelectTreeViewController

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
    // Do any additional setup after loading the view.
    
    [self showRightBarButtonItemWithTitle:@"确认" target:self action:@selector(handleNavBarRight)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - functions

- (void)handleNavBarRight
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTPRODUCT_FIN object:self.selectInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
