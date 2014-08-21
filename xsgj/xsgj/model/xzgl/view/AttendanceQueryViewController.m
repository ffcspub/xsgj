//
//  AttendanceQueryViewController.m
//  xsgj
//
//  Created by Geory on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "AttendanceQueryViewController.h"
#import "UIColor+External.h"
#import "MBProgressHUD+Add.h"
#import "XZGLAPI.h"
#import "LK_EasySignal.h"
#import <NSDate+Helper.h>
#import "SVPullToRefresh.h"
#import "SignDetailBean.h"
#import "MyCusMapAddressVC.h"
#import <LKDBHelper.h>
#import "BNSignConfigBean.h"

typedef  enum : NSUInteger {
    TOP = 0,
    MID = 1,
    BOT = 2,
    SINGLE
} AttendanceQueryCellStyle;

@interface AttendanceQueryCell : UITableViewCell{
    UIImageView *_backView;
    UIImageView *_backSelectedView;
    UILabel *_lb_name;
    UILabel *_lb_time;
}

@property(nonatomic,assign) AttendanceQueryCellStyle style;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *time;

+(CGFloat)height;

@end

@implementation AttendanceQueryCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, [AttendanceQueryCell height])];
        _backSelectedView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, [AttendanceQueryCell height])];
        _lb_name = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 180, 28)];
        _lb_name.backgroundColor = [UIColor clearColor];
        _lb_name.font = [UIFont systemFontOfSize:17];
        _lb_time = [[UILabel alloc]initWithFrame:CGRectMake(10, 31, 200,21)];
        _lb_time.textColor = HEX_RGB(0x939fa7);
        _lb_time.font = [UIFont systemFontOfSize:15];
        UIImageView *iv_next = [[UIImageView alloc] initWithFrame:CGRectMake(265, 15, 26, 26)];
        iv_next.image = [UIImage imageNamed:@"tableCtrlBtnIcon_next_nor"];
        self.backgroundView = _backView;
        self.selectedBackgroundView = _backSelectedView;
        [self.contentView addSubview:_lb_name];
        [self.contentView addSubview:_lb_time];
        [self.contentView addSubview:iv_next];
    }
    return self;
}

+(CGFloat)height{
    return 56.0;
}

-(void)setStyle:(AttendanceQueryCellStyle)style{
    _style = style;
    switch (style) {
        case TOP:{
            _backView.image = [ShareValue tablePart1];
            _backSelectedView.image = [ShareValue tablePart1S];
        }
            break;
        case MID:{
            _backView.image = [ShareValue tablePart2];
            _backSelectedView.image = [ShareValue tablePart2S];
        }
            break;
        case BOT:{
//            _backView.image = [ShareValue tablePart3];
//            _backSelectedView.image = [ShareValue tablePart3S];
            
            UIImage *image = [UIImage imageNamed:@"table_part3"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            _backView.image = image;
            
            UIImage *imageSelect = [UIImage imageNamed:@"table_part3_s"];
            imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            _backSelectedView.image = imageSelect;
        }
            break;
        case SINGLE:{
            UIImage *image = [UIImage imageNamed:@"table_main_n"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            _backView.image = image;
            
            UIImage *imageSelect = [UIImage imageNamed:@"table_main_s"];
            imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            _backSelectedView.image = imageSelect;
        }
            break;
        default:
            break;
    }
}

-(void)setName:(NSString *)name{
    _name = name;
    _lb_name.text = name;
}

-(void)setTime:(NSString *)time{
    _time = time;
    _lb_time.text = time;
}

@end

static int const pageSize = 30;

@interface AttendanceQueryViewController (){
    NSMutableArray *_attendances;
    int page;
    NSDate *_beginDate;
    NSDate *_endDate;
    
    UILabel *lb_starttime;
    UILabel *lb_endtime;
}

@end

@implementation AttendanceQueryViewController

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
    // Do any additional setup after loading the view from its nib.
    
    _attendances = [[NSMutableArray alloc] init];
    
    [self setup];
    
    [self setRightBarButtonItem];
    
    page = 0;
    
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    
    [[LKDBHelper getUsingLKDBHelper]createTableWithModelClass:[SignDetailBean class ]];
    
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [components setDay:1];
    NSDate *beginDate = [cal dateFromComponents:components];
    _beginDate = beginDate;
    _endDate = [NSDate date];
    
    [self queryAttendance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    [_btn_starttime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateNormal];
    [_btn_starttime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板_s"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateHighlighted];
    
    [_btn_endtime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateNormal];
    [_btn_endtime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板_s"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateHighlighted];
    
    
    lb_starttime = [[UILabel alloc] initWithFrame:CGRectInset(_btn_starttime.frame, 10, 0) ];
    lb_starttime.text = [_beginDate stringWithFormat:@"yyyy-MM-dd"];
    lb_starttime.font = [UIFont systemFontOfSize:15];
    lb_starttime.textColor = HEX_RGB(0x000000);
    lb_starttime.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lb_starttime];
    
    UIImageView *iv_startcalendar = [[UIImageView alloc] initWithFrame:CGRectMake(100, 7, 26, 26)];
    iv_startcalendar.image = [UIImage imageNamed:@"tableCtrlBtnIcon_calendar-nor"];
    [_btn_starttime addSubview:iv_startcalendar];
    
    lb_endtime = [[UILabel alloc] initWithFrame:CGRectInset(_btn_endtime.frame, 10, 0)];
    lb_endtime.text = [_endDate stringWithFormat:@"yyyy-MM-dd"];
    lb_endtime.font = [UIFont systemFontOfSize:15];
    lb_endtime.textColor = HEX_RGB(0x000000);
    lb_endtime.backgroundColor = [UIColor clearColor];
    lb_endtime.tag = 302;
    [self.view addSubview:lb_endtime];
    
    UIImageView *iv_endcalendar = [[UIImageView alloc] initWithFrame:CGRectMake(100, 7, 26, 26)];
    iv_endcalendar.image = [UIImage imageNamed:@"tableCtrlBtnIcon_calendar-nor"];
    [_btn_endtime addSubview:iv_endcalendar];
    
    __weak AttendanceQueryViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf queryAttendance];
    }];
}

