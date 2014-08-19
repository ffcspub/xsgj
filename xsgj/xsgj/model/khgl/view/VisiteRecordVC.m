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
#import "VisistRecordVO.h"
#import <NSDate+Helper.h>
#import <LKDBHelper.h>

static NSString * const VisiteRecordCellIdentifier = @"VisiteRecordCellIdentifier";
static int const pageSize = 10000;

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
    [self.tbvQuery setSeparatorColor:[UIColor clearColor]];
    self.tbvQuery.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    /*
    if (![self.lblBeginTime.text isEmptyOrWhitespace]) {
        request.BEGIN_TIME = self.lblBeginTime.text;
    }
    if (![self.lblEndTime.text isEmptyOrWhitespace]) {
        request.END_TIME = self.lblEndTime.text;
    }
    */
    
    request.BEGIN_TIME = [self.beginDate stringWithFormat:@"yyyy-MM-dd"];
    request.END_TIME = [self.endDate stringWithFormat:@"yyyy-MM-dd"];
    request.CUST_NAME = @"";
    request.PAGE = self.currentPage;
    request.ROWS = pageSize;
    
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [KHGLAPI queryVisitRecordByRequest:request success:^(QueryVistitRecordHttpResponse *response) {
        
        // 分页
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        int resultCount = [response.rows count];
        if (resultCount < pageSize) {
            self.tbvQuery.showsInfiniteScrolling = NO;
        }
        
        // 保存离线数据
        [[LKDBHelper getUsingLKDBHelper] executeDB:^(FMDatabase *db) {
            @try {
                [db beginTransaction];
                for (VisistRecordVO *bean in response.rows) {
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
        
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];

    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        self.tbvQuery.showsInfiniteScrolling = NO;
        
        if (notReachable) {
            [self loadCacheData];
            [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showSuccess:DEFAULT_OFFLINEMESSAGE toView:ShareAppDelegate.window];
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
    
    NSArray *arrTemp = [VisistRecordVO searchWithWhere:SQL orderBy:@"START_DATE DESC" offset:0 count:10000];
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
