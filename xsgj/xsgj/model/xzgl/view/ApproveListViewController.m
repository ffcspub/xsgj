//
//  ApproveListViewController.m
//  xsgj
//
//  Created by ilikeido on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ApproveListViewController.h"
#import "XZGLAPI.h"
#import "MBProgressHUD+Add.h"
#import "TripApprovalVC.h"
#import "LeaveApprovalViewController.h"

@interface ApproveListViewController ()

@end

@implementation ApproveListViewController

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
    _viewContain.layer.borderColor = HEX_RGB(0xd3d3d3).CGColor;
    _viewContain.layer.borderWidth = 1.0;
    
    [self loadApproveCount];
}

-(void)loadApproveCount{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    QueryApproveCountHttpRequest *request = [[QueryApproveCountHttpRequest alloc]init];
    [XZGLAPI queryApproveCountByRequest:request success:^(QueryApproveCountHttpResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        _lb_levelCount.text = response.QUERYAPPROVECOUNT.LEAVECOUNT;
        _lb_businessCount.text = response.QUERYAPPROVECOUNT.BUSINESSCOUNT;
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showLevelApproveView:(id)sender {
    LeaveApprovalViewController *vc = [[LeaveApprovalViewController alloc]init];
    vc.title = @"请假审批";
    [self.navigationController pushViewController: vc animated:YES];
}


- (IBAction)showTripApprveView:(id)sender {
    TripApprovalVC *vc = [[TripApprovalVC alloc]init];
    vc.title = @"出差审批";
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
}

@end
