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

typedef  enum : NSUInteger {
    TOP = 0,
    MID = 1,
    BOT = 2,
} AttendanceQueryCellStyle;

@interface AttendanceQueryCell : UITableViewCell{
    UIImageView *_backView;
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
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, [AttendanceQueryCell height])];
        _lb_name = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 180, 28)];
        _lb_name.backgroundColor = [UIColor clearColor];
        _lb_name.font = [UIFont systemFontOfSize:17];
        _lb_time = [[UILabel alloc]initWithFrame:CGRectMake(20, 31, 200,21)];
        _lb_time.textColor = HEX_RGB(0x939fa7);
        _lb_time.font = [UIFont systemFontOfSize:15];
        UIImageView *iv_next = [[UIImageView alloc] initWithFrame:CGRectMake(275, 15, 26, 26)];
        iv_next.image = [UIImage imageNamed:@"tableCtrlBtnIcon_next_nor"];
        [self.contentView addSubview:_backView];
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
            UIImage *image = [UIImage imageNamed:@"table_part1"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5,5, 5) ];
            _backView.image = image;
        }
            break;
        case MID:{
            UIImage *image = [UIImage imageNamed:@"table_part2"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) ];
            _backView.image = image;
        }
            break;
        case BOT:{
            UIImage *image = [UIImage imageNamed:@"table_part3"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) ];
            _backView.image = image;
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

static int const pageSize = 20;

@interface AttendanceQueryViewController (){
    NSMutableArray *_attendances;
    int page;
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
    [self queryAttendance];
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
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
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    UILabel *lb_starttime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    lb_starttime.text = [formatter stringFromDate:date];
    lb_starttime.font = [UIFont systemFontOfSize:15];
    lb_starttime.textColor = HEX_RGB(0x000000);
    lb_starttime.backgroundColor = [UIColor clearColor];
    lb_starttime.tag = 301;
    [_btn_starttime addSubview:lb_starttime];
    
    UIImageView *iv_startcalendar = [[UIImageView alloc] initWithFrame:CGRectMake(100, 7, 26, 26)];
    iv_startcalendar.image = [UIImage imageNamed:@"tableCtrlBtnIcon_calendar-nor"];
    [_btn_starttime addSubview:iv_startcalendar];
    
    UILabel *lb_endtime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    lb_endtime.text = [formatter stringFromDate:date];
    lb_endtime.font = [UIFont systemFontOfSize:15];
    lb_endtime.textColor = HEX_RGB(0x000000);
    lb_endtime.backgroundColor = [UIColor clearColor];
    lb_endtime.tag = 302;
    [_btn_endtime addSubview:lb_endtime];
    
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    page++;
    QueryAttendanceHttpRequest *request = [[QueryAttendanceHttpRequest alloc] init];
    UILabel *lb_starttime = (UILabel *)[_btn_starttime viewWithTag:301];
    UILabel *lb_endtime = (UILabel *)[_btn_endtime viewWithTag:302];
    request.BEGIN_TIME = lb_starttime.text;
    request.END_TIME = lb_endtime.text;
    request.PAGE = page;
    request.ROWS = pageSize;
    
    [XZGLAPI queryAttendanceByRequest:request success:^(QueryAttendanceHttpReponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        int resultCount = [response.DATA count];
        if (resultCount < pageSize) {
            self.tableView.showsInfiniteScrolling = NO;
        }
        if (page == 1) {
            [_attendances removeAllObjects];
        }
        
        [self.tableView.infiniteScrollingView stopAnimating];
        [_attendances addObjectsFromArray:response.DATA];
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView.infiniteScrollingView stopAnimating];
        self.tableView.showsInfiniteScrolling = NO;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
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
    UILabel *lb_starttime = (UILabel *)[_btn_starttime viewWithTag:301];
    UILabel *lb_endtime = (UILabel *)[_btn_endtime viewWithTag:302];
    NSDate *beginTime = [NSDate dateFromString:lb_starttime.text withFormat:@"yyyy-MM-dd"];
    NSDate *endTime = [NSDate dateFromString:lb_endtime.text withFormat:@"yyyy-MM-dd"];
    if ([beginTime compare:endTime] == NSOrderedDescending) {
        [MBProgressHUD showError:@"起始时间大于结束时间!" toView:self.view];
        return;
    }
    
    page = 0;
    [self queryAttendance];
}

- (IBAction)selectBeginTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.tag = 101;
    [picker showTitle:@"请选择" inView:self.view];
}

- (IBAction)selectEndTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.tag = 102;
    [picker showTitle:@"请选择" inView:self.view];
}

ON_LKSIGNAL3(UIDatePicker, COMFIRM, signal){
    UIDatePicker *picker =  (UIDatePicker *)signal.sender;
    NSDate *date = picker.date;
    NSLog(@"%@",[date stringWithFormat:@"yyyy-MM-dd"] );
    if (picker.tag == 101) {
        UILabel *lb_starttime = (UILabel *)[_btn_starttime viewWithTag:301];
        lb_starttime.text = [date stringWithFormat:@"yyyy-MM-dd"];
    } else {
        UILabel *lb_endtime = (UILabel *)[_btn_endtime viewWithTag:302];
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
    
    SigninfoBean *info = [_attendances objectAtIndex:indexPath.row];
    
    if ([info.SIGN_FLAG isEqualToString:@"i"]) {
        cell.name = @"签到";
    } else {
        cell.name = @"签退";
    }
    cell.time = info.SIGN_TIME;
    
    if (indexPath.row == 0) {
        cell.style = TOP;
    } else if (indexPath.row == ([_attendances count] - 1)) {
        cell.style = BOT;
    } else {
        cell.style = MID;
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
