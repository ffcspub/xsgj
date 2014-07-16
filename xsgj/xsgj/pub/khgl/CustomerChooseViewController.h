//
//  CustomerChooseViewController.h
//  xsgj
//
//  Created by mac on 14-7-16.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfo.h"

@protocol CustomerChooseDelegate;

@interface CustomerChooseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btn_type;

@property (weak, nonatomic) IBOutlet UIButton *btn_area;

@property (weak, nonatomic) IBOutlet UISearchBar *sb_search;

@property (weak, nonatomic) IBOutlet UITableView *tableView;





@end

@protocol CustomerChooseDelegate <NSObject>

@required

-(void)chooseCustomer:(CustomerInfo *)customerInfo;

@end