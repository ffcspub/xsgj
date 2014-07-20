//
//  LeaveQueryViewController.h
//  xsgj
//
//  Created by Geory on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"

@interface LeaveQueryViewController : HideTabViewController

@property (weak, nonatomic) IBOutlet UIButton *btn_starttime;
@property (weak, nonatomic) IBOutlet UIButton *btn_endtime;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)selectBeginTimeAction:(id)sender;
- (IBAction)selectEndTimeAction:(id)sender;

@end
