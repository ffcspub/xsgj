//
//  ThReportViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ThReportViewController.h"
#import "ThEditViewController.h"

@interface ThReportViewController ()

@end

@implementation ThReportViewController

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
    self.title = @"退货上报";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - functions

- (void)handleNavBarRight
{
    ThEditViewController *viewController = [[ThEditViewController alloc] initWithNibName:@"ThEditViewController" bundle:nil];
    viewController.aryData = _aryProductSelect;
    viewController.customerInfo = self.customerInfo;
    viewController.vistRecord = self.vistRecord;
    [self.navigationController pushViewController:viewController animated:YES];
}



@end
