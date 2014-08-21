//
//  SellTaskVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SellTaskVC.h"
#import "LK_EasySignal.h"
#import <NSDate+Helper.h>
#import "UIColor+External.h"
#import "MBProgressHUD+Add.h"
#import "XZGLAPI.h"
#import <NSDate+Helper.h>
#import "NSString+URL.h"
#import "ShareValue.h"
#import "SVPullToRefresh.h"
#import "SellTaskCell.h"
#import "SaleTaskInfoBean.h"
#import <LKDBHelper.h>

static NSString * const SellTaskQueryCellIdentifier = @"SellTaskQueryCellIdentifier";

static int const pageSize = 10000;

@interface SellTaskVC () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSDate *_beginDate;
    NSDate *_endDate;
}

// 顶部时间
@property (weak, nonatomic) IBOutlet UILabel *lblBeginTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UIButton *btnBeginTime;
@property (weak, nonatomic) IBOutlet UIButton *btnEndTime;

// 表格
@property (weak, nonatomic) IBOutlet UITableView *tbvQuery;

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSUInteger currentPage; // 第一页开始,每页加载20，当加载返回的数量少于请求的页数认为没有数据了

@property (nonatomic, strong) NSMutableArray *arrPicker;
@property (nonatomic, strong) NSString *currentYear;
@property (nonatomic, strong) NSString *currentMonth;

@end

@implementation SellTaskVC

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
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
    _endDate = [cal dateFromComponents:components];   // 当前月
    [components setYear:components.year - 1];
    _beginDate = [cal dateFromComponents:components]; // 当前月
    
    // 日期控制
    int year = [[NSDate stringFromDate:[NSDate date] withFormat:@"yyyy"] intValue];
    NSMutableArray *arrYear = [[NSMutableArray alloc] initWithCapacity:1];
    [arrYear addObject:[NSString stringWithFormat:@"%d", year]];
    [self.arrPicker addObject:arrYear];
    NSMutableArray *arrMonth = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i = 1; i <= 12; i++) {
        [arrMonth addObject:[NSString stringWithFormat:@"%d", i]];
    }
    [self.arrPicker addObject:arrMonth];
    
    [self UI_setup];
    
    self.currentPage = 1;
    [self loadSellTask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 访问器

- (NSMutableArray *)arrData
{
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] init];
    }
    
    return _arrData;
}

- (NSMutableArray *)arrPicker
{
    if (!_arrPicker) {
        _arrPicker = [[NSMutableArray alloc] init];
    }
    
    return _arrPicker;
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
    
    // 默认不设置时间
    /*
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.lblBeginTime.text = [formatter stringFromDate:date];
    self.lblEndTime.text = [formatter stringFromDate:date];
    */
    
    self.lblBeginTime.font = [UIFont systemFontOfSize:15];
    self.lblBeginTime.textColor = HEX_RGB(0x000000);
    self.lblBeginTime.backgroundColor = [UIColor clearColor];
    
    self.lblEndTime.font = [UIFont systemFontOfSize:15];
    self.lblEndTime.textColor = HEX_RGB(0x000000);
    self.lblEndTime.backgroundColor = [UIColor clearColor];
    
    // 列表
    self.tbvQuery.backgroundColor = HEX_RGB(0xefeff4);
    self.tbvQuery.tableFooterView = [[UIView alloc] init];
    self.tbvQuery.delegate = self;
    self.tbvQuery.dataSource = self;
    // self.tbvQuery.separatorColor = HEX_RGB(0xf1f1f1);
    self.tbvQuery.showsVerticalScrollIndicator = NO;
    [self.tbvQuery registerNib:[SellTaskCell nib] forCellReuseIdentifier:SellTaskQueryCellIdentifier];
    
    // 上提加载更多
    __weak SellTaskVC *weakSelf = self;
    [self.tbvQuery addInfiniteScrollingWithActionHandler:^{
        // 加载下一页
        self.currentPage += 1;
        [weakSelf loadSellTask];
    }];
}

- (IBAction)tripQueryAction:(id)sender
{
    // 验证时间
    NSDate *beginTime = [NSDate dateFromString:self.lblBeginTime.text withFormat:@"yyyy-MM"];
    NSDate *endTime = [NSDate dateFromString:self.lblEndTime.text withFormat:@"yyyy-MM"];
    if ([beginTime compare:endTime] == NSOrderedDescending) {
        [MBProgressHUD showError:@"起始日期必须小于结束日期!" toView:self.view];
        return;
    }
    
    // 每次点击查询，从第一页重新加载数据
    self.currentPage = 1;
    self.tbvQuery.showsInfiniteScrolling = YES;
    [self loadSellTask];
}

