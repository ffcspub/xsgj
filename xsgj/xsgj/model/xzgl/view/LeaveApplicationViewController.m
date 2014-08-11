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
#import "LeaveTypeBean.h"
#import "MBProgressHUD+Add.h"
#import "OfflineRequestCache.h"

@interface LeaveApplicationViewController ()<UITextFieldDelegate, UITextViewDelegate>
{
    NSMutableArray *_typeList;
    LeaveTypeBean *_selectType;
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
    lb_title.font = [UIFont systemFontOfSize:17];
    lb_title.textColor = HEX_RGB(0x939fa7);
    lb_title.backgroundColor = [UIColor clearColor];
    [btn_title addSubview:lb_title];
    
    UILabel *lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = CGRectMake(78, 14, 10, 20);
    [btn_title addSubview:lblStart];
    
    UITextField *tf_title = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    tf_title.font = [UIFont systemFontOfSize:17];
    tf_title.maxLength = 15;
    tf_title.textColor = HEX_RGB(0x000000);
    tf_title.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf_title.tag = 401;
    tf_title.delegate = self;
    [btn_title addSubview:tf_title];
    
//    UILabel *lb_content = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
//    lb_content.text = @"请选择";
//    lb_content.font = [UIFont systemFontOfSize:18];
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
    lb_type.font = [UIFont systemFontOfSize:17];
    lb_type.textColor = HEX_RGB(0x939fa7);
    lb_type.backgroundColor = [UIColor clearColor];
    [btn_leaveType addSubview:lb_type];
    
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = CGRectMake(78, 14, 10, 20);
    [btn_leaveType addSubview:lblStart];
    
    UILabel *lb_typeValue = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    lb_typeValue.text = @"请选择";
    lb_typeValue.font = [UIFont systemFontOfSize:17];
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
    lb_begintime.font = [UIFont systemFontOfSize:17];
    lb_begintime.textColor = HEX_RGB(0x939fa7);
    lb_begintime.backgroundColor = [UIColor clearColor];
    [btn_beginTime addSubview:lb_begintime];
    
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = CGRectMake(78, 14, 10, 20);
    [btn_beginTime addSubview:lblStart];
    
    UILabel *lb_begintimeValue = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    lb_begintimeValue.text = [formatter stringFromDate:date];
    lb_begintimeValue.font = [UIFont systemFontOfSize:17];
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
    lb_endtime.font = [UIFont systemFontOfSize:17];
    lb_endtime.textColor = HEX_RGB(0x939fa7);
    lb_endtime.backgroundColor = [UIColor clearColor];
    [btn_endTime addSubview:lb_endtime];
    
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = CGRectMake(78, 14, 10, 20);
    [btn_endTime addSubview:lblStart];
    
    UILabel *lb_endtimeValue = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    lb_endtimeValue.text = [formatter stringFromDate:date];
    lb_endtimeValue.font = [UIFont systemFontOfSize:17];
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
    lb_day.font = [UIFont systemFontOfSize:17];
    lb_day.textColor = HEX_RGB(0x939fa7);
    lb_day.backgroundColor = [UIColor clearColor];
    [btn_leaveday addSubview:lb_day];
    
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = CGRectMake(78, 14, 10, 20);
    [btn_leaveday addSubview:lblStart];
    
    UITextField *tf_day = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    tf_day.font = [UIFont systemFontOfSize:17];
    tf_day.textColor = HEX_RGB(0x000000);
    tf_day.keyboardType = UIKeyboardTypeDecimalPad;
    tf_day.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    tf_day.delegate = self;
    tf_day.tag = 405;
    tf_day.inputRegular = @"^(\\d\\d)(\\.\\d?)?$";
    [btn_leaveday addSubview:tf_day];
    
