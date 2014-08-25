//
//  OrderGoodsVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "OrderGoodsVC.h"
#import "MBProgressHUD+Add.h"
#import "KHGLAPI.h"
#import "SVPullToRefresh.h"
#import "OrderGoodsCell.h"
#import "NSString+URL.h"
#import "OrderGoodsDetailVC.h"
#import <NSDate+Helper.h>
#import <LKDBHelper.h>
#import "OrderDetailBean.h"

static NSString * const TopOrderGoodsCellIdentifier = @"TopOrderGoodsCellIdentifier";
static NSString * const BotOrderGoodsCellIdentifier = @"BotOrderGoodsCellIdentifier";
static NSString * const MidOrderGoodsCellIdentifier = @"MidOrderGoodsCellIdentifier";
static NSString * const SigOrderGoodsCellIdentifier = @"SigOrderGoodsCellIdentifier";
static int const pageSize = 10000;

@interface OrderGoodsVC ()

@property (nonatomic, assign) NSUInteger currentPage; // 第1页开始,每页加载10

@end

@implementation OrderGoodsVC

- (id)init
{
    self = [super initWithNibName:@"BaseQueryVC" bundle:nil];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 表格设置
    [self.tbvQuery registerNib:[OrderGoodsCell nib] forCellReuseIdentifier:TopOrderGoodsCellIdentifier];
    [self.tbvQuery registerNib:[OrderGoodsCell nib] forCellReuseIdentifier:BotOrderGoodsCellIdentifier];
    [self.tbvQuery registerNib:[OrderGoodsCell nib] forCellReuseIdentifier:MidOrderGoodsCellIdentifier];
    [self.tbvQuery registerNib:[OrderGoodsCell nib] forCellReuseIdentifier:SigOrderGoodsCellIdentifier];
    
    // 上提加载更多
    __weak OrderGoodsVC *weakSelf = self;
    [self.tbvQuery addInfiniteScrollingWithActionHandler:^{
        // 加载下一页
        self.currentPage += 1;
        [weakSelf loadOrderGoods];
    }];
    
    // 默认加载第一页
    self.currentPage = 1;
    self.tbvQuery.showsInfiniteScrolling = YES;
    [self loadOrderGoods];
}

