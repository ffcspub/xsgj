//
//  ApprovalInfoViewController.m
//  xsgj
//
//  Created by Geory on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ApprovalInfoViewController.h"
#import "LeaveInfoBean.h"
#import <NSDate+Helper.h>
#import <MBProgressHUD.h>
#import "UIColor+External.h"
#import "MBProgressHUD+Add.h"
#import "XZGLAPI.h"
#import <IQKeyboardManager.h>
#import "SIAlertView.h"
#import "NSString+URL.h"

@interface ApprovalInfoViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTheme;
@property (weak, nonatomic) IBOutlet UILabel *lblDays;
@property (weak, nonatomic) IBOutlet UILabel *lblBeginTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblApprovalMan;
@property (weak, nonatomic) IBOutlet UILabel *lblApprovalState;

@property (weak, nonatomic) IBOutlet UITextView *tvApplyDesc;
@property (weak, nonatomic) IBOutlet UITextView *tvApprovalDesc;

@end

@implementation ApprovalInfoViewController

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
    
    // 控制滚动
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.title = @"请假详情";
    
    [self queryLeaveDetail];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)queryLeaveDetail{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载详情";
    QueryLeaveDetailHttpRequest *request = [[QueryLeaveDetailHttpRequest alloc]init];
    request.LEAVE_ID = _leaveInfo.LEAVE_ID;
    [XZGLAPI queryLeaveDetailByRequest:request success:^(QueryLeaveDetailHttpResponse *response) {
        if (response.LEAVEINFOBEAN.count > 0) {
            self.leaveInfo = response.LEAVEINFOBEAN[0];
        }
        [hud hide:YES];
        [self UI_setup];
        [self updateTripInfo];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}

#pragma mark - UI

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

- (void)UI_setup
{
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    self.scrollView.backgroundColor = HEX_RGB(0xefeff4);
    
    // 常量
    // 布局|xoffset|titleOffset|wTitle|titleOffset|wContent|xoffset| = 320
    CGFloat topOffset = 20.f; // 顶部偏移
    CGFloat xOffset   = 10.f; // 水平边框边距
    CGFloat titleOffset = 10.f; // 标题的水平边距
    CGFloat yOffset   = -1.f; // 垂直间距,为了遮盖住上面边框的一个像素，防止重叠导致加深
    CGFloat rowHeight = 40.f; // 行高
    CGFloat width     = CGRectGetWidth(self.scrollView.bounds) - xOffset * 2; // 边框行宽
    CGRect rect       = CGRectMake(xOffset, topOffset, width, rowHeight); // 边框区域
    
    CGFloat wTitle = 80.f;
    CGFloat xTitle = xOffset+titleOffset;
    CGRect rectTitle  = CGRectMake(xTitle, topOffset, wTitle, rowHeight);
    
    CGFloat xContent = CGRectGetMaxX(rectTitle) + titleOffset;
    CGFloat wContent = width - 2*xOffset - wTitle - 2*titleOffset;
    CGRect rectContent  = CGRectMake(xContent, topOffset, wContent, rowHeight);
    
    // 主题
    UIView *vTheme = [ShareValue getDefaultShowBorder];
    vTheme.frame = rect;
    [self.scrollView addSubview:vTheme];
    
    UILabel *lblThemeTitle = [ShareValue getDefaultInputTitle];
    lblThemeTitle.frame = rectTitle;
    lblThemeTitle.text = @"主      题";
    [self.scrollView addSubview:lblThemeTitle];
    
    UILabel *lblThemeValue = [ShareValue getDefaultDetailContent];
    lblThemeValue.frame = rectContent;
    [self.scrollView addSubview:lblThemeValue];
    self.lblTheme = lblThemeValue;
    
    // 请假天数
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vDays = [ShareValue getDefaultShowBorder];
    vDays.frame = rect;
    [self.scrollView addSubview:vDays];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblDaysTitle = [ShareValue getDefaultInputTitle];
    lblDaysTitle.frame = rectTitle;
    lblDaysTitle.text = @"请假天数";
    [self.scrollView addSubview:lblDaysTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblDaysValue = [ShareValue getDefaultDetailContent];
    lblDaysValue.frame = rectContent;
    [self.scrollView addSubview:lblDaysValue];
    self.lblDays = lblDaysValue;
    
    // 起始时间
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vBeginTime = [ShareValue getDefaultShowBorder];
    vBeginTime.frame = rect;
    [self.scrollView addSubview:vBeginTime];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblBeginTimeTitle = [ShareValue getDefaultInputTitle];
    lblBeginTimeTitle.frame = rectTitle;
    lblBeginTimeTitle.text = @"起始时间";
    [self.scrollView addSubview:lblBeginTimeTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblBeginTimeValue = [ShareValue getDefaultDetailContent];
    lblBeginTimeValue.frame = rectContent;
    [self.scrollView addSubview:lblBeginTimeValue];
    self.lblBeginTime = lblBeginTimeValue;
    
    // 结束时间
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vEndTime = [ShareValue getDefaultShowBorder];
    vEndTime.frame = rect;
    [self.scrollView addSubview:vEndTime];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblEndTimeTitle = [ShareValue getDefaultInputTitle];
    lblEndTimeTitle.frame = rectTitle;
    lblEndTimeTitle.text = @"结束时间";
    [self.scrollView addSubview:lblEndTimeTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblEndTimeValue = [ShareValue getDefaultDetailContent];
    lblEndTimeValue.frame = rectContent;
    [self.scrollView addSubview:lblEndTimeValue];
    self.lblEndTime = lblEndTimeValue;
    
    // 请假类型
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vType = [ShareValue getDefaultShowBorder];
    vType.frame = rect;
    [self.scrollView addSubview:vType];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblTypeTitle = [ShareValue getDefaultInputTitle];
    lblTypeTitle.frame = rectTitle;
    lblTypeTitle.text = @"请假类型";
    [self.scrollView addSubview:lblTypeTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblStartingValue = [ShareValue getDefaultDetailContent];
    lblStartingValue.frame = rectContent;
    [self.scrollView addSubview:lblStartingValue];
    self.lblType = lblStartingValue;
    
    // 出差地点
//    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
//    UIView *vDestination = [ShareValue getDefaultShowBorder];
//    vDestination.frame = rect;
//    [self.scrollView addSubview:vDestination];
//    
//    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
//    UILabel *lblDestinationTitle = [ShareValue getDefaultInputTitle];
//    lblDestinationTitle.frame = rectTitle;
//    lblDestinationTitle.text = @"出差地点";
//    [self.scrollView addSubview:lblDestinationTitle];
//    
//    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
//    UILabel *lblDestinationValue = [ShareValue getDefaultDetailContent];
//    lblDestinationValue.frame = rectContent;
//    [self.scrollView addSubview:lblDestinationValue];
//    self.lblDestination = lblDestinationValue;
    
    // 审批人
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vApprovalMan = [ShareValue getDefaultShowBorder];
    vApprovalMan.frame = rect;
    [self.scrollView addSubview:vApprovalMan];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblApprovalManTitle = [ShareValue getDefaultInputTitle];
    lblApprovalManTitle.frame = rectTitle;
    lblApprovalManTitle.text = @"审  批  人";
    [self.scrollView addSubview:lblApprovalManTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblApprovalManValue = [ShareValue getDefaultDetailContent];
    lblApprovalManValue.frame = rectContent;
    [self.scrollView addSubview:lblApprovalManValue];
    self.lblApprovalMan = lblApprovalManValue;
    
    // 审批状态
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vApprovalState = [ShareValue getDefaultShowBorder];
    vApprovalState.frame = rect;
    [self.scrollView addSubview:vApprovalState];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblApprovalStateTitle = [ShareValue getDefaultInputTitle];
    lblApprovalStateTitle.frame = rectTitle;
    lblApprovalStateTitle.text = @"审批状态";
    [self.scrollView addSubview:lblApprovalStateTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblApprovalStateValue = [ShareValue getDefaultDetailContent];
    lblApprovalStateValue.frame = rectContent;
    [self.scrollView addSubview:lblApprovalStateValue];
    self.lblApprovalState = lblApprovalStateValue;
    
    // 详情描述
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + 10.f);
    UILabel *lblDetailDescTitle = [ShareValue getDefaultInputTitle];
    lblDetailDescTitle.frame = rectTitle;
    lblDetailDescTitle.text = @"详情描述";
    [self.scrollView addSubview:lblDetailDescTitle];
    
    rect = CGRectOffset(rect, 0.f, 2*rowHeight);
    rect.size.height = 5*rowHeight;
    UIView *ivDescription = [ShareValue getDefaultShowBorder];
    ivDescription.frame = rect;
    [self.scrollView addSubview:ivDescription];
    
    CGRect rectDescription = CGRectInset(ivDescription.bounds, 10.f, 10.f);
    UITextView *tvDescriptionValue = [[UITextView alloc] initWithFrame:CGRectZero];
    tvDescriptionValue.frame = rectDescription;
    tvDescriptionValue.textColor = COLOR_DETAIL_CONTENT;
    tvDescriptionValue.font = [UIFont systemFontOfSize:FONT_SIZE_DETAIL_CONTENT];
    tvDescriptionValue.backgroundColor = [UIColor whiteColor];
    tvDescriptionValue.editable = NO;
    tvDescriptionValue.scrollEnabled = YES;
    tvDescriptionValue.delegate = self;
    [ivDescription addSubview:tvDescriptionValue];
    self.tvApplyDesc = tvDescriptionValue;
    
    // 审批意见
    rectTitle = CGRectMake(xOffset, CGRectGetMaxY(ivDescription.frame) + 10.f, width, rowHeight);
    UILabel *lblApprovalDescTitle = [ShareValue getDefaultInputTitle];
    lblApprovalDescTitle.frame = rectTitle;
    lblApprovalDescTitle.text = @"审批意见";
    [self.scrollView addSubview:lblApprovalDescTitle];
    
    rect = CGRectOffset(rectTitle, 0.f, rowHeight - 10.f);
    rect.size.height = 3*rowHeight;
    UIView *ivApprovalDesc = [ShareValue getDefaultInputBorder];
    ivApprovalDesc.frame = rect;
    [self.scrollView addSubview:ivApprovalDesc];
    
    if (self.showStyle == ApprovalInfoShowStyleApproval) {
        CGRect rectApprovalDescBorder = CGRectInset(rect, 7.f, 7.f);
        UIImageView *ivApprovalDesc = [[UIImageView alloc] init];
        ivApprovalDesc.frame = rectApprovalDescBorder;
        [ivApprovalDesc setImage:[[UIImage imageNamed:@"TextBox_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)]];
        [self.scrollView addSubview:ivApprovalDesc];
    }
    
    CGRect rectApprovalDesc = CGRectInset(rect, 10.f, 10.f);
    UITextView *tvApprovalDescValue = [[UITextView alloc] initWithFrame:CGRectZero];
    tvApprovalDescValue.frame = rectApprovalDesc;
    tvApprovalDescValue.textColor = COLOR_DETAIL_CONTENT;
    tvApprovalDescValue.font = [UIFont systemFontOfSize:FONT_SIZE_DETAIL_CONTENT];
    tvApprovalDescValue.backgroundColor = [UIColor whiteColor];
    tvApprovalDescValue.delegate = self;
    [self.scrollView addSubview:tvApprovalDescValue];
    self.tvApprovalDesc = tvApprovalDescValue;
    
    // 初始化
    self.scrollView.backgroundColor = HEX_RGB(0xefeff4);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetMaxY(rect) + 10.f); // 设置可滚动区域
    
    if (self.showStyle == ApprovalInfoShowStyleQuery) {
        self.tvApprovalDesc.editable = NO;
    } else {
        self.tvApprovalDesc.editable = YES;
        
        CGFloat xOffset = 10.f;
        CGFloat midOffset = 50.f;
        CGFloat btnWidth = (CGRectGetWidth(self.view.bounds) - 2*xOffset - midOffset) / 2;
        CGFloat btnHeight = 40.f;
        CGFloat yOffset = CGRectGetHeight(self.view.bounds) - 50;
        if (DEVICE_IS_IPHONE5) {
            yOffset += 88;
        }
        
        CGRect  rect = CGRectMake(xOffset, yOffset, btnWidth, btnHeight);
        UIButton *btnAgree = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAgree setFrame:rect];
        [btnAgree configBlueStyle];
        [btnAgree setTitle:@"同意" forState:UIControlStateNormal];
        [btnAgree addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnAgree];
        
        rect = CGRectOffset(rect, midOffset + btnWidth, 0.f);
        UIButton *btnRefuse = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRefuse setFrame:rect];
        [btnRefuse configBlueStyle];
        [btnRefuse setTitle:@"驳回" forState:UIControlStateNormal];
        [btnRefuse addTarget:self action:@selector(refuseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnRefuse];
        
        rect = self.scrollView.frame;
        rect.size.height -= 40.f;
        self.scrollView.frame = rect;
    }
}

- (void)updateTripInfo
{
    self.lblTheme.text = self.leaveInfo.TITLE;
    self.lblDays.text = [NSString stringWithFormat:@"%@天",self.leaveInfo.LEAVE_DAYS];
    self.lblBeginTime.text = self.leaveInfo.BEGIN_TIME;
    self.lblEndTime.text = self.leaveInfo.END_TIME;
    self.lblType.text = self.leaveInfo.TYPE_NAME;
    self.lblApprovalMan.text = [ShareValue shareInstance].userInfo.LEADER_NAME;
    self.tvApplyDesc.text = self.leaveInfo.REMARK;
    self.tvApprovalDesc.text = self.leaveInfo.APPROVE_REMARK;
    
    // 0:未审批 1:已通过 2:未通过
    if (self.leaveInfo.APPROVE_STATE == 0) {
        self.lblApprovalState.text = @"待审";
        self.lblApprovalState.textColor = HEX_RGB(0x3cadde);
    } else if (self.leaveInfo.APPROVE_STATE == 1) {
        self.lblApprovalState.text = @"通过";
        self.lblApprovalState.textColor = HEX_RGB(0x5fdd74);
    } else {
        self.lblApprovalState.text = @"驳回";
        self.lblApprovalState.textColor = HEX_RGB(0xff9b10);
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location > 200) {
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.tvApprovalDesc) {
        // 关闭键盘
        [[IQKeyboardManager sharedManager] resignFirstResponder];
    }
}

#pragma mark - keyBoard Notification

- (void)keyBoardWillShow
{
    [self.scrollView setScrollEnabled:NO];
}

- (void)keyBoardWillHide
{
    [self.scrollView setScrollEnabled:YES];
}

#pragma mark - Action

- (BOOL)verifyData
{
	if ([self.tvApprovalDesc.text isEmptyOrWhitespace]) {
        
        return NO;
	}
    
    return YES;
}

- (IBAction)agreeAction:(id)sender
{
    // 关闭键盘
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (![self verifyData]) {
        [MBProgressHUD showError:@"请填写审批意见!" toView:self.view];
        return;
    }
    
    [self handleLeaveAction:YES];
}

- (IBAction)refuseAction:(id)sender
{
    // 关闭键盘
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (![self verifyData]) {
        [MBProgressHUD showError:@"请填写审批意见!" toView:self.view];
        return;
    }
    
    [self handleLeaveAction:NO];
}

- (void)handleLeaveAction:(BOOL)isAgree
{
    ApprovalLeaveHttpRequest *request = [[ApprovalLeaveHttpRequest alloc] init];
    request.LEAVE_ID = [self.leaveInfo.LEAVE_ID intValue];
    request.APPROVE_STATE = isAgree ? @"1" : @"2";
    request.APPROVE_TIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.APPROVE_REMARK = self.tvApprovalDesc.text;
    request.APPROVE_USER = [ShareValue shareInstance].userInfo.USER_ID;
    
    [MBProgressHUD showMessag:@"处理中···" toView:self.view];
    [XZGLAPI approvalLeaveByRequest:request success:^(ApprovalLeaveHttpResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.MESSAGE.MESSAGECONTENT toView:self.view];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

@end
