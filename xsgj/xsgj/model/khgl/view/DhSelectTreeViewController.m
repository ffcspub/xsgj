//
//  DhSelectTreeViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DhSelectTreeViewController.h"
#import "DhEditViewController.h"

@interface DhSelectTreeViewController ()

@end

@implementation DhSelectTreeViewController

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
    
//    [self showRightBarButtonItemWithTitle:@"添加" target:self action:@selector(handleNavBarRight)];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    DhEditViewController *viewController = [[DhEditViewController alloc] initWithNibName:@"DhEditViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
