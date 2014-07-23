//
//  JpReportViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "JpReportViewController.h"

@interface JpReportViewController ()

@end

@implementation JpReportViewController

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
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"竞品上报";
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(handleNavBarRight)];
    
    [super.svContain setContentSize:CGSizeMake(0, super.svImgContain.frame.origin.y + super.svImgContain.frame.size.height + 10)];
    [super.svImgContain setContentSize:CGSizeMake(super.ivPhoto6.frame.origin.x + super.ivPhoto6.frame.size.width, 0)];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    
}

@end
