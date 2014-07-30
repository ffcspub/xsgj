//
//  AnnouncementViewController.m
//  xsgj
//
//  Created by Geory on 14-7-25.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "UIColor+External.h"
#import "MBProgressHUD+Add.h"
#import "XTGLAPI.h"
#import "LK_EasySignal.h"
#import <NSDate+Helper.h>
#import "NoticeTypeBean.h"
#import "NoticeInfoBean.h"
#import "AnnouncementInfoViewController.h"

typedef  enum : NSUInteger {
    TOP = 0,
    MID = 1,
    BOT = 2,
} AnnouncementCellStyle;

@interface AnnouncementCell : UITableViewCell{
    UIImageView *_backView;
    UIImageView *_backSelectedView;
    UILabel *_lb_name;
    UILabel *_lb_time;
}

@property(nonatomic,assign) AnnouncementCellStyle style;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *time;

+(CGFloat)height;

@end

@implementation AnnouncementCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, [AnnouncementCell height])];
        _backSelectedView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, [AnnouncementCell height])];
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

-(void)setStyle:(AnnouncementCellStyle)style{
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
            _backView.image = [ShareValue tablePart3];
            _backSelectedView.image = [ShareValue tablePart3S];
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

@interface AnnouncementViewController (){
    NSMutableArray *_announceTypes;
    NoticeTypeBean *_selectType;
    NSMutableArray *_announces;
}

@end

@implementation AnnouncementViewController

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
    
    _announces = [[NSMutableArray alloc] init];
    
    [self setup];
    
    [self setRightBarButtonItem];
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
    
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [NSDateFormatter new];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    UILabel *lb_starttime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
//    lb_starttime.text = [formatter stringFromDate:date];
    lb_starttime.font = [UIFont systemFontOfSize:15];
    lb_starttime.textColor = HEX_RGB(0x000000);
    lb_starttime.backgroundColor = [UIColor clearColor];
    lb_starttime.tag = 301;
    [_btn_starttime addSubview:lb_starttime];
    
    UIImageView *iv_startcalendar = [[UIImageView alloc] initWithFrame:CGRectMake(100, 7, 26, 26)];
    iv_startcalendar.image = [UIImage imageNamed:@"tableCtrlBtnIcon_calendar-nor"];
    [_btn_starttime addSubview:iv_startcalendar];
    
    UILabel *lb_endtime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
//    lb_endtime.text = [formatter stringFromDate:date];
    lb_endtime.font = [UIFont systemFontOfSize:15];
    lb_endtime.textColor = HEX_RGB(0x000000);
    lb_endtime.backgroundColor = [UIColor clearColor];
    lb_endtime.tag = 302;
    [_btn_endtime addSubview:lb_endtime];
    
    UIImageView *iv_endcalendar = [[UIImageView alloc] initWithFrame:CGRectMake(100, 7, 26, 26)];
    iv_endcalendar.image = [UIImage imageNamed:@"tableCtrlBtnIcon_calendar-nor"];
    [_btn_endtime addSubview:iv_endcalendar];
    
    [_btn_announceType setBackgroundImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateNormal];
    [_btn_announceType setBackgroundImage:[[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateHighlighted];
    
    UILabel *lb_type = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    lb_type.text = @"公告类型";
    lb_type.font = [UIFont boldSystemFontOfSize:17];
    lb_type.textColor = HEX_RGB(0x939fa7);
    lb_type.backgroundColor = [UIColor clearColor];
    [_btn_announceType addSubview:lb_type];
    
    UILabel *lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = CGRectMake(78, 14, 10, 20);
    [_btn_announceType addSubview:lblStart];
    
    UILabel *lb_content = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    lb_content.text = @"请选择";
    lb_content.font = [UIFont boldSystemFontOfSize:17];
    lb_content.textColor = HEX_RGB(0x000000);
    lb_content.backgroundColor = [UIColor clearColor];
    lb_content.tag = 701;
    [_btn_announceType addSubview:lb_content];
    
    UIImageView *iv_dropbox = [[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 20, 20)];
    iv_dropbox.image = [UIImage imageNamed:@"dropbox"];
    [_btn_announceType addSubview:iv_dropbox];
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    
    [self queryNoticeRequest];
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

#pragma mark - private

- (BOOL)isVailData{
    NSString *errorMessage = nil;
    
    // 验证时间
    UILabel *lb_starttime = (UILabel *)[_btn_starttime viewWithTag:301];
    UILabel *lb_endtime = (UILabel *)[_btn_endtime viewWithTag:302];
    NSDate *beginTime = [NSDate dateFromString:lb_starttime.text withFormat:@"yyyy-MM-dd"];
    NSDate *endTime = [NSDate dateFromString:lb_endtime.text withFormat:@"yyyy-MM-dd"];
    if ([beginTime compare:endTime] == NSOrderedDescending) {
        errorMessage = @"起始时间大于结束时间!";
    }else if(!_selectType){
        errorMessage = @"请选择公告类型";
    }
    if (errorMessage.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)queryNoticeRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    QueryNoticeHttpRequest *request = [[QueryNoticeHttpRequest alloc] init];
    UILabel *lb_starttime = (UILabel *)[_btn_starttime viewWithTag:301];
    UILabel *lb_endtime = (UILabel *)[_btn_endtime viewWithTag:302];
    request.BEGIN_TIME = lb_starttime.text;
    request.END_TIME = lb_endtime.text;
    
    if (_selectType) {
        request.TYPE_ID = _selectType.TYPE_ID;
    }
    
    request.LOOK_FLAG = @"0";
    
    [XTGLAPI queryNoticeByRequest:request success:^(QueryNoticeHttpResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [_announces removeAllObjects];
        [_announces addObjectsFromArray:response.DATA];
        [self.tableView reloadData];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
    }];
}

#pragma mark - Action

- (void)queryAction:(id)sender
{
    if (![self isVailData]) {
        return;
    }
    
    [self queryNoticeRequest];
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

- (IBAction)selectAnnounceTypeAction:(id)sender
{
    NoticeTypesHttpRequest *request = [[NoticeTypesHttpRequest alloc] init];
    
    [XTGLAPI noticeTypesByRequest:request success:^(NoticeTypesHttpResponse *response) {
        
        _announceTypes = [[NSMutableArray alloc] init];
        [_announceTypes addObjectsFromArray:response.DATA];
        
        NSMutableArray *options = [[NSMutableArray alloc]init];
        for (NoticeTypeBean *type in _announceTypes) {
            [options addObject:[NSDictionary dictionaryWithObjectsAndKeys:type.TYPE_NAME, @"text",nil]];
        }
        LeveyPopListView *listView = [[LeveyPopListView alloc] initWithTitle:@"选择类型" options:options];
        listView.delegate = self;
        [listView showInView:self.navigationController.view animated:YES];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}

#pragma mark - LeveyPopListViewDelegate

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    NoticeTypeBean *type = [_announceTypes objectAtIndex:anIndex];
    _selectType = type;
    UILabel *lb_content = (UILabel *)[_btn_announceType viewWithTag:701];
    lb_content.text = type.TYPE_NAME;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_announces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ANNOUNCEMENTCELL";
    AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[AnnouncementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NoticeInfoBean *info = [_announces objectAtIndex:indexPath.row];
    
    cell.name = info.TOPIC;
    cell.time = info.BEGIN_TIME;
    
    if (indexPath.row == 0) {
        cell.style = TOP;
    } else if (indexPath.row == ([_announces count] - 1)) {
        cell.style = BOT;
    } else {
        cell.style = MID;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AnnouncementCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AnnouncementInfoViewController *vlc = [[AnnouncementInfoViewController alloc] initWithNibName:@"AnnouncementInfoViewController" bundle:nil];
    
    NoticeInfoBean *info = [_announces objectAtIndex:indexPath.row];
    vlc.noticeInfo = info;
    
    [self.navigationController pushViewController:vlc animated:YES];
}

@end
