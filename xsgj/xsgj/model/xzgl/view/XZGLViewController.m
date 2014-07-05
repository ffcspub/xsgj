//
//  XZGLViewController.m
//  xsgj
//
//  Created by mac on 14-7-4.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "XZGLViewController.h"

@interface XZGLViewController ()

@end

@implementation XZGLViewController

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
	return @"MenuIcon_Routine_unSelected";
}

- (NSString *)selectedTabImageName
{
	return @"MenuIcon_Routine_Selected";
}


- (NSString *)tabTitle
{
	return @"行政管理";
}

-(NSString *)title{
    return [self tabTitle];
}

@end
