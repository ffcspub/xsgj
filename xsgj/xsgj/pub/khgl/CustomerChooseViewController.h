//
//  CustomerChooseViewController.h
//  xsgj
//
//  Created by mac on 14-7-16.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfo.h"
#import "HideTabViewController.h"

@protocol CustomerChooseDelegate;

@interface CustomerChooseViewController : HideTabViewController<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_type;

@property (weak, nonatomic) IBOutlet UIButton *btn_area;

@property (weak, nonatomic) IBOutlet UISearchBar *sb_search;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIScrollView *sv_customers;

@property (weak, nonatomic) IBOutlet UIButton *btn_sure;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property(nonatomic,assign) id<CustomerChooseDelegate> chooseDelegate;

@end

@protocol CustomerChooseDelegate <NSObject>

@required

-(void)chooseCustomer:(NSArray *)customers;

@end