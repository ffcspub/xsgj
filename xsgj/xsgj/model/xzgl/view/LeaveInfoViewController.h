//
//  LeaveInfoViewController.h
//  xsgj
//
//  Created by Geory on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"
#import "LeaveInfoBean.h"

@interface LeaveInfoViewController : HideTabViewController

@property (nonatomic, strong) LeaveinfoBean *leaveInfo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
