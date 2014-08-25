//
//  TripQueryVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TripQueryVC.h"
#import "LK_EasySignal.h"
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
#import <LKDBHelper.h>
#import "TripInfoBean.h"

static NSString * const TripQueryCellIdentifier = @"TripQueryCellIdentifier";

static int const pageSize = 10000;

@interface TripQueryVC ()
{
    NSDate *_beginDate;
    NSDate *_endDate;
}

@property (nonatomic, strong) NSMutableArray *arrTrips;
@property (nonatomic, assign) NSUInteger currentPage; // 第一页开始,每页加载20，当加载返回的数量少于请求的页数认为没有数据了

@end

@implementation TripQueryVC

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
    
    // 日期处理
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [components setDay:1];
    NSDate *beginDate = [cal dateFromComponents:components];
    _beginDate = beginDate;
    _endDate = [NSDate date];

    [self UI_setup];
    
    self.currentPage = 1;
    [self loadTripList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 每次进入页面重新加载
    /*
    self.currentPage = 1;
    [self loadTripList];
    */
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

#pragma mark - UI

- (void)UI_setup
{
    self.view.backgroundColor = HEX_RGB(0xefeff4);

    // 导航按钮
    UIButton *rightButton = [self defaultRightButtonWithTitle:@"查询"];
    [rightButton addTarget:self
                    action:@selector(tripQueryAction:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    // 日期选择
    [self.btnBeginTime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateNormal];
    [self.btnBeginTime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板_s"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateHighlighted];
    
    [self.btnEndTime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateNormal];
    [self.btnEndTime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板_s"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateHighlighted];
    

    self.lblBeginTime.font = [UIFont systemFontOfSize:15];
    self.lblBeginTime.textColor = HEX_RGB(0x000000);
    self.lblBeginTime.backgroundColor = [UIColor clearColor];

    self.lblEndTime.font = [UIFont systemFontOfSize:15];
    self.lblEndTime.textColor = HEX_RGB(0x000000);
    self.lblEndTime.backgroundColor = [UIColor clearColor];
    
    // 设置默认时间
    /*
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.lblBeginTime.text = [formatter stringFromDate:date];
    self.lblEndTime.text = [formatter stringFromDate:date];
    */
    
    // 列表
    self.tbvQuery.backgroundColor = HEX_RGB(0xefeff4);
    self.tbvQuery.tableFooterView = [[UIView alloc] init];
    self.tbvQuery.delegate = self;
    self.tbvQuery.dataSource = self;
    self.tbvQuery.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvQuery.showsVerticalScrollIndicator = NO;
    [self.tbvQuery registerNib:[TripQueryCell nib] forCellReuseIdentifier:TripQueryCellIdentifier];
    
    // 上提加载更多
    __weak TripQueryVC *weakSelf = self;
    [self.tbvQuery addInfiniteScrollingWithActionHandler:^{
        // 加载下一页
        self.currentPage += 1;
        [weakSelf loadTripList];
    }];
}

#pragma mark - 事件

- (IBAction)tripQueryAction:(id)sender
{
    // 验证时间
    NSDate *beginTime = [NSDate dateFromString:self.lblBeginTime.text withFormat:@"yyyy-MM-dd"];
    NSDate *endTime = [NSDate dateFromString:self.lblEndTime.text withFormat:@"yyyy-MM-dd"];
    if ([beginTime compare:endTime] == NSOrderedDescending) {
        [MBProgressHUD showError:@"起始时间大于结束时间!" toView:self.view];
        return;
    }
    
    // 每次点击查询，从第一页重新加载数据
    self.currentPage = 1;
    self.tbvQuery.showsInfiniteScrolling = YES;
    [self loadTripList];
}

- (void)loadTripList
{
    QueryTripHttpRequest *request = [[QueryTripHttpRequest alloc] init];
    
    /*
    // 如果是空串就不上传
    if (![self.lblBeginTime.text isEmptyOrWhitespace]) {
        request.BEGIN_DATE = self.lblBeginTime.text;
    }
    if (![self.lblEndTime.text isEmptyOrWhitespace]) {
        request.END_DATE = self.lblEndTime.text;
    }
    */
    // 离线逻辑修改，每次进入查询直接加载到今日为止的一个月的数据，然后将数据保存到数据库
    request.BEGIN_DATE = [_beginDate stringWithFormat:@"yyyy-MM-dd"];
    request.END_DATE = [_endDate stringWithFormat:@"yyyy-MM-dd"];
    request.QUERY_USERID = @([ShareValue shareInstance].userInfo.USER_ID);
    request.PAGE = self.currentPage;
    request.ROWS = pageSize;
    
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [XZGLAPI queryTripByRequest:request success:^(QueryTripHttpResponse *response) {
        
        // 分页
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        int resultCount = [response.queryTripList count];
        if (resultCount < pageSize) {
            self.tbvQuery.showsInfiniteScrolling = NO;
        }
        
        // 保存离线数据
        [[LKDBHelper getUsingLKDBHelper] executeDB:^(FMDatabase *db) {
            @try {
                [db beginTransaction];
                for (TripInfoBean *bean in response.queryTripList) {
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
        if (self.arrTrips.count > 0) {
            [self hideNODataLabel];
        } else {
            [self showNoDataLabel];
        }
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        //[MBProgressHUD showError:response.MESSAGE.MESSAGECONTENT toView:self.view];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        self.tbvQuery.showsInfiniteScrolling = NO;

        if (notReachable) {
            [self loadCacheData];
            if (self.arrTrips.count > 0) {
                [self hideNODataLabel];
            } else {
                [self showNoDataLabel];
            }
            [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
            if (!isOffsetPromptShowed) {
                [MBProgressHUD showSuccess:DEFAULT_OFFLINEQUERYMESSAGE toView:nil];
                isOffsetPromptShowed = YES;
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
        SQL = [NSString stringWithFormat:@" APPLYTIME > %f ", [NSDate dateFromString:[NSString stringWithFormat:@"%@ 00:00:00", self.lblBeginTime.text] withFormat:@"yyyy-MM-dd HH:mm:ss"].timeIntervalSince1970];
    } else {
        SQL = [NSString stringWithFormat:@" 1 = 1 "];
    }
    if ([self.lblEndTime.text length] > 0) {
        SQL = [NSString stringWithFormat:@" %@ AND APPLYTIME < %f ", SQL, [NSDate dateFromString:[NSString stringWithFormat:@"%@ 23:59:59", self.lblEndTime.text] withFormat:@"yyyy-MM-dd HH:mm:ss"].timeIntervalSince1970];
    } else {
        SQL = [NSString stringWithFormat:@" %@ AND 1 = 1 ", SQL];
    }
    
    NSLog(@"查询过滤 : %@", SQL);
    
    NSArray *arrTemp = [TripInfoBean searchWithWhere:SQL orderBy:@"APPROVE_STATE ASC, APPLYTIME DESC" offset:0 count:10000];
    if (self.currentPage == 1) {
        [self.arrTrips removeAllObjects];
        [self.tbvQuery scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:NO];
    }
    
    [self.arrTrips addObjectsFromArray:arrTemp];
    [self.tbvQuery reloadData];
}

- (IBAction)beginTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker setMinimumDate:_beginDate];
    [picker setMaximumDate:_endDate];
    picker.tag = 1000;
    [picker showTitle:@"请选择起始时间" inView:self.view];
}

- (IBAction)endTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker setMinimumDate:_beginDate];
    [picker setMaximumDate:_endDate];
    picker.tag = 1001;
    [picker showTitle:@"请选择结束时间" inView:self.view];
}

ON_LKSIGNAL3(UIDatePicker, COMFIRM, signal)
{
    UIDatePicker *picker =  (UIDatePicker *)signal.sender;
    NSDate *date = picker.date;
    if (picker.tag == 1000) {
        self.lblBeginTime.text = [date stringWithFormat:@"yyyy-MM-dd"];
    } else {
        self.lblEndTime.text = [date stringWithFormat:@"yyyy-MM-dd"];
    }
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
    TripQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:TripQueryCellIdentifier];
    
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
    /*
    if ([bean.APPROVE_STATE intValue] == 0) {
        vc.showStyle = TripDetailShowStyleApproval;
    } else {
        vc.showStyle = TripDetailShowStyleQuery;
    }
    */
    vc.showStyle = TripDetailShowStyleQuery;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TripQueryCell cellHeight];
}

@end
