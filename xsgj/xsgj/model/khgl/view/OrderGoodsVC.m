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

static NSString * const OrderGoodsCellIdentifier = @"OrderGoodsCellIdentifier";
static int const pageSize = 10;

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
    [self.tbvQuery registerNib:[OrderGoodsCell nib] forCellReuseIdentifier:OrderGoodsCellIdentifier];
    
    // 上提加载更多
    __weak OrderGoodsVC *weakSelf = self;
    [self.tbvQuery addInfiniteScrollingWithActionHandler:^{
        // 加载下一页
        self.currentPage += 1;
        [weakSelf loadOrderGoods];
    }];
    
    // 默认加载第一页
    self.currentPage = 1;
    self.tbvQuery.showsInfiniteScrolling = NO;
    [self loadOrderGoods];
}

- (void)loadOrderGoods
{
    OrderQueryHttpRequest *request = [[OrderQueryHttpRequest alloc] init];
    // 如果是空串就不上传
    if (![self.lblBeginTime.text isEmptyOrWhitespace]) {
        request.BEGIN_DATE = self.lblBeginTime.text;
    }
    if (![self.lblEndTime.text isEmptyOrWhitespace]) {
        request.END_DATE = self.lblEndTime.text;
    }
    request.CUST_NAME = self.tfVisiterName.text;
    request.PAGE = self.currentPage;
    request.ROWS = pageSize;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [KHGLAPI queryOrderByRequest:request success:^(OrderQueryHttpResponse *response) {

        int resultCount = [response.DATA count];
        
        NSLog(@"订货查询返回的总数:%d", resultCount);
        
        if (resultCount < pageSize) {
            self.tbvQuery.showsInfiniteScrolling = NO;
        } else {
            self.tbvQuery.showsInfiniteScrolling = YES;
        }
        
        if (self.currentPage == 1) {
            [self.arrData removeAllObjects];
        }
        
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        [self.arrData addObjectsFromArray:response.DATA];
        
        [self.tbvQuery reloadData];
        
        [hub removeFromSuperview];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        
        [self.tbvQuery reloadData];
        
        [hub removeFromSuperview];
        [MBProgressHUD showError:desciption toView:self.view];
        
    }];
}

#pragma mark - 事件

// 查询按钮事件
- (void)queryAction:(UIButton *)sender
{
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
    OrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderGoodsCellIdentifier];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderGoodsDetailVC *vc = [[OrderGoodsDetailVC alloc] initWithNibName:nil bundle:nil];
    vc.orderInfoBean = self.arrData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderGoodsCell cellHeight];
}

@end
