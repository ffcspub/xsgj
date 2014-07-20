//
//  TripApplyVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TripApplyVC.h"
#import "LK_EasySignal.h"
#import "TripInfoBean.h"
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

@interface TripApplyVC ()

@end

@implementation TripApplyVC

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
    
    // 控制滚动
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UI_setup
{
    // 设置可滚动区域
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    self.svTripApply.backgroundColor = HEX_RGB(0xefeff4);
    self.svTripApply.contentSize = CGSizeMake(CGRectGetWidth(self.svTripApply.bounds), 500);
    self.lblApproval.text = [NSString stringWithFormat:@"直接审批人:%@", [ShareValue shareInstance].userInfo.LEADER_NAME];
    
    UIButton *rightButton = [self defaultRightButtonWithTitle:@"提交"];
    [rightButton addTarget:self
                    action:@selector(submitApplyTripAction:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    // 日期选择
    [self.btnBeginTime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateNormal];
    [self.btnBeginTime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板_s"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateHighlighted];
    
    [self.btnEndTime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateNormal];
    [self.btnEndTime setBackgroundImage:[[UIImage imageNamed:@"日期选择控件背板_s"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateHighlighted];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.lblBeginTime.text = [formatter stringFromDate:date];
    self.lblBeginTime.font = [UIFont systemFontOfSize:15];
    self.lblBeginTime.textColor = HEX_RGB(0x000000);
    self.lblBeginTime.backgroundColor = [UIColor clearColor];
    
    self.lblEndTime.text = [formatter stringFromDate:date];
    self.lblEndTime.font = [UIFont systemFontOfSize:15];
    self.lblEndTime.textColor = HEX_RGB(0x000000);
    self.lblEndTime.backgroundColor = [UIColor clearColor];
}

#pragma mark - 事件

- (void)keyBoardWillShow
{
    [self.svTripApply setScrollEnabled:NO];
}

- (void)keyBoardWillHide
{
    [self.svTripApply setScrollEnabled:YES];
}

- (IBAction)submitApplyTripAction:(id)sender
{
    // 关闭键盘
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (![self verifyData]) {
        return;
    }
    
    ApplyTripHttpRequest *request = [[ApplyTripHttpRequest alloc] init];
    request.TITLE        = self.tfTheme.text;
    request.BEGIN_TIME   = self.lblBeginTime.text;
    request.END_TIME     = self.lblEndTime.text;
    request.TRIP_DAYS    = self.tfDayNumber.text;
    request.TRIP_FROM    = self.tfStarting.text;
    request.TRIP_TO      = self.tfDestination.text;
    request.REMARK       = self.tvDescription.text;
    request.APPLY_TIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.APPROVE_USER = [NSString stringWithFormat:@"%d",[ShareValue shareInstance].userInfo.USER_ID];
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在提交···" toView:self.view];
    [hud showAnimated:YES whileExecutingBlock:^{
        [XZGLAPI applyTripByRequest:request success:^(ApplyTripHttpResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:response.MESSAGE.MESSAGECONTENT toView:self.view];
            [self performSelector:@selector(backToFront) withObject:nil afterDelay:1.f];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }];
}

- (void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)beginTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    picker.tag = 1000;
    [picker showTitle:@"请选择起始时间" inView:self.view];
}

- (IBAction)endTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    picker.tag = 1001;
    [picker showTitle:@"请选择结束时间" inView:self.view];
}

ON_LKSIGNAL3(UIDatePicker, COMFIRM, signal)
{
    UIDatePicker *picker =  (UIDatePicker *)signal.sender;
    NSDate *date = picker.date;
    if (picker.tag == 1000) {
        self.lblBeginTime.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        self.lblEndTime.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
}

- (BOOL)verifyData
{
    //TODO: 更多的输入验证
	if ([self.tfTheme.text isEmptyOrWhitespace] ||
        [self.tfDayNumber.text isEmptyOrWhitespace] ||
        [self.lblBeginTime.text isEmptyOrWhitespace] ||
        [self.lblEndTime.text isEmptyOrWhitespace] ||
        [self.tfStarting.text isEmptyOrWhitespace] ||
        [self.tfDestination.text isEmptyOrWhitespace] ||
        [self.tvDescription.text isEmptyOrWhitespace]) {
        
        [MBProgressHUD showError:@"信息未填完整,请填写完整后提交!" toView:self.view];
        return NO;
	}
    
    return YES;
}

@end
