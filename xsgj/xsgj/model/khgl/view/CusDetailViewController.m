//
//  CusDetailViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "CusDetailViewController.h"
#import "CusVisitViewController.h"
#import "SIAlertView.h"
#import "InfoCollectViewController.h"

@interface CusDetailViewController ()

@end

@implementation CusDetailViewController

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

- (void)initView
{
    self.title = @"客户详情";
    [self showRightBarButtonItemWithTitle:@"进入" target:self action:@selector(handleNavBarRight)];
    [self.svContain setContentSize:CGSizeMake(320, self.ivPhoto.frame.origin.y + self.ivPhoto.frame.size.height + 15)];
    
    self.lbName.text = self.customerInfo.CUST_NAME;
    self.lbType.text = self.customerInfo.TYPE_NAME;
    self.lbLinkMan.text = self.customerInfo.LINKMAN;
    self.lbMobile.text = self.customerInfo.TEL;
    self.lbAddress.text = self.customerInfo.ADDRESS;
    
    if(self.visitRecord)
    {
        self.lbVisitTime.text = self.visitRecord.END_TIME;
    }
    
    // chenzftodo: 图片如何获取
    //self.ivPhoto = self.customerInfo.CUST_NAME;;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - functions

- (void)handleNavBarRight
{
    if(![_strDateSelect isEqualToString:[[NSDate date]stringWithFormat:@"yyyy-MM-dd"]])
    {
        [MBProgressHUD showError:@"只能拜访当天的客户" toView:self.view];
        return;
    }
    
    if(_customerInfo.LAT.intValue == 0 ||
       _customerInfo.LNG.intValue == 0 ||
       _customerInfo.PHOTO.length < 1)
    {
        SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"该客户信息尚未采集，是否现在进行采集？"
                                              cancelButtonTitle:@"取消"
                                                  cancelHandler:^(SIAlertView *alertView) {}
                                         destructiveButtonTitle:@"确定"
                                             destructiveHandler:^(SIAlertView *alertView) {
                                                 [self showCusInfoCollectView:YES];
                                             }];
        [alert show];
    }
    else
    {
        CusVisitViewController *cusVisitViewController = [[CusVisitViewController alloc] initWithNibName:@"CusVisitViewController" bundle:nil];
        cusVisitViewController.customerInfo = _customerInfo;
        cusVisitViewController.strVisitType = @"1";
        NSString *visitDate = self.visitRecord.VISIT_DATE;
        if (visitDate.length > 10) {
            visitDate = [visitDate substringToIndex:10];
        }
        if ( [visitDate isEqual:[[NSDate date]stringWithFormat:@"yyyy-MM-dd"]]) {
            cusVisitViewController.vistRecord = self.visitRecord;
        }
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cusVisitViewController];
        [self presentModalViewController:nav animated:YES];
    }
}

- (IBAction)handleSms:(id)sender {
    if (_lbMobile.text.length > 0)
    {
        NSString *telUrl = [NSString stringWithFormat:@"sms://%@",_lbMobile.text];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [MBProgressHUD showError:@"电话号码不正确" toView:self.view];
    }
}

- (IBAction)handleTel:(id)sender {
    if (_lbMobile.text.length > 0)
    {
        NSString *telUrl = [NSString stringWithFormat:@"tel://%@",_lbMobile.text];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [MBProgressHUD showError:@"电话号码不正确" toView:self.view];
    }
}

- (void)showCusInfoCollectView:(BOOL)bTag
{
    InfoCollectViewController *viewController = [[InfoCollectViewController alloc] initWithNibName:@"InfoCollectViewController" bundle:nil];
    viewController.bEnterNextview = bTag;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentModalViewController:nav animated:YES];
}

- (void)handleNotifyViewClose
{
    CusVisitViewController *cusVisitViewController = [[CusVisitViewController alloc] initWithNibName:@"CusVisitViewController" bundle:nil];
    cusVisitViewController.customerInfo = _customerInfo;
    cusVisitViewController.strVisitType = @"1";
    NSString *visitDate = self.visitRecord.VISIT_DATE;
    if (visitDate.length > 10) {
        visitDate = [visitDate substringToIndex:10];
    }
    if ( [visitDate isEqual:[[NSDate date]stringWithFormat:@"yyyy-MM-dd"]]) {
        cusVisitViewController.vistRecord = self.visitRecord;
    }
    else
    {
        [MBProgressHUD showError:@"只能拜访当天的客户" toView:self.view];
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cusVisitViewController];
    [self presentModalViewController:nav animated:YES];
}

@end