- (void)loadOrderGoods
{
    OrderQueryHttpRequest *request = [[OrderQueryHttpRequest alloc] init];
    // 如果是空串就不上传
    /*
    if (![self.lblBeginTime.text isEmptyOrWhitespace]) {
        request.BEGIN_DATE = self.lblBeginTime.text;
    }
    if (![self.lblEndTime.text isEmptyOrWhitespace]) {
        request.END_DATE = self.lblEndTime.text;
    }
    */
    request.BEGIN_DATE = [self.beginDate stringWithFormat:@"yyyy-MM-dd"];
    request.END_DATE = [self.endDate stringWithFormat:@"yyyy-MM-dd"];
    request.CUST_NAME = @"";
    request.PAGE = self.currentPage;
    request.ROWS = pageSize;
    request.QUERY_USERID = [NSString stringWithFormat:@"%d",[ShareValue shareInstance].userInfo.USER_ID];
    
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [KHGLAPI queryOrderByRequest:request success:^(OrderQueryHttpResponse *response) {
        
        // 分页
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        int resultCount = [response.DATA count];
        if (resultCount < pageSize) {
            self.tbvQuery.showsInfiniteScrolling = NO;
        }
        
        // 保存离线数据
        [[LKDBHelper getUsingLKDBHelper] executeDB:^(FMDatabase *db) {
            @try {
                [db beginTransaction];
                for (OrderInfoBean *bean in response.DATA) {
                    [bean save];
                }
                [db commit];
            }
            @catch (NSException *exception) {
                [db rollback];
            }
            @finally {
                
            }
        }];
        
        [self loadCacheData];
        if (self.arrData.count > 0) {
            [self hideNODataLabel];
        } else {
            [self showNoDataLabel];
        }
        // 加载订货详情列表
        OrderDetailHttpRequest *requestDetail = [[OrderDetailHttpRequest alloc] init];
        requestDetail.BEGIN_DATE = [self.beginDate stringWithFormat:@"yyyy-MM-dd"];
        requestDetail.END_DATE = [self.endDate stringWithFormat:@"yyyy-MM-dd"];

        [KHGLAPI queryOrderDetailByRequest:requestDetail success:^(OrderDetailHttpResponse *response) {
            
            NSLog(@"订货明细查询的总数:%d", [response.rows count]);
            // 保存订货查询明细离线数据
            [[LKDBHelper getUsingLKDBHelper] executeDB:^(FMDatabase *db) {
                @try {
                    [db beginTransaction];
                    for (OrderDetailBean *bean in response.rows) {
                        [bean save];
                    }
                    [db commit];
                }
                @catch (NSException *exception) {
                    [db rollback];
                }
                @finally {
                    
                }
            }];
            
            [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];

        } fail:^(BOOL notReachable, NSString *desciption) {
            
            [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];

        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        self.tbvQuery.showsInfiniteScrolling = NO;
        
        if (notReachable) {
            [self loadCacheData];
            [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
            if (!isOffsetPromptShowed) {
                [MBProgressHUD showSuccess:DEFAULT_OFFLINEQUERYMESSAGE toView:nil];
                isOffsetPromptShowed = YES;
            }
            if(self.arrData.count == 0){
                [self showNoDataLabel];
            } else {
                [self hideNODataLabel];
            }
        } else {
            [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showError:desciption toView:nil];
        }
    }];
}

- (void)loadCacheData
{
    NSString *SQL = @"";
    if ([self.lblBeginTime.text length] > 0) {
        SQL = [NSString stringWithFormat:@" TIME >= %f ", [NSDate dateFromString:[NSString stringWithFormat:@"%@ 00:00:00", self.lblBeginTime.text] withFormat:@"yyyy-MM-dd HH:mm:ss"].timeIntervalSince1970];
    } else {
        SQL = [NSString stringWithFormat:@" 1 = 1 "];
    }
    if ([self.lblEndTime.text length] > 0) {
        SQL = [NSString stringWithFormat:@" %@ AND TIME <= %f ", SQL, [NSDate dateFromString:[NSString stringWithFormat:@"%@ 23:59:59", self.lblEndTime.text] withFormat:@"yyyy-MM-dd HH:mm:ss"].timeIntervalSince1970];
    } else {
        SQL = [NSString stringWithFormat:@" %@ AND 1 = 1 ", SQL];
    }
    if ([self.tfVisiterName.text length] > 0) {
        SQL = [NSString stringWithFormat:@" %@ AND CUST_NAME LIKE '%%%@%%'", SQL, self.tfVisiterName.text];
    }
    
    NSLog(@"查询过滤 : %@", SQL);
    
    NSArray *arrTemp = [OrderInfoBean searchWithWhere:SQL orderBy:@"COMMITTIME DESC" offset:0 count:10000];
    if (self.currentPage == 1) {
        [self.arrData removeAllObjects];
        [self.tbvQuery scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:NO];
    }
    [self.arrData addObjectsFromArray:arrTemp];
    [self.tbvQuery reloadData];
}

#pragma mark - 事件

// 查询按钮事件
- (void)queryAction:(UIButton *)sender
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    // 验证时间
    [super queryAction:sender];
    
    // 每次点击查询，从第一页重新加载数据
    self.currentPage = 1;
    self.tbvQuery.showsInfiniteScrolling = YES;
    [self loadOrderGoods];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderGoodsCell *cell ;
    // 配置背景
    if ([self.arrData count] == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:SigOrderGoodsCellIdentifier];
        cell.cellStyle = SINGLE;
    } else {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:TopOrderGoodsCellIdentifier];
            cell.cellStyle = TOP;
        } else if (indexPath.row == [self.arrData count] - 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:BotOrderGoodsCellIdentifier];
            cell.cellStyle = BOT;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:MidOrderGoodsCellIdentifier];
            cell.cellStyle = MID;
        }
    }
    
    // 配置Cell
    [cell configureForData:self.arrData[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    OrderGoodsDetailVC *vc = [[OrderGoodsDetailVC alloc] initWithNibName:nil bundle:nil];
    vc.orderInfoBean = self.arrData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderGoodsCell cellHeight];
}

@end
