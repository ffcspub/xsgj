//
//  DistributionQueryVC.h
//  xsgj
//
//  Created by xujunwen on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"

typedef NS_OPTIONS(NSUInteger, DistrubutionType) {
    DistrubutionTypeQuery, // 查询
    DistrubutionTypeHandle // 处理
};

@interface BaseDistributionVC : HideTabViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) DistrubutionType type;

@property (nonatomic, strong) NSMutableArray *arrData;
@property (weak, nonatomic) IBOutlet UITableView *tbvQuery;
@property (weak, nonatomic) IBOutlet UILabel *tfTime;

@end
