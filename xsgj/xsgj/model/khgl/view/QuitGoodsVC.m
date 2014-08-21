//
//  QuitGoodsVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "QuitGoodsVC.h"
#import "MBProgressHUD+Add.h"
#import "KHGLAPI.h"
#import "SVPullToRefresh.h"
#import "QuitGoodsCell.h"
#import "NSString+URL.h"
#import "QuitGoodsDetailVC.h"
#import <NSDate+Helper.h>
#import <LKDBHelper.h>
#import "QueryOrderBackDetailInfoBean.h"

static NSString * const QuitGoodsCellIdentifier = @"QuitGoodsCellIdentifier";
static int const pageSize = 10000;

@interface QuitGoodsVC ()

@property (nonatomic, assign) NSUInteger currentPage; // 第1页开始,每页加载10

@end

@implementation QuitGoodsVC

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
    [self.tbvQuery registerNib:[QuitGoodsCell nib] forCellReuseIdentifier:QuitGoodsCellIdentifier];
    
    // 上提加载更多
    __weak QuitGoodsVC *weakSelf = self;
    [self.tbvQuery addInfiniteScrollingWithActionHandler:^{
        // 加载下一页
        self.currentPage += 1;
        [weakSelf loadQuitGoods];
    }];
    
    // 默认加载第一页
    self.currentPage = 1;
    self.tbvQuery.showsInfiniteScrolling = YES;
    [self loadQuitGoods];
}

- (void)loadQuitGoods
{
    QueryOrderBackHttpRequest *request = [[QueryOrderBackHttpRequest alloc] init];
    
    // 如果是空串就不上传
    /*
    if (![self.lblBeginTime.text isEmptyOrWhitespace]) {
        request.BEGINTIME = self.lblBeginTime.text;
    }
    if (![self.lblEndTime.text isEmptyOrWhitespace]) {
        request.ENDTIME = self.lblEndTime.text;
    }
    */
    request.BEGINTIME = [self.beginDate stringWithFormat:@"yyyy-MM-dd"];
    request.ENDTIME = [self.endDate stringWithFormat:@"yyyy-MM-dd"];
    request.CUST_NAME = @"";
    request.PAGE = self.currentPage;
    request.ROWS = pageSize;
    request.QUERY_USERID = [NSString stringWithFormat:@"%d",[ShareValue shareInstance].userInfo.USER_ID];
    
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [KHGLAPI queryOrderBackByRequest:request success:^(QueryOrderBackHttpResponse *response) {
        
        // 分页
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        int resultCount = [response.QUERYORDERBACKINFOBEAN count];
        if (resultCount < pageSize) {
            self.tbvQuery.showsInfiniteScrolling = NO;
        }
        
        // 保存离线数据
        [[LKDBHelper getUsingLKDBHelper] executeDB:^(FMDatabase *db) {
            @try {
                [db beginTransaction];
                for (QueryOrderBackInfoBean *bean in response.QUERYORDERBACKINFOBEAN) {
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
        
        // 加载退货详情列表
        QueryOrderBackDetailHttpRequest *requestDetail = [[QueryOrderBackDetailHttpRequest alloc] init];
        requestDetail.BEGINTIME = [self.beginDate stringWithFormat:@"yyyy-MM-dd"];
        requestDetail.ENDTIME = [self.endDate stringWithFormat:@"yyyy-MM-dd"];
        
        [KHGLAPI queryOrderBackDetailByRequest:requestDetail success:^(QueryOrderBackDetailHttpResponse *response) {
            
            // 保存退货查询明细离线数据
            [[LKDBHelper getUsingLKDBHelper] executeDB:^(FMDatabase *db) {
                @try {
                    [db beginTransaction];
                    for (QueryOrderBackDetailInfoBean *bean in response.QUERYORDERBACKINFOBEAN) {
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
                [MBProgressHUD showSuccess:DEFAULT_OFFLINEMESSAGE toView:nil];
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
    
    NSArray *arrTemp = [QueryOrderBackInfoBean searchWithWhere:SQL orderBy:@"COMMITTIME DESC" offset:0 count:10000];
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
    [self loadQuitGoods];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuitGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:QuitGoodsCellIdentifier];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell setHighlighted:NO animated:NO];
    
    // 配置Cell
    [cell configureForData:self.arrData[indexPath.row]];
    
    // 配置背景
    if ([self.arrData count] == 1) {
        cell.cellStyle = SINGLE;
    } else {
        if (indexPath.row == 0) {
            cell.cellStyle = TOP;
        } else if (indexPath.row == [self.arrData count] - 1) {
            cell.cellStyle = BOT;
        } else {
            cell.cellStyle = MID;
        }
    }
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    QuitGoodsDetailVC *vc = [[QuitGoodsDetailVC alloc] init];
    vc.quitBean = self.arrData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QuitGoodsCell cellHeight];
}

@end