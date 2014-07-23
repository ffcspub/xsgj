//
//  VisiteRecordVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "VisiteRecordVC.h"
#import "MBProgressHUD+Add.h"
#import "KHGLAPI.h"
#import "SVPullToRefresh.h"
#import "VisitRecordCell.h"
#import "NSString+URL.h"

static NSString * const VisiteRecordCellIdentifier = @"VisiteRecordCellIdentifier";
static int const pageSize = 10;

@interface VisiteRecordVC ()

@property (nonatomic, assign) NSUInteger currentPage; // 第1页开始,每页加载10

@end

@implementation VisiteRecordVC

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
    [self.tbvQuery registerNib:[VisitRecordCell nib] forCellReuseIdentifier:VisiteRecordCellIdentifier];
    
    // 上提加载更多
    __weak VisiteRecordVC *weakSelf = self;
    [self.tbvQuery addInfiniteScrollingWithActionHandler:^{
        // 加载下一页
        self.currentPage += 1;
        [weakSelf loadVisitRecord];
    }];

    // 默认加载第一页
    self.currentPage = 1;
    self.tbvQuery.showsInfiniteScrolling = NO;
    [self loadVisitRecord];
}

- (void)loadVisitRecord
{
    QueryVistitRecordHttpRequest *request = [[QueryVistitRecordHttpRequest alloc] init];
    // 如果是空串就不上传
    if (![self.lblBeginTime.text isEmptyOrWhitespace]) {
        request.BEGIN_TIME = self.lblBeginTime.text;
    }
    if (![self.lblEndTime.text isEmptyOrWhitespace]) {
        request.END_TIME = self.lblEndTime.text;
    }
    request.CUST_NAME = self.tfVisiterName.text;
    request.PAGE = self.currentPage;
    request.ROWS = pageSize;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [KHGLAPI queryVisitRecordByRequest:request success:^(QueryVistitRecordHttpResponse *response) {
        
        int resultCount = [response.VISIT_RECORDS count];
        if (resultCount < pageSize) {
            self.tbvQuery.showsInfiniteScrolling = NO;
        } else {
            self.tbvQuery.showsInfiniteScrolling = YES;
        }
        if (self.currentPage == 1) {
            [self.arrData removeAllObjects];
        }
        
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        [self.arrData addObjectsFromArray:response.VISIT_RECORDS];
        [self.tbvQuery reloadData];
        
        [hub removeFromSuperview];

    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        
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
    [self loadVisitRecord];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VisitRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:VisiteRecordCellIdentifier];
    // 配置Cell
    [cell configureForData:self.arrData[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VisitRecordCell cellHeight];
}

@end
