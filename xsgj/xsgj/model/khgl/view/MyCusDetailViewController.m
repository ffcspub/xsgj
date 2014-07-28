//
//  MyCusDetailViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-28.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "MyCusDetailViewController.h"
#import <UIImageView+WebCache.h>
#import "MyCusMapAddressVC.h"

@interface MyCusDetailViewController ()

@end

@implementation MyCusDetailViewController

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

- (void)initView
{
    self.title = @"客户详情";
    [self showRightBarButtonItemWithTitle:@"地图" target:self action:@selector(handleNavBarRight)];
    [self.svContain setContentSize:CGSizeMake(320, self.ivPhoto.frame.origin.y + self.ivPhoto.frame.size.height + 15)];
    
    self.lbName.text = _custDetailBean.CUST_NAME;
    self.lbType.text = _custDetailBean.TYPE_NAME;
    self.lbLinkMan.text = _custDetailBean.LINKMAN;
    self.lbMobile.text = _custDetailBean.TEL;
    self.lbAddress.text = _custDetailBean.ADDRESS;

    if(_custDetailBean.LASTEST_VISIT.length > 10)
    {
        self.lbVisitTime.text = _custDetailBean.LASTEST_VISIT;
    }
    else
    {
        self.lbVisitTime.text = @"一周前";
    }
    
    
    if(_custDetailBean.PHOTO.length > 1)
    {
        NSString *strUrl = [ShareValue getFileUrlByFileId:_custDetailBean.PHOTO];
        [self.ivPhoto sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"defaultPhoto"]];
    }
    
}

#pragma mark - functions

- (void)handleNavBarRight
{
    MyCusMapAddressVC *myCusMapAddressVC = [[MyCusMapAddressVC alloc] initWithNibName:@"MyCusMapAddressVC" bundle:nil];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.custDetailBean.LAT.doubleValue;
    coordinate.longitude = self.custDetailBean.LNG.doubleValue;
    myCusMapAddressVC.cusCoordinate = coordinate;
    myCusMapAddressVC.strAddress = self.custDetailBean.ADDRESS;
    [self.navigationController pushViewController:myCusMapAddressVC animated:YES];
}

@end
