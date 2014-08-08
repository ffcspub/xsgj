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

static NSString * const QuitGoodsCellIdentifier = @"QuitGoodsCellIdentifier";
static int const pageSize = 10;

@interface QuitGoodsVC ()
{
    BOOL _isloading; // 加载的标识
}

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
    if (![self.lblBeginTime.text isEmptyOrWhitespace]) {
        request.BEGINTIME = self.lblBeginTime.text;
    }
    if (![self.lblEndTime.text isEmptyOrWhitespace]) {
        request.ENDTIME = self.lblEndTime.text;
    }

    request.CUST_NAME = self.tfVisiterName.text;
    request.PAGE = self.currentPage;
    request.ROWS = pageSize;
    
    _isloading = YES;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [KHGLAPI queryOrderBackByRequest:request success:^(QueryOrderBackHttpResponse *response) {
        
        int resultCount = [response.QUERYORDERBACKINFOBEAN count];
        NSLog(@"退货查询总数:%d", resultCount);
        
        if (resultCount < pageSize) {
            self.tbvQuery.showsInfiniteScrolling = NO;
        }

        if (self.currentPage == 1) {
            [self.arrData removeAllObjects];
            [self.tbvQuery scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:NO];
        }
        
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        [self.arrData addObjectsFromArray:response.QUERYORDERBACKINFOBEAN];
        
        [self.tbvQuery reloadData];
        
        [hub removeFromSuperview];
        _isloading = NO;
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        [self.tbvQuery reloadData];
        
        [hub removeFromSuperview];
        [MBProgressHUD showError:desciption toView:self.view];
        _isloading = NO;
    }];
}

#pragma mark - 事件

// 查询按钮事件
- (void)queryAction:(UIButton *)sender
{
    if (_isloading) {
        return;
    }
    
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