- (void)queryAttendance
{
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    
    page++;
    DetailAttendanceHttpRequest *request = [[DetailAttendanceHttpRequest alloc] init];
    request.BEGIN_TIME = [_beginDate stringWithFormat:@"yyyy-MM-dd"];
    request.END_TIME = [_endDate stringWithFormat:@"yyyy-MM-dd"];
    request.QUERY_USERID = [NSString stringWithFormat:@"%d",[ShareValue shareInstance].userInfo.USER_ID];
    request.PAGE = page;
    request.ROWS = pageSize;
    [XZGLAPI detailAttendanceByRequest:request success:^(DetailAttendanceHttpResponse *response) {
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        
        int resultCount = [response.DATA count];
        if (resultCount < pageSize) {
            for (SignDetailBean *bean in response.DATA) {
                [bean save];
            }
            self.tableView.showsInfiniteScrolling = NO;
        }
        if (page == 1) {
            [_attendances removeAllObjects];
        }
        
        [self.tableView.infiniteScrollingView stopAnimating];
        [_attendances addObjectsFromArray:response.DATA];
        [self.tableView reloadData];
        
        if (_attendances.count == 0) {
            [self showNoDataLabel];
        }else{
            [self hideNODataLabel];
        }
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView.infiniteScrollingView stopAnimating];
        self.tableView.showsInfiniteScrolling = NO;
        
        if (notReachable) {
            
            NSString *sql = [NSString stringWithFormat:@"SIGNTIME>%f and SIGNTIME<%f",[NSDate dateFromString:[_beginDate stringWithFormat:@"yyyy-MM-dd 00:00:00"] withFormat:@"yyyy-MM-dd HH:mm:ss"].timeIntervalSince1970,[NSDate dateFromString:[_endDate stringWithFormat:@"yyyy-MM-dd 23:59:59"] withFormat:@"yyyy-MM-dd HH:mm:ss"].timeIntervalSince1970];
            
            NSArray *attendances = [SignDetailBean searchWithWhere:sql orderBy:@"SIGNTIME DESC" offset:0 count:60];
            if (page == 1) {
                [_attendances removeAllObjects];
            }
            
            [_attendances addObjectsFromArray:attendances];
            [self.tableView reloadData];
            
            [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showSuccess:DEFAULT_OFFLINEMESSAGE toView:nil];
            
            if (_attendances.count == 0) {
                [self showNoDataLabel];
            }else{
                [self hideNODataLabel];
            }
        } else {
            [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showError:desciption toView:nil];
        }
    }];
}

