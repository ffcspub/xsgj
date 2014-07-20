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
#import "BorderView.h"
#import <NSDate+Helper.h>
#import "NSString+URL.h"
#import "ShareValue.h"
#import "TripQueryCell.h"
#import "TripDetailVC.h"

static NSString * const TripQueryCellIdentifier = @"TripQueryCellIdentifier";

@interface TripQueryVC ()

@property (nonatomic, strong) NSMutableArray *arrTrips;

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

    [self UI_setup];
    
    [self.arrTrips removeAllObjects];
    for (int i = 0; i < 5; i++) {
        [self.arrTrips addObject:@"1"];
    }
    [self.tbvQuery reloadData];
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
    [self.tbvQuery registerNib:[TripQueryCell nib] forCellReuseIdentifier:TripQueryCellIdentifier];
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
    
    QueryTripHttpRequest *request = [[QueryTripHttpRequest alloc] init];
    request.BEGIN_TIME = self.lblBeginTime.text;
    request.END_TIME = self.lblEndTime.text;
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在加载···" toView:self.view];
    [hud showAnimated:YES whileExecutingBlock:^{
        [XZGLAPI queryTripByRequest:request success:^(QueryTripHttpResponse *response) {
            
            [self.arrTrips addObjectsFromArray:response.queryTripList];
            [self.tbvQuery reloadData];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:response.MESSAGE.MESSAGECONTENT toView:self.view];
            
        } fail:^(BOOL notReachable, NSString *desciption) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }];
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
    if (indexPath.row == 0) {
        cell.cellStyle = TOP;
    } else if (indexPath.row == ([self.arrTrips count] - 1)) {
        cell.cellStyle = BOT;
    } else {
        cell.cellStyle = MID;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TripDetailVC *vc = [[TripDetailVC alloc] initWithNibName:nil bundle:nil];
    if (indexPath.row / 2 == 0) {
        vc.showStyle = TripDetailShowStyleApproval;
    } else {
        vc.showStyle = TripDetailShowStyleQuery;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.f;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end
