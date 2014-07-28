//
//  MyCustomerViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-28.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "BNCustomerType.h"
#import "CustDetailBean.h"
#import "LKDBHelper.h"
#import "MBProgressHUD+Add.h"
#import "MyCusSelectTreeViewController.h"
#import "MyCusCell.h"
#import "KHGLAPI.h"

@interface MyCustomerViewController : HideTabViewController


@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UITableView *tvContain;

- (IBAction)handleBtnSelectType:(id)sender;


@end