    UILabel *lb_dayString = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 26, 40)];
    lb_dayString.text = @"天";
    lb_dayString.font = [UIFont systemFontOfSize:17];
    lb_dayString.textColor = HEX_RGB(0x939fa7);
    lb_dayString.backgroundColor = [UIColor clearColor];
    [btn_leaveday addSubview:lb_dayString];
    
    [self.scrollView addSubview:btn_leaveday];
    
    //请假详细描述
    UILabel *lb_description = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(btn_leaveday.frame) + 18, 180, 35)];
    lb_description.text = @"详情描述";
    lb_description.font = [UIFont systemFontOfSize:17];
    lb_description.textColor = HEX_RGB(0x939fa7);
    lb_description.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:lb_description];
    
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = CGRectMake(100, CGRectGetMaxY(btn_leaveday.frame) + 30, 10, 20);
    [self.scrollView addSubview:lblStart];
    
    UIImageView *iv_edge = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lb_description.frame) + 5, 300, 150)];
    [iv_edge setImage:[[UIImage imageNamed:@"bgNo1"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 20, 20)]];
    [self.scrollView addSubview:iv_edge];
    
    UIImageView *iv_input = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lb_description.frame) + 20, 280, 123)];
    [iv_input setImage:[[UIImage imageNamed:@"日期选择控件背板"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)]];
    [self.scrollView addSubview:iv_input];
    
    UITextView *tv_input = [[UITextView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(lb_description.frame) + 22, 270, 115)];
    tv_input.delegate = self;
    tv_input.tag = 406;
    [self.scrollView addSubview:tv_input];
    
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"直接审批人为：%@",[ShareValue shareInstance].userInfo.LEADER_NAME]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[HEX_RGB(0x939fa7) CGColor] range:NSMakeRange(0,7)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor blackColor] CGColor] range:NSMakeRange(7,hintString1.length - 7)];
    [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(id)[UIFont systemFontOfSize:16] range:NSMakeRange(0,7)];
    [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(id)[UIFont systemFontOfSize:22] range:NSMakeRange(7,hintString1.length - 7)];
    UILabel *lb_Approval = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(iv_edge.frame) + 10, 280, 35)];
    lb_Approval.textColor = HEX_RGB(0x000000);
    lb_Approval.text = [NSString stringWithFormat:@"直接审批人为：%@",[ShareValue shareInstance].userInfo.LEADER_NAME];
    lb_Approval.font = [UIFont systemFontOfSize:18];
    lb_Approval.textAlignment = NSTextAlignmentRight;
    lb_Approval.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:lb_Approval];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(lb_Approval.frame) + 10)];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextField *tf_title = (UITextField *)[_scrollView viewWithTag:401];
    UITextField *tf_day = (UITextField *)[_scrollView viewWithTag:405];
    
    if (textField == tf_title)
    {
        if (range.location >= 15)
        {
            return NO;
        }
    }
    // 出差天数限制
    else if (textField == tf_day) {
        
        // 判断是否存在点
        BOOL isHaveDian = YES;
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            isHaveDian=NO;
        }
        
        // 小数点控制
        if ([string length] > 0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                //首字母不能为小数点,当前如果第一个为0，之后只允许输入点
                if([textField.text length]==0){
                    if(single == '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                        
                    }
                } else if ([textField.text isEqualToString:@"0"]) {
                    if (single != '.') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                if (single=='.')
                {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian=YES;
                        return YES;
                    }
                    else
                    {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                else
                {
                    // 长度过滤
                    if (isHaveDian) {
                        if (range.location >= 5) {
                            return NO;
                        }
                    } else {
                        if (range.location >= 3) {
                            return NO;
                        }
                    }
                    
                    if (isHaveDian)//存在小数点
                    {
                        //判断小数点的位数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt=range.location-ran.location;
                        if (tt <= 1){
                            return YES;
                        }else{
                            return NO;
                        }
                    }
                    else
                    {
                        return YES;
                    }
                }
            }
            //输入的数据格式不正确
            else
            {
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextView *tv_input = (UITextView *)[_scrollView viewWithTag:406];
    
    if (textView == tv_input) {
        NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger res = 200 - [new length];
        if(res >= 0)
        {
            return YES;
        }
        else
        {
            NSRange rg = {0,[text length]+res};
            if (rg.length>0) {
                NSString *s = [text substringWithRange:rg];
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            }
            return NO;
        }
    }
    
    return YES;
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
    }else if(!_selectType){
        errorMessage = @"请选择请假类型";
    }else if (tf_day.text.length == 0){
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ApplyLeaveHttpRequest *request = [[ApplyLeaveHttpRequest alloc] init];
    UITextField *tf_title = (UITextField *)[_scrollView viewWithTag:401];
    UILabel *lb_begintimeValue = (UILabel *)[_scrollView viewWithTag:403];
    UILabel *lb_endtimeValue = (UILabel *)[_scrollView viewWithTag:404];
    UITextField *tf_day = (UITextField *)[_scrollView viewWithTag:405];
    UITextView *tv_input = (UITextView *)[_scrollView viewWithTag:406];
    request.TITLE = tf_title.text;
    request.TYPE_ID = _selectType.TYPE_ID;
    request.BEGIN_TIME = lb_begintimeValue.text;
    request.END_TIME = lb_endtimeValue.text;
    request.LEAVE_DAYS = tf_day.text;
    request.REMARK = tv_input.text;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.APPLY_TIME = [formatter stringFromDate:now];
    request.LEADER = [NSString stringWithFormat:@"%d",[ShareValue shareInstance].userInfo.LEADER_ID];
    [XZGLAPI applyLeaveByRequest:request success:^(ApplyLeaveHttpResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.MESSAGE.MESSAGECONTENT toView:self.view];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
    } fail:^(BOOL notReachable, NSString *desciption) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:@"网络不给力" toView:self.view];
        
        if (notReachable) {
            OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:@"请假申请"];
            [cache saveToDB];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:DEFAULT_OFFLINEMESSAGE toView:self.view];
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }
    }];
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
        for (LeaveTypeBean *type in _typeList) {
            [options addObject:[NSDictionary dictionaryWithObjectsAndKeys:type.TYPE_NAME,@"text", nil]];
        }
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
    LeaveTypeBean *type = [_typeList objectAtIndex:anIndex];
    _selectType = type;
    UILabel *lb_typeValue = (UILabel *)[_scrollView viewWithTag:402];
    lb_typeValue.text = type.TYPE_NAME;
}

@end
