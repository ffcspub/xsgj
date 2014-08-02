//
//  OfflineListViewController.h
//  xsgj
//
//  Created by ilikeido on 14-8-1.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"

@interface OfflineListViewController : HideTabViewController<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
