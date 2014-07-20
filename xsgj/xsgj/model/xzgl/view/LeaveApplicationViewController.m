//
//  LeaveApplicationViewController.m
//  xsgj
//
//  Created by Geory on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "LeaveApplicationViewController.h"
#import "UIColor+External.h"
#import <TTTAttributedLabel.h>
#import "LK_EasySignal.h"
#import <NSDate+Helper.h>
#import "XZGLAPI.h"

@interface LeaveApplicationViewController (){
    NSMutableArray *_typeList;
}

@end

@implementation LeaveApplicationViewController

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
    
    [self setRightBarButtonItem];
    
    [self setup];
    
    self.scrollView.backgroundColor = HEX_RGB(0xefeff4);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    //主题
    UIButton *btn_title = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_title.frame = CGRectMake(10, 20, 300, 40);
    [btn_title setBackgroundImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateNormal];
    [btn_title setBackgroundImage:[[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateHighlighted];
    
    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    lb_title.text = @"主题";
    lb_title.font = [UIFont boldSystemFontOfSize:17];
    lb_title.textColor = HEX_RGB(0x939fa7);
    lb_title.backgroundColor = [UIColor clearColor];
    [btn_title addSubview:lb_title];
    
    UITextField *tf_title = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    tf_title.font = [UIFont boldSystemFontOfSize:17];
    tf_title.textColor = HEX_RGB(0x000000);
    tf_title.tag = 401;
    [btn_title addSubview:tf_title];
    
//    UILabel *lb_content = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
//    lb_content.text = @"请选择";
//    lb_content.font = [UIFont boldSystemFontOfSize:18];
//    lb_content.textColor = HEX_RGB(0x000000);
//    lb_content.backgroundColor = [UIColor clearColor];
//    [btn_title addSubview:lb_content];
    
    [self.scrollView addSubview:btn_title];
    
    //请假类型
    UIButton *btn_leaveType = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_leaveType.frame = CGRectMake(10, CGRectGetMaxY(btn_title.frame) + 10, 300, 40);
    [btn_leaveType setBackgroundImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateNormal];
    [btn_leaveType setBackgroundImage:[[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateHighlighted];
    [btn_leaveType addTarget:self action:@selector(selectLeaveType:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lb_type = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    lb_type.text = @"请假类型";
    lb_type.font = [UIFont boldSystemFontOfSize:17];
    lb_type.textColor = HEX_RGB(0x939fa7);
    lb_type.backgroundColor = [UIColor clearColor];
    [btn_leaveType addSubview:lb_type];
    
    UILabel *lb_typeValue = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    lb_typeValue.text = @"请选择";
    lb_typeValue.font = [UIFont boldSystemFontOfSize:17];
    lb_typeValue.textColor = HEX_RGB(0x000000);
    lb_typeValue.backgroundColor = [UIColor clearColor];
    lb_typeValue.tag = 402;
    [btn_leaveType addSubview:lb_typeValue];
    
    UIImageView *iv_dropbox = [[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 20, 20)];
    iv_dropbox.image = [UIImage imageNamed:@"dropbox"];
    [btn_leaveType addSubview:iv_dropbox];
    
    [self.scrollView addSubview:btn_leaveType];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //起始时间
    UIButton *btn_beginTime = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_beginTime.frame = CGRectMake(10, CGRectGetMaxY(btn_leaveType.frame) + 10, 300, 40);
    [btn_beginTime setBackgroundImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateNormal];
    [btn_beginTime setBackgroundImage:[[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateHighlighted];
    [btn_beginTime addTarget:self action:@selector(selectBeginTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lb_begintime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    lb_begintime.text = @"起始时间";
    lb_begintime.font = [UIFont boldSystemFontOfSize:17];
    lb_begintime.textColor = HEX_RGB(0x939fa7);
    lb_begintime.backgroundColor = [UIColor clearColor];
    [btn_beginTime addSubview:lb_begintime];
    
    UILabel *lb_begintimeValue = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    lb_begintimeValue.text = [formatter stringFromDate:date];
    lb_begintimeValue.font = [UIFont boldSystemFontOfSize:17];
    lb_begintimeValue.textColor = HEX_RGB(0x000000);
    lb_begintimeValue.backgroundColor = [UIColor clearColor];
    lb_begintimeValue.tag = 403;
    [btn_beginTime addSubview:lb_begintimeValue];
    
    UIImageView *iv_begincalendar = [[UIImageView alloc] initWithFrame:CGRectMake(267, 7, 26, 26)];
    iv_begincalendar.image = [UIImage imageNamed:@"tableCtrlBtnIcon_calendar-nor"];
    [btn_beginTime addSubview:iv_begincalendar];
    
    [self.scrollView addSubview:btn_beginTime];
    
    //结束时间
    UIButton *btn_endTime = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_endTime.frame = CGRectMake(10, CGRectGetMaxY(btn_beginTime.frame) + 10, 300, 40);
    [btn_endTime setBackgroundImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateNormal];
    [btn_endTime setBackgroundImage:[[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateHighlighted];
    [btn_endTime addTarget:self action:@selector(selectEndTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lb_endtime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    lb_endtime.text = @"结束时间";
    lb_endtime.font = [UIFont boldSystemFontOfSize:17];
    lb_endtime.textColor = HEX_RGB(0x939fa7);
    lb_endtime.backgroundColor = [UIColor clearColor];
    [btn_endTime addSubview:lb_endtime];
    
    UILabel *lb_endtimeValue = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    lb_endtimeValue.text = [formatter stringFromDate:date];
    lb_endtimeValue.font = [UIFont boldSystemFontOfSize:17];
    lb_endtimeValue.textColor = HEX_RGB(0x000000);
    lb_endtimeValue.backgroundColor = [UIColor clearColor];
    lb_endtimeValue.tag = 404;
    [btn_endTime addSubview:lb_endtimeValue];
    
    UIImageView *iv_endcalendar = [[UIImageView alloc] initWithFrame:CGRectMake(267, 7, 26, 26)];
    iv_endcalendar.image = [UIImage imageNamed:@"tableCtrlBtnIcon_calendar-nor"];
    [btn_endTime addSubview:iv_endcalendar];
    
    [self.scrollView addSubview:btn_endTime];
    
    //请假天数
    UIButton *btn_leaveday = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_leaveday.frame = CGRectMake(10, CGRectGetMaxY(btn_endTime.frame) + 10, 300, 40);
    [btn_leaveday setBackgroundImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateNormal];
    [btn_leaveday setBackgroundImage:[[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateHighlighted];
    
    UILabel *lb_day = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    lb_day.text = @"请假天数";
    lb_day.font = [UIFont boldSystemFontOfSize:17];
    lb_day.textColor = HEX_RGB(0x939fa7);
    lb_day.backgroundColor = [UIColor clearColor];
    [btn_leaveday addSubview:lb_day];
    
    UITextField *tf_day = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    tf_day.font = [UIFont boldSystemFontOfSize:17];
    tf_day.textColor = HEX_RGB(0x000000);
    tf_day.keyboardType = UIKeyboardTypeNumberPad;
    tf_day.tag = 405;
    [btn_leaveday addSubview:tf_day];
    
    UILabel *lb_dayString = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 26, 40)];
    lb_dayString.text = @"天";
    lb_dayString.font = [UIFont boldSystemFontOfSize:17];
    lb_dayString.textColor = HEX_RGB(0x939fa7);
    lb_dayString.backgroundColor = [UIColor clearColor];
    [btn_leaveday addSubview:lb_dayString];
    
    [self.scrollView addSubview:btn_leaveday];
    
    //请假详细描述
    UILabel *lb_description = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(btn_leaveday.frame) + 18, 180, 35)];
    lb_description.text = @"请假详细描述";
    lb_description.font = [UIFont boldSystemFontOfSize:17];
    lb_description.textColor = HEX_RGB(0x939fa7);
    lb_description.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:lb_description];
    
    UIImageView *iv_edge = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lb_description.frame) + 5, 300, 150)];
    [iv_edge setImage:[[UIImage imageNamed:@"bgNo1"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 20, 20)]];
    [self.scrollView addSubview:iv_edge];
    
    UIImageView *iv_input = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lb_description.frame) + 20, 280, 123)];
    [iv_input setImage:[[UIImage imageNamed:@"日期选择控件背板"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)]];
    [self.scrollView addSubview:iv_input];
    
    UITextView *tv_input = [[UITextView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(lb_description.frame) + 22, 270, 115)];
    tv_input.tag = 406;
    [self.scrollView addSubview:tv_input];
    
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"直接审批人：%@",@"0591-83518200" ]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[HEX_RGB(0x939fa7) CGColor] range:NSMakeRange(0,6)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor blackColor] CGColor] range:NSMakeRange(6,hintString1.length - 6)];
    [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(id)[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0,hintString1.length )];
    TTTAttributedLabel *lb_Approval = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(iv_edge.frame) + 10, 280, 35)];
    lb_Approval.textColor = HEX_RGB(0x939fa7);
    lb_Approval.text = hintString1;
    lb_Approval.font = [UIFont boldSystemFontOfSize:18];
    lb_Approval.textAlignment = NSTextAlignmentRight;
    lb_Approval.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:lb_Approval];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(lb_Approval.frame) + 10)];
}

