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
#import "KHGLAPI.h"
#import <NSDate+Helper.h>
#import "NSString+URL.h"
#import "ShareValue.h"
#import "SVPullToRefresh.h"
#import "SellTaskCell.h"

static NSString * const SellTaskQueryCellIdentifier = @"SellTaskQueryCellIdentifier";

static int const pageSize = 10;

@interface SellTaskVC () <UITableViewDelegate, UITableViewDataSource>

// 顶部时间
@property (weak, nonatomic) IBOutlet UILabel *lblBeginTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UIButton *btnBeginTime;
@property (weak, nonatomic) IBOutlet UIButton *btnEndTime;

// 表格
@property (weak, nonatomic) IBOutlet UITableView *tbvQuery;

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSUInteger currentPage; // 第一页开始,每页加载20，当加载返回的数量少于请求的页数认为没有数据了

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
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.lblBeginTime.text = [formatter stringFromDate:date];
    self.lblBeginTime.font = [UIFont systemFontOfSize:15];
    self.lblBeginTime.textColor = HEX_RGB(0x000000);
    self.lblBeginTime.backgroundColor = [UIColor clearColor];
    
    self.lblEndTime.text = [formatter stringFromDate:date];
    self.lblEndTime.font = [UIFont systemFontOfSize:15];
    self.lblEndTime.textColor = HEX_RGB(0x000000);
    self.lblEndTime.backgroundColor = [UIColor clearColor];
    
    // 列表
    self.tbvQuery.backgroundColor = HEX_RGB(0xefeff4);
    self.tbvQuery.tableFooterView = [[UIView alloc] init];
    self.tbvQuery.delegate = self;
    self.tbvQuery.dataSource = self;
    self.tbvQuery.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvQuery.showsVerticalScrollIndicator = NO;
    
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
    NSDate *beginTime = [NSDate dateFromString:self.lblBeginTime.text withFormat:@"yyyy-MM-dd"];
    NSDate *endTime = [NSDate dateFromString:self.lblEndTime.text withFormat:@"yyyy-MM-dd"];
    if ([beginTime compare:endTime] == NSOrderedDescending) {
        [MBProgressHUD showError:@"起始时间大于结束时间!" toView:self.view];
        return;
    }
    
    // 每次点击查询，从第一页重新加载数据
    self.currentPage = 1;
    self.tbvQuery.showsInfiniteScrolling = YES;
    [self loadSellTask];
}

- (void)loadSellTask
{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        sleep(2.f);
        
        // 不存在更多数据
        BOOL isExistMoreData = NO;
        if (!isExistMoreData) {
            self.tbvQuery.showsInfiniteScrolling = NO;
        }
        if (self.currentPage == 1) {
            [self.arrData removeAllObjects];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tbvQuery.infiniteScrollingView stopAnimating];
            [hub removeFromSuperview];
            [MBProgressHUD showError:@"完成" toView:self.view];
        });
    });
}

- (IBAction)beginTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.tag = 1000;
    [picker showTitle:@"请选择起始时间" inView:self.view];
}

- (IBAction)endTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
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
    NSInteger count = [self.arrData count];
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SellTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:SellTaskQueryCellIdentifier];
    
    // 配置Cell
    [cell configureForData:self.arrData[indexPath.row]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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


@end
