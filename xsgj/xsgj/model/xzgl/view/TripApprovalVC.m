//
//  TripApprovalVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TripApprovalVC.h"
#import <NSDate+Helper.h>
#import "UIColor+External.h"
#import "MBProgressHUD+Add.h"
#import "XZGLAPI.h"
#import <UIAlertView+Blocks.h>
#import <IQKeyboardManager.h>
#import "SIAlertView.h"
#import <NSDate+Helper.h>
#import "NSString+URL.h"
#import "ShareValue.h"
#import "TripQueryCell.h"
#import "TripDetailVC.h"
#import "SVPullToRefresh.h"

static NSString * const TripApprovalCellIdentifier = @"TripApprovalCellIdentifier";

static int const pageSize = 20;

@interface TripApprovalVC ()

@property (weak, nonatomic) IBOutlet UITableView *tbvApproval;
@property (nonatomic, strong) NSMutableArray *arrTrips;
@property (nonatomic, assign) NSUInteger currentPage; // 第一页开始
@property (nonatomic, assign) BOOL isExistData; // 记录是否存在数据

@end

@implementation TripApprovalVC

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
    
    [self UI_setup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 每次进入页面重新加载
    self.currentPage = 1;
    [self loadTripList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 访问器

- (NSMutableArray *)arrTrips
{
    if (!_arrTrips) {
        _arrTrips = [[NSMutableArray alloc] init];
    }
    
    return _arrTrips;
}

#pragma mark - 方法

- (void)loadTripList
{
    QueryTripHttpRequest *request = [[QueryTripHttpRequest alloc] init];
    request.PAGE = self.currentPage;
    request.ROWS = pageSize;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [XZGLAPI queryTripByRequest:request success:^(QueryTripHttpResponse *response) {
        
        int resultCount = [response.queryTripList count];
        if (resultCount < pageSize) {
            self.tbvApproval.showsInfiniteScrolling = NO;
        }
        if (self.currentPage == 1) {
            [self.arrTrips removeAllObjects];
        }
        
        [self.tbvApproval.infiniteScrollingView stopAnimating];
        [self.arrTrips addObjectsFromArray:response.queryTripList];
        [self.tbvApproval reloadData];
        
        [hub removeFromSuperview];
        //[MBProgressHUD showError:response.MESSAGE.MESSAGECONTENT toView:self.view];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [self.tbvApproval.infiniteScrollingView stopAnimating];
        self.tbvApproval.showsInfiniteScrolling = NO;
        self.tbvApproval.showsInfiniteScrolling = YES;
        
        [hub removeFromSuperview];
        [MBProgressHUD showError:desciption toView:self.view];
    }];

}

#pragma mark - UI

- (void)UI_setup
{
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    
    self.tbvApproval.backgroundColor = HEX_RGB(0xefeff4);
    self.tbvApproval.delegate = self;
    self.tbvApproval.dataSource = self;
    self.tbvApproval.tableFooterView = [[UIView alloc] init];
    self.tbvApproval.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvApproval.showsVerticalScrollIndicator = NO;
    [self.tbvApproval registerNib:[TripQueryCell nib] forCellReuseIdentifier:TripApprovalCellIdentifier];
    
    // 上提加载更多
    __weak TripApprovalVC *weakSelf = self;
    [self.tbvApproval addInfiniteScrollingWithActionHandler:^{
        // 加载下一页
        self.currentPage += 1;
        [weakSelf loadTripList];
    }];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 1;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.arrTrips count];
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:TripApprovalCellIdentifier];
    
    // 配置Cell
    [cell configureForData:self.arrTrips[indexPath.row]];

    // 配置背景
    if ([self.arrTrips count] == 1) {
        cell.cellStyle = SINGLE;
    } else {
        if (indexPath.row == 0) {
            cell.cellStyle = TOP;
        } else if (indexPath.row == ([self.arrTrips count] - 1)) {
            cell.cellStyle = BOT;
        } else {
            cell.cellStyle = MID;
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TripDetailVC *vc = [[TripDetailVC alloc] initWithNibName:nil bundle:nil];
    TripInfoBean *bean = self.arrTrips[indexPath.row];
    vc.tripInfo = bean;
    
    // 待审批
    if ([bean.APPROVE_STATE intValue] == 0) {
        vc.showStyle = TripDetailShowStyleApproval;
    } else {
        vc.showStyle = TripDetailShowStyleQuery;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TripQueryCell cellHeight];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end
