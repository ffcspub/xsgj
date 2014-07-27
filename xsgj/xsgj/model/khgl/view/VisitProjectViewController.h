//
//  VisitProjectViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "NSDate+Util.h"
#import <NSDate+Helper.h>
#import "LeveyPopListView.h"
#import "KHGLAPI.h"
#import "LKDBHelper.h"
#import "BNVisitPlan.h"
#import "BNCustomerInfo.h"
#import "VisitProjectCell.h"
#import "CusDetailViewController.h"

@interface VisitProjectViewController : HideTabViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *lbWeekday;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UITableView *tvContain;

- (IBAction)handleBtnWeek:(id)sender;

@end