- (void)loadSellTask
{
    QuerySaleTaskHttpRequest *request = [[QuerySaleTaskHttpRequest alloc] init];
    // 如果是空串就不上传
    /*
    if (![self.lblBeginTime.text isEmptyOrWhitespace]) {
        request.BEGIN_MONTH = self.lblBeginTime.text;
    }
    if (![self.lblEndTime.text isEmptyOrWhitespace]) {
        request.END_MONTH = self.lblEndTime.text;
    }
    */
    request.BEGIN_MONTH = [_beginDate stringWithFormat:@"yyyy-MM"];
    request.END_MONTH = [_endDate stringWithFormat:@"yyyy-MM"];
    request.QUERY_USERID = [NSString stringWithFormat:@"%d",[ShareValue shareInstance].userInfo.USER_ID];
    request.ROWS = pageSize;
    
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [XZGLAPI QuerySaleTaskByRequest:request success:^(QuerySaleTaskHttpResponse *response) {

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
                for (SaleTaskInfoBean *bean in response.DATA) {
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
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
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
        SQL = [NSString stringWithFormat:@" TIME >= %f ", [NSDate dateFromString:[NSString stringWithFormat:@"%@", self.lblBeginTime.text] withFormat:@"yyyy-MM"].timeIntervalSince1970];
    } else {
        SQL = [NSString stringWithFormat:@" 1 = 1 "];
    }
    if ([self.lblEndTime.text length] > 0) {
        SQL = [NSString stringWithFormat:@" %@ AND TIME <= %f ", SQL, [NSDate dateFromString:[NSString stringWithFormat:@"%@", self.lblEndTime.text] withFormat:@"yyyy-MM"].timeIntervalSince1970];
    } else {
        SQL = [NSString stringWithFormat:@" %@ AND 1 = 1 ", SQL];
    }
    
    NSLog(@"查询过滤 : %@", SQL);
    
    NSArray *arrTemp = [SaleTaskInfoBean searchWithWhere:SQL orderBy:@"SALE_MONTH ASC" offset:0 count:10000];
    if (self.currentPage == 1) {
        [self.arrData removeAllObjects];
        [self.tbvQuery scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:NO];
    }
    [self.arrData addObjectsFromArray:arrTemp];
    [self.tbvQuery reloadData];
}

- (IBAction)beginTimeAction:(id)sender
{
    /*
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.tag = 1000;
    [picker showTitle:@"请选择起始时间" inView:self.view];
    */
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    picker.tag = 1000;
    [picker selectRow:0 inComponent:0 animated:YES];
    [picker selectRow:0 inComponent:1 animated:YES];
    self.currentYear = self.arrPicker[0][0];
    self.currentMonth = [NSString stringWithFormat:@"%02d" ,[self.arrPicker[1][0] intValue]];
    [picker showTitle:@"请选择起始日期" inView:self.view];
}

- (IBAction)endTimeAction:(id)sender
{
    /*
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.tag = 1001;
    [picker showTitle:@"请选择结束时间" inView:self.view];
    */
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.bounds), 100.f)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.tag = 1001;
    [picker selectRow:4 inComponent:0 animated:YES];
    [picker selectRow:0 inComponent:1 animated:YES];
    self.currentYear = self.arrPicker[0][0];
    self.currentMonth = [NSString stringWithFormat:@"%02d" ,[self.arrPicker[1][0] intValue]];
    [picker showTitle:@"请选择结束日期" inView:self.view];
}

/*
ON_LKSIGNAL3(UIDatePicker, COMFIRM, signal)
{
    UIDatePicker *picker =  (UIDatePicker *)signal.sender;
    NSDate *date = picker.date;
    if (picker.tag == 1000) {
        self.lblBeginTime.text = [date stringWithFormat:@"yyyy-MM"];
    } else {
        self.lblEndTime.text = [date stringWithFormat:@"yyyy-MM"];
    }
}
*/

ON_LKSIGNAL3(UIPickerView, COMFIRM, signal)
{
    UIPickerView *picker =  (UIPickerView *)signal.sender;
    if (picker.tag == 1000) {
        self.lblBeginTime.text = [NSString stringWithFormat:@"%@-%@", self.currentYear, self.currentMonth];
    } else {
        self.lblEndTime.text = [NSString stringWithFormat:@"%@-%@", self.currentYear, self.currentMonth];
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 1;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.arrData count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SellTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:SellTaskQueryCellIdentifier];
    
    // 配置Cell
    [cell configureForData:self.arrData[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SellTaskCell cellHeight];
}

#pragma mark - UIPickerView

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.arrPicker count];
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.arrPicker[component] count];
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.arrPicker[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.currentYear = self.arrPicker[component][row];
    } else {
        self.currentMonth = [NSString stringWithFormat:@"%02d" ,[self.arrPicker[component][row] intValue]];
    }
}


@end
