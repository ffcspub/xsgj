//
//  DhEditSelectTreeViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DhEditSelectTreeViewController.h"

@interface DhEditSelectTreeViewController ()

@end

@implementation DhEditSelectTreeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - functions

- (void)handleNavBarRight
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTPARTNER_FIN object:self.selectInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
