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
#import <NSDate+Helper.h>
#import "NSString+URL.h"
#import "ShareValue.h"

@interface TripApplyVC () <UITextFieldDelegate, UITextViewDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *lblBeginTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lblApproval;

@end

@implementation TripApplyVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    // 常量
    // 布局|xoffset|titleOffset|wTitle|titleOffset|wContent|xoffset| = 320
    CGFloat topOffset = 20.f; // 顶部偏移
    CGFloat xOffset   = 10.f; // 水平边框边距
    CGFloat titleOffset = 10.f; // 标题的水平边距
    CGFloat yOffset   = 10.f; // 垂直间距
    CGFloat rowHeight = 40.f; // 行高
    CGFloat width     = CGRectGetWidth(self.svTripApply.bounds) - xOffset * 2; // 边框行宽
    CGRect rect       = CGRectMake(xOffset, topOffset, width, rowHeight); // 边框区域
    
    CGFloat wTitle = 80.f;
    CGFloat xTitle = xOffset+titleOffset;
    CGRect rectTitle  = CGRectMake(xTitle, topOffset, wTitle, rowHeight);
    CGRect rectStar   = CGRectMake(xTitle + wTitle - 12, topOffset + 14, 10.f, 20.f);
    
    CGFloat xContent = CGRectGetMaxX(rectTitle) + titleOffset;
    CGFloat wContent = width - 2*xOffset - wTitle - 2*titleOffset;
    CGRect rectContent  = CGRectMake(xContent, topOffset, wContent, rowHeight);
    
    // 主题
    UIButton *btnTheme = [ShareValue getDefaulBorder];
    btnTheme.frame = rect;
    [self.svTripApply addSubview:btnTheme];
    
    UILabel *lblTheme = [ShareValue getDefaultInputTitle];
    lblTheme.frame = rectTitle;
    lblTheme.text = @"主      题";
    [self.svTripApply addSubview:lblTheme];
    
    UILabel *lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svTripApply addSubview:lblStart];
    
    UITextField *tfTheme = [ShareValue getDefaultTextField];
    tfTheme.frame = rectContent;
    tfTheme.maxLength = 50;
    tfTheme.keyboardType = UIKeyboardTypeDefault;
    tfTheme.delegate = self;
    [self.svTripApply addSubview:tfTheme];
    self.tfTheme = tfTheme;
    
    // 出差天数
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIButton *btnDays = [ShareValue getDefaulBorder];
    btnDays.frame = rect;
    [self.svTripApply addSubview:btnDays];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblDays = [ShareValue getDefaultInputTitle];
    lblDays.frame = rectTitle;
    lblDays.text = @"出差天数";
    [self.svTripApply addSubview:lblDays];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight + yOffset);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svTripApply addSubview:lblStart];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UITextField *tfDays = [ShareValue getDefaultTextField];
    tfDays.frame = rectContent;
    tfDays.keyboardType = UIKeyboardTypeDecimalPad; // 0 ～ 9 .
    tfDays.maxLength = 5.f;
    tfDays.delegate = self;
    [self.svTripApply addSubview:tfDays];
    self.tfDayNumber = tfDays;
    
    CGRect rectDay = CGRectMake(CGRectGetMaxX(rect) - 30.f, CGRectGetMinY(rectContent) + (rowHeight - 20) / 2, 20.f, 20.f);
    UILabel *lblDay = [ShareValue getDefaultContent];
    lblDay.frame = rectDay;
    lblDay.text = @"天";
    [self.svTripApply addSubview:lblDay];
    
    // 起始时间
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIButton *btnBeginTime = [ShareValue getDefaulBorder];
    btnBeginTime.frame = rect;
    [btnBeginTime addTarget:self action:@selector(beginTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.svTripApply addSubview:btnBeginTime];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblBeginTitle = [ShareValue getDefaultInputTitle];
    lblBeginTitle.frame = rectTitle;
    lblBeginTitle.text = @"起始时间";
    [self.svTripApply addSubview:lblBeginTitle];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight + yOffset);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svTripApply addSubview:lblStart];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblBeginTime = [[UILabel alloc] init];
    lblBeginTime.frame = rectContent;
    lblBeginTime.textColor = COLOR_INPUT_CONTENT;
    lblBeginTime.font = [UIFont systemFontOfSize:FONT_SIZE_INPUT_CONTENT];
    lblBeginTime.backgroundColor = [UIColor clearColor];
    [self.svTripApply addSubview:lblBeginTime];
    self.lblBeginTime = lblBeginTime;
    
    CGRect rectDate = CGRectMake(CGRectGetMaxX(rect) - 36.f, CGRectGetMinY(rectContent) + (rowHeight - 26) / 2, 26.f, 26.f);
    UIImageView *ivStartTime = [[UIImageView alloc] initWithFrame:rectDate];
    ivStartTime.image = [UIImage imageNamed:@"tableCtrlBtnIcon_calendar-nor"];
    [self.svTripApply addSubview:ivStartTime];
    
    // 结束时间
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIButton *btnEndTime = [ShareValue getDefaulBorder];
    btnEndTime.frame = rect;
    [btnEndTime addTarget:self action:@selector(endTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.svTripApply addSubview:btnEndTime];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblEndTitle = [ShareValue getDefaultInputTitle];
    lblEndTitle.frame = rectTitle;
    lblEndTitle.text = @"结束时间";
    [self.svTripApply addSubview:lblEndTitle];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight + yOffset);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svTripApply addSubview:lblStart];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblEndTime = [[UILabel alloc] init];
    lblEndTime.frame = rectContent;
    lblEndTime.textColor = COLOR_INPUT_CONTENT;
    lblEndTime.font = [UIFont systemFontOfSize:FONT_SIZE_INPUT_CONTENT];
    lblEndTime.backgroundColor = [UIColor clearColor];
    [self.svTripApply addSubview:lblEndTime];
    self.lblEndTime = lblEndTime;
    
    rectDate = CGRectMake(CGRectGetMaxX(rect) - 36.f, CGRectGetMinY(rectContent) + (rowHeight - 26) / 2, 26.f, 26.f);
    UIImageView *ivEndTime = [[UIImageView alloc] initWithFrame:rectDate];
    ivEndTime.image = [UIImage imageNamed:@"tableCtrlBtnIcon_calendar-nor"];
    [self.svTripApply addSubview:ivEndTime];
    
    // 出发地
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIButton *btnStarting = [ShareValue getDefaulBorder];
    btnStarting.frame = rect;
    [self.svTripApply addSubview:btnStarting];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblStarting = [ShareValue getDefaultInputTitle];
    lblStarting.frame = rectTitle;
    lblStarting.text = @"出发地点";
    [self.svTripApply addSubview:lblStarting];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight + yOffset);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svTripApply addSubview:lblStart];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UITextField *tfStarting = [ShareValue getDefaultTextField];
    tfStarting.frame = rectContent;
    [self.svTripApply addSubview:tfStarting];
    self.tfStarting = tfStarting;
    
    // 出差地
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIButton *btnDestination = [ShareValue getDefaulBorder];
    btnDestination.frame = rect;
    [self.svTripApply addSubview:btnDestination];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblDestination = [ShareValue getDefaultInputTitle];
    lblDestination.frame = rectTitle;
    lblDestination.text = @"出差地点";
    [self.svTripApply addSubview:lblDestination];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight + yOffset);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svTripApply addSubview:lblStart];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UITextField *tflblDestination = [ShareValue getDefaultTextField];
    tflblDestination.frame = rectContent;
    [self.svTripApply addSubview:tflblDestination];
    self.tfDestination = tflblDestination;
    
    // 详情描述
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight);
    UILabel *lblDescription = [ShareValue getDefaultInputTitle];
    lblDescription.frame = rectTitle;
    lblDescription.text = @"详情描述";
    [self.svTripApply addSubview:lblDescription];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svTripApply addSubview:lblStart];
    
    rect = CGRectOffset(rect, 0.f, rowHeight + 3*yOffset);
    rect.size.height = 2*rowHeight;
    UIView *ivDescription = [ShareValue getDefaultInputBorder];
    ivDescription.frame = rect;
    [self.svTripApply addSubview:ivDescription];
    
    rect = CGRectInset(rect, 10.f, 10.f);
    UITextView *tvDescription = [[UITextView alloc] initWithFrame:CGRectZero];
    tvDescription.frame = rect;
    tvDescription.textColor = COLOR_INPUT_CONTENT;
    tvDescription.font = [UIFont systemFontOfSize:FONT_SIZE_INPUT_CONTENT];
    tvDescription.backgroundColor = [UIColor whiteColor];
    tvDescription.delegate = self;
    [self.svTripApply addSubview:tvDescription];
    self.tvDescription = tvDescription;
    
    // 直接审批人
    UILabel *lblapproval = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, CGRectGetMaxY(ivDescription.frame) + yOffset, width, rowHeight)];
    lblapproval.font = [UIFont systemFontOfSize:FONT_SIZE_INPUT_CONTENT];
    lblapproval.textColor = COLOR_INPUT_CONTENT;
    lblapproval.backgroundColor = [UIColor clearColor];
    lblapproval.textAlignment = NSTextAlignmentRight;
    [self.svTripApply addSubview:lblapproval];
    self.lblApproval = lblapproval;
    
    // 初始化
    self.svTripApply.backgroundColor = HEX_RGB(0xefeff4);
    self.svTripApply.contentSize = CGSizeMake(CGRectGetWidth(self.svTripApply.bounds), CGRectGetMaxY(lblapproval.frame) + yOffset); // 设置可滚动区域
    self.lblApproval.text = [NSString stringWithFormat:@"直接审批人:%@", [ShareValue shareInstance].userInfo.LEADER_NAME];
    
    // 导航
    UIButton *rightButton = [self defaultRightButtonWithTitle:@"提交"];
    [rightButton addTarget:self
                    action:@selector(submitApplyTripAction:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    // 初始化时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.lblBeginTime.text = [formatter stringFromDate:date];
    self.lblEndTime.text = [formatter stringFromDate:date];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.tfTheme)
    {
        if (range.location >= 15)
        {
            return NO;
        }
    }
    // 出差天数限制
    else if (textField == self.tfDayNumber) {
        
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
    if (textView == self.tvDescription) {
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

    [MBProgressHUD showMessag:@"正在提交···" toView:ShareAppDelegate.window];
    [XZGLAPI applyTripByRequest:request success:^(ApplyTripHttpResponse *response) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showSuccess:response.MESSAGE.MESSAGECONTENT toView:self.view];
        [self performSelector:@selector(backToFront) withObject:nil afterDelay:.5f];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
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
