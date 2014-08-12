//
//  BaseGoosQueryVC.h
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "LK_HttpResponse.h"
#import <IQKeyboardManager.h>

@interface BaseQueryVC : HideTabViewController <UITableViewDataSource, UITableViewDelegate>

// 控件
@property (weak, nonatomic) IBOutlet UILabel *lblBeginTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UITextField *tfVisiterName;

// 表格
@property (weak, nonatomic) IBOutlet UITableView *tbvQuery;
@property (nonatomic, strong) NSMutableArray *arrData; // 数据

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;

// 查询按钮事件
- (void)queryAction:(UIButton *)sender;

@end
