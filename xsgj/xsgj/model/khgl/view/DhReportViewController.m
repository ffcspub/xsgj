//
//  DhReportViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DhReportViewController.h"
#import "DhSelectTreeViewController.h"

@interface DhReportViewController ()

@end

@implementation DhReportViewController

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
    
    self.title = @"订货上报";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleBtnTypeClicked:(id)sender {
    DhSelectTreeViewController *selectTreeViewController = [[DhSelectTreeViewController alloc] initWithNibName:@"SelectTreeViewController" bundle:nil];
    [self.navigationController pushViewController:selectTreeViewController animated:YES];
}

@end