#pragma mark - navBarButton

- (void)setRightBarButtonItem{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setFrame:CGRectMake(0, 2.f, 70.f, 33.f)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

-(BOOL)isVailData{
    NSString *errorMessage = nil;
    UITextField *tf_title = (UITextField *)[_scrollView viewWithTag:401];
    UITextField *tf_day = (UITextField *)[_scrollView viewWithTag:405];
    UITextView *tv_input = (UITextView *)[_scrollView viewWithTag:406];
    if (tf_title.text.length == 0) {
        errorMessage = @"请输入主题";
    }else if(tf_title.text.length == 0){
        errorMessage = @"请选择请假类型";
    }else if(tf_day.text.length == 0){
        errorMessage = @"请输入请假天数";
    }else if (tv_input.text.length == 0){
        errorMessage = @"请输入请假详情";
    }
    if (errorMessage.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)applyLeaveRequest
{
    
}

#pragma mark - Action

- (void)submitAction:(id)sender
{
    if (![self isVailData]) {
        return;
    }
    [self applyLeaveRequest];
}

- (void)selectLeaveType:(id)sender
{
    LeaveTypeHttpRequest *request = [[LeaveTypeHttpRequest alloc] init];
    [XZGLAPI queryLeaveTypeByRequest:request success:^(LeaveTypeHttpResponse *response) {
        _typeList = [[NSMutableArray alloc] init];
        [_typeList addObjectsFromArray:response.LEAVEINFOBEAN];
        NSMutableArray *options = [[NSMutableArray alloc]init];
        [options addObject:@"1"];
        [options addObject:@"2"];
        [options addObject:@"3"];
        LeveyPopListView *listView = [[LeveyPopListView alloc] initWithTitle:@"选择类型" options:options];
        listView.delegate = self;
        [listView showInView:self.navigationController.view animated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}

- (void)selectBeginTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    picker.tag = 108;
    [picker showTitle:@"请选择" inView:self.view];
}

- (void)selectEndTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    picker.tag = 109;
    [picker showTitle:@"请选择" inView:self.view];
}

ON_LKSIGNAL3(UIDatePicker, COMFIRM, signal){
    UIDatePicker *picker =  (UIDatePicker *)signal.sender;
    NSDate *date = picker.date;
    NSLog(@"%@",[date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"] );
    if (picker.tag == 108) {
        UILabel *lb_starttime = (UILabel *)[_scrollView viewWithTag:403];
        lb_starttime.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else if (picker.tag == 109) {
        UILabel *lb_endtime = (UILabel *)[_scrollView viewWithTag:404];
        lb_endtime.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
}

#pragma mark - LeveyPopListViewDelegate

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    
}

@end