#pragma mark - navBarButton

- (void)setRightBarButtonItem{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setFrame:CGRectMake(0, 2.f, 70.f, 33.f)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    
    [rightButton setTitle:@"查询" forState:UIControlStateNormal];
    
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

#pragma mark - Action

- (void)queryAction:(id)sender
{
    // 验证时间
    NSDate *beginTime = nil;
    if (lb_starttime.text.length>0) {
        beginTime = [NSDate dateFromString:lb_starttime.text withFormat:@"yyyy-MM-dd"];
    }
    NSDate *endTime = nil;
    if (lb_endtime.text.length>0) {
        endTime = [NSDate dateFromString:lb_endtime.text withFormat:@"yyyy-MM-dd"];
    }
    
    if (beginTime && endTime && [beginTime compare:endTime] == NSOrderedDescending) {
        [MBProgressHUD showError:@"起始时间大于结束时间!" toView:self.view];
        return;
    }
    if (beginTime) {
        _beginDate = beginTime;
    }
    if (endTime) {
        _endDate = endTime;
    }
    page = 0;
    self.tableView.showsInfiniteScrolling = YES;
    [self queryAttendance];
}

- (IBAction)selectBeginTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [components setDay:1];
    NSDate *beginDate = [cal dateFromComponents:components];
    picker.maximumDate = [NSDate date];
    picker.minimumDate = beginDate;
    picker.tag = 101;
    [picker showTitle:@"请选择" inView:self.view];
}

- (IBAction)selectEndTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.tag = 102;
    picker.maximumDate = [NSDate date];
    [picker showTitle:@"请选择" inView:self.view];
}

ON_LKSIGNAL3(UIDatePicker, COMFIRM, signal){
    UIDatePicker *picker =  (UIDatePicker *)signal.sender;
    NSDate *date = picker.date;
    NSLog(@"%@",[date stringWithFormat:@"yyyy-MM-dd"] );
    if (picker.tag == 101) {
        lb_starttime.text = [date stringWithFormat:@"yyyy-MM-dd"];
    } else {
        lb_endtime.text = [date stringWithFormat:@"yyyy-MM-dd"];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_attendances count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ATTENDANCEQUERYCELL";
    AttendanceQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[AttendanceQueryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    SignDetailBean *info = [_attendances objectAtIndex:indexPath.row];
    
    if ([info.SIGN_FLAG isEqualToString:@"i"]) {
        cell.name = @"签到";
    } else {
        cell.name = @"签退";
    }
    cell.time = info.SIGN_TIME;
    
    if ([_attendances count] == 1) {
        cell.style = SINGLE;
    } else {
        if (indexPath.row == 0) {
            cell.style = TOP;
        } else if (indexPath.row == ([_attendances count] - 1)) {
            cell.style = BOT;
        } else {
            cell.style = MID;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AttendanceQueryCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SignDetailBean *info = [_attendances objectAtIndex:indexPath.row];
    
    MyCusMapAddressVC *myCusMapAddressVC = [[MyCusMapAddressVC alloc] initWithNibName:@"MyCusMapAddressVC" bundle:nil];
    myCusMapAddressVC.title = @"考勤查询";
    CLLocationCoordinate2D coordinate;
    NSString *position = info.POSITION;
    if (info.LAT > 100) {
        coordinate.latitude = info.LAT/1000000;
        coordinate.longitude = info.LNG/1000000;
    }else{
        coordinate.latitude = info.LAT;
        coordinate.longitude = info.LNG;
    }
    if (info.LAT2 > 0 && info.LNG2 > 0) {
        if (info.LAT2 >100) {
            coordinate.latitude = info.LAT2/1000000;
            coordinate.longitude = info.LNG2/1000000;
        }else{
            coordinate.latitude = info.LAT2;
            coordinate.longitude = info.LNG2;
        }
        position = info.POSITION2;
    }
    myCusMapAddressVC.cusCoordinate = coordinate;
    myCusMapAddressVC.strAddress = position;
    [self.navigationController pushViewController:myCusMapAddressVC animated:YES];
}

#pragma mark - scrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        CGPoint position = CGPointMake(0, 0);
        [scrollView setContentOffset:position animated:NO];
    }
}

@end
