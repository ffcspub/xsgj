//
//  KHGLViewController.m
//  xsgj
//
//  Created by mac on 14-7-4.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KHGLViewController.h"

@interface KHGLViewController ()

@end

@implementation KHGLViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tabbartool
- (NSString *)tabImageName
{
	return @"MenuIcon_UserManager_unSelected";
}

- (NSString *)selectedTabImageName
{
	return @"MenuIcon_UserManager_Selected";
}

- (NSString *)tabTitle
{
	return @"客户管理";
}

-(NSString *)title{
    return [self tabTitle];
}


@end
