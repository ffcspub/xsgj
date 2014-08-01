//
//  TripDetailVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TripDetailVC.h"
#import "UIButton+style.h"
#import <NSDate+Helper.h>
#import "UIColor+External.h"
#import "MBProgressHUD+Add.h"
#import "XZGLAPI.h"
#import <IQKeyboardManager.h>
#import "SIAlertView.h"
#import <NSDate+Helper.h>
#import "NSString+URL.h"
#import "ShareValue.h"
#import "TripDetailBean.h"

@interface TripDetailVC () <UITextViewDelegate>

@property (nonatomic, strong) TripDetailBean *tripDetail;

@property (weak, nonatomic) IBOutlet UIScrollView *svRoot;
@property (weak, nonatomic) IBOutlet UILabel *lblTheme;
@property (weak, nonatomic) IBOutlet UILabel *lblDays;
@property (weak, nonatomic) IBOutlet UILabel *lblBeginTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lblStarting;
@property (weak, nonatomic) IBOutlet UILabel *lblDestination;
@property (weak, nonatomic) IBOutlet UILabel *lblApprovalMan;
@property (weak, nonatomic) IBOutlet UILabel *lblApprovalState;

@property (weak, nonatomic) IBOutlet UITextView *tvApplyDesc;
@property (weak, nonatomic) IBOutlet UITextView *tvApprovalDesc;

@property (nonatomic, assign) BOOL isNeedToApproval;

@end

@implementation TripDetailVC

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
    
    // 控制滚动
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.title = @"出差详情";
    
    // 待审标识
    if ([self.tripInfo.APPROVE_STATE isEqualToString:@"0"]) {
        self.isNeedToApproval = YES;
    }
    
    [self UI_setup];
    
    [self updateTripInfo];
    
    [self loadTripDetail];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

- (void)UI_setup
{
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    self.svRoot.backgroundColor = HEX_RGB(0xefeff4);
    
    // 常量
    // 布局|xoffset|titleOffset|wTitle|titleOffset|wContent|xoffset| = 320
    CGFloat topOffset = 20.f; // 顶部偏移
    CGFloat xOffset   = 10.f; // 水平边框边距
    CGFloat titleOffset = 10.f; // 标题的水平边距
    CGFloat yOffset   = -1.f; // 垂直间距,为了遮盖住上面边框的一个像素，防止重叠导致加深
    CGFloat rowHeight = 40.f; // 行高
    CGFloat width     = CGRectGetWidth(self.svRoot.bounds) - xOffset * 2; // 边框行宽
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
    [self.svRoot addSubview:vTheme];
    
    UILabel *lblThemeTitle = [ShareValue getDefaultInputTitle];
    lblThemeTitle.frame = rectTitle;
    lblThemeTitle.text = @"主      题";
    [self.svRoot addSubview:lblThemeTitle];
    
    UILabel *lblThemeValue = [ShareValue getDefaultDetailContent];
    lblThemeValue.frame = rectContent;
    [self.svRoot addSubview:lblThemeValue];
    self.lblTheme = lblThemeValue;

    // 出差天数
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vDays = [ShareValue getDefaultShowBorder];
    vDays.frame = rect;
    [self.svRoot addSubview:vDays];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblDaysTitle = [ShareValue getDefaultInputTitle];
    lblDaysTitle.frame = rectTitle;
    lblDaysTitle.text = @"出差天数";
    [self.svRoot addSubview:lblDaysTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblDaysValue = [ShareValue getDefaultDetailContent];
    lblDaysValue.frame = rectContent;
    [self.svRoot addSubview:lblDaysValue];
    self.lblDays = lblDaysValue;
    
    // 起始时间
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vBeginTime = [ShareValue getDefaultShowBorder];
    vBeginTime.frame = rect;
    [self.svRoot addSubview:vBeginTime];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblBeginTimeTitle = [ShareValue getDefaultInputTitle];
    lblBeginTimeTitle.frame = rectTitle;
    lblBeginTimeTitle.text = @"起始时间";
    [self.svRoot addSubview:lblBeginTimeTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblBeginTimeValue = [ShareValue getDefaultDetailContent];
    lblBeginTimeValue.frame = rectContent;
    [self.svRoot addSubview:lblBeginTimeValue];
    self.lblBeginTime = lblBeginTimeValue;
    
    // 结束时间
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vEndTime = [ShareValue getDefaultShowBorder];
    vEndTime.frame = rect;
    [self.svRoot addSubview:vEndTime];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblEndTimeTitle = [ShareValue getDefaultInputTitle];
    lblEndTimeTitle.frame = rectTitle;
    lblEndTimeTitle.text = @"结束时间";
    [self.svRoot addSubview:lblEndTimeTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblEndTimeValue = [ShareValue getDefaultDetailContent];
    lblEndTimeValue.frame = rectContent;
    [self.svRoot addSubview:lblEndTimeValue];
    self.lblEndTime = lblEndTimeValue;
    
    // 出发地点
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vStarting = [ShareValue getDefaultShowBorder];
    vStarting.frame = rect;
    [self.svRoot addSubview:vStarting];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblStartingTitle = [ShareValue getDefaultInputTitle];
    lblStartingTitle.frame = rectTitle;
    lblStartingTitle.text = @"出发地点";
    [self.svRoot addSubview:lblStartingTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblStartingValue = [ShareValue getDefaultDetailContent];
    lblStartingValue.frame = rectContent;
    [self.svRoot addSubview:lblStartingValue];
    self.lblStarting = lblStartingValue;
    
    // 出差地点
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vDestination = [ShareValue getDefaultShowBorder];
    vDestination.frame = rect;
    [self.svRoot addSubview:vDestination];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblDestinationTitle = [ShareValue getDefaultInputTitle];
    lblDestinationTitle.frame = rectTitle;
    lblDestinationTitle.text = @"出差地点";
    [self.svRoot addSubview:lblDestinationTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblDestinationValue = [ShareValue getDefaultDetailContent];
    lblDestinationValue.frame = rectContent;
    [self.svRoot addSubview:lblDestinationValue];
    self.lblDestination = lblDestinationValue;
    
    // 当不用审批的时候才显示
    if (!self.isNeedToApproval) {
        
        // 审批人
        rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
        UIView *vApprovalMan = [ShareValue getDefaultShowBorder];
        vApprovalMan.frame = rect;
        [self.svRoot addSubview:vApprovalMan];
        
        rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
        UILabel *lblApprovalManTitle = [ShareValue getDefaultInputTitle];
        lblApprovalManTitle.frame = rectTitle;
        lblApprovalManTitle.text = @"审  批  人";
        [self.svRoot addSubview:lblApprovalManTitle];
        
        rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
        UILabel *lblApprovalManValue = [ShareValue getDefaultDetailContent];
        lblApprovalManValue.frame = rectContent;
        [self.svRoot addSubview:lblApprovalManValue];
        self.lblApprovalMan = lblApprovalManValue;
        
        // 审批状态
        rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
        UIView *vApprovalState = [ShareValue getDefaultShowBorder];
        vApprovalState.frame = rect;
        [self.svRoot addSubview:vApprovalState];
        
        rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
        UILabel *lblApprovalStateTitle = [ShareValue getDefaultInputTitle];
        lblApprovalStateTitle.frame = rectTitle;
        lblApprovalStateTitle.text = @"审批状态";
        [self.svRoot addSubview:lblApprovalStateTitle];
        
        rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
        UILabel *lblApprovalStateValue = [ShareValue getDefaultDetailContent];
        lblApprovalStateValue.frame = rectContent;
        [self.svRoot addSubview:lblApprovalStateValue];
        self.lblApprovalState = lblApprovalStateValue;
        
    }

    // 详情描述
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + 10.f);
    UILabel *lblDetailDescTitle = [ShareValue getDefaultInputTitle];
    lblDetailDescTitle.frame = rectTitle;
    lblDetailDescTitle.text = @"详情描述";
    [self.svRoot addSubview:lblDetailDescTitle];
    
    rect = CGRectOffset(rect, 0.f, 2*rowHeight);
    rect.size.height = 4*rowHeight;
    UIView *ivDescription = [ShareValue getDefaultShowBorder];
    ivDescription.frame = rect;
    [self.svRoot addSubview:ivDescription];
    
    CGRect rectDescription = CGRectInset(ivDescription.bounds, 10.f, 10.f);
    UITextView *tvDescriptionValue = [[UITextView alloc] initWithFrame:CGRectZero];
    tvDescriptionValue.frame = rectDescription;
    tvDescriptionValue.textColor = COLOR_DETAIL_CONTENT;
    tvDescriptionValue.font = [UIFont systemFontOfSize:FONT_SIZE_DETAIL_CONTENT];
    tvDescriptionValue.backgroundColor = [UIColor whiteColor];
    tvDescriptionValue.editable = NO;
    tvDescriptionValue.delegate = self;
    [ivDescription addSubview:tvDescriptionValue];
    self.tvApplyDesc = tvDescriptionValue;

    // 审批意见
    rectTitle = CGRectMake(xOffset, CGRectGetMaxY(ivDescription.frame) + 10.f, width, rowHeight);
    UILabel *lblApprovalDescTitle = [ShareValue getDefaultInputTitle];
    lblApprovalDescTitle.frame = rectTitle;
    lblApprovalDescTitle.text = @"审批意见";
    [self.svRoot addSubview:lblApprovalDescTitle];
    
    rect = CGRectOffset(rectTitle, 0.f, rowHeight - 10.f);
    rect.size.height = 3*rowHeight;
    UIView *ivApprovalDesc = [ShareValue getDefaultInputBorder];
    ivApprovalDesc.frame = rect;
    [self.svRoot addSubview:ivApprovalDesc];
    
    if (self.showStyle == TripDetailShowStyleApproval) {
        CGRect rectApprovalDescBorder = CGRectInset(rect, 7.f, 7.f);
        UIImageView *ivApprovalDesc = [[UIImageView alloc] init];
        ivApprovalDesc.frame = rectApprovalDescBorder;
        [ivApprovalDesc setImage:[[UIImage imageNamed:@"TextBox_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)]];
        [self.svRoot addSubview:ivApprovalDesc];
    }
    
    CGRect rectApprovalDesc = CGRectInset(rect, 10.f, 10.f);
    UITextView *tvApprovalDescValue = [[UITextView alloc] initWithFrame:CGRectZero];
    tvApprovalDescValue.frame = rectApprovalDesc;
    tvApprovalDescValue.textColor = COLOR_DETAIL_CONTENT;
    tvApprovalDescValue.font = [UIFont systemFontOfSize:FONT_SIZE_DETAIL_CONTENT];
    tvApprovalDescValue.backgroundColor = [UIColor whiteColor];
    tvApprovalDescValue.delegate = self;
    [self.svRoot addSubview:tvApprovalDescValue];
    self.tvApprovalDesc = tvApprovalDescValue;
    
    // 初始化
    self.svRoot.backgroundColor = HEX_RGB(0xefeff4);
    self.svRoot.contentSize = CGSizeMake(CGRectGetWidth(self.svRoot.bounds), CGRectGetMaxY(rect) + 10.f); // 设置可滚动区域
    
    if (self.showStyle == TripDetailShowStyleQuery) {
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
        
        rect = self.svRoot.frame;
        rect.size.height -= 40.f;
        self.svRoot.frame = rect;
    }
}

#pragma mark - UITextView Delegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.tvApprovalDesc) {
        // 关闭键盘
        [[IQKeyboardManager sharedManager] resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.tvApprovalDesc) {
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
    [self.svRoot setScrollEnabled:NO];
}

- (void)keyBoardWillHide
{
    [self.svRoot setScrollEnabled:YES];
}

- (IBAction)agreeAction:(id)sender
{
    // 关闭键盘
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (![self verifyData]) {
        [MBProgressHUD showError:@"请填写审批意见!" toView:self.view];
        return;
    }
    
    [self handleTripAction:YES];
}

- (IBAction)refuseAction:(id)sender
{
    // 关闭键盘
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (![self verifyData]) {
        [MBProgressHUD showError:@"请填写审批意见!" toView:self.view];
        return;
    }
    
    [self handleTripAction:NO];
}

- (BOOL)verifyData
{
    //TODO: 更多的输入验证
	if ([self.tvApprovalDesc.text isEmptyOrWhitespace]) {
        
        return NO;
	}
    
    return YES;
}

- (void)loadTripDetail
{
    QueryTripDetailHttpRequest *rquest = [[QueryTripDetailHttpRequest alloc] init];
    rquest.TRIP_ID = self.tripInfo.TRIP_ID;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [XZGLAPI queryTripDeTailByRequest:rquest success:^(QueryTripDetailHttpResponse *response) {
        
        //!!!: reponse.data返回的数据为空
        self.tripDetail = response.detailTripList.firstObject;
        [self updateTripDetail];
        
        [hub removeFromSuperview];
        //[MBProgressHUD showError:response.MESSAGE.MESSAGECONTENT toView:self.view];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [hub removeFromSuperview];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

- (void)updateTripInfo
{
    self.lblTheme.text = self.tripInfo.TITLE;
    self.lblDays.text = self.tripInfo.TRIP_DAYS;
    self.lblBeginTime.text = self.tripInfo.BEGIN_TIME;
    self.lblEndTime.text = self.tripInfo.END_TIME;
    self.lblStarting.text = self.tripInfo.TRIP_FROM;
    self.lblDestination.text = self.tripInfo.TRIP_TO;
    self.tvApplyDesc.text = self.tripInfo.REMARK;
    self.tvApprovalDesc.text = self.tripInfo.APPROVE_REMARK;
    
    // 0:未审批 1:已通过 2:未通过
    if ([self.tripInfo.APPROVE_STATE intValue] == 0) {
        self.lblApprovalState.text = @"待审";
        self.lblApprovalState.textColor = HEX_RGB(0x3cadde);
    } else if ([self.tripInfo.APPROVE_STATE intValue] == 1) {
        self.lblApprovalState.text = @"通过";
        self.lblApprovalState.textColor = HEX_RGB(0x5fdd74);
    } else {
        self.lblApprovalState.text = @"驳回";
        self.lblApprovalState.textColor = HEX_RGB(0xff9b10);
    }
}

- (void)updateTripDetail
{
    self.lblTheme.text = self.tripDetail.TITLE;
    self.lblBeginTime.text = self.tripDetail.BEGIN_TIME;
    self.lblEndTime.text = self.tripDetail.END_TIME;
    self.lblStarting.text = self.tripDetail.TRIP_FROM;
    self.lblDestination.text = self.tripDetail.TRIP_TO;
    self.tvApplyDesc.text = self.tripDetail.REMARK;
    self.tvApprovalDesc.text = self.tripDetail.APPROVE_REMARK;

    //???: 审批人显示的是哪个字段？
    self.lblApprovalMan.text = self.tripDetail.USER_NAME;
    
    //!!!: TripInfoBean模型没有天数信息
    //self.lblDays.text = self.tripDetail.TRIP_DAYS;
    
    // 0:未审批 1:已通过 2:未通过
    if ([self.tripInfo.APPROVE_STATE intValue] == 0) {
        self.lblApprovalState.text = @"待审";
        self.lblApprovalState.textColor = HEX_RGB(0x3cadde);
    } else if ([self.tripInfo.APPROVE_STATE intValue] == 1) {
        self.lblApprovalState.text = @"通过";
        self.lblApprovalState.textColor = HEX_RGB(0x5fdd74);
    } else {
        self.lblApprovalState.text = @"驳回";
        self.lblApprovalState.textColor = HEX_RGB(0xff9b10);
    }
}

- (void)handleTripAction:(BOOL)isAgree
{
    ApproveTripHttpRequst *request = [[ApproveTripHttpRequst alloc] init];
    //TODO: 为请求赋值参数
    request.TRIP_ID = self.tripInfo.TRIP_ID;
    request.APPROVE_STATE = isAgree ? @"1" : @"2";
    request.APPROVE_TIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.APPROVE_REMARK = self.tvApprovalDesc.text;

    [MBProgressHUD showMessag:@"处理中···" toView:ShareAppDelegate.window];
    [XZGLAPI approvalTripByRequest:request success:^(ApproveTripHttpResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:response.MESSAGE.MESSAGECONTENT toView:self.view];
        
        [self performSelector:@selector(back) withObject:nil afterDelay:.5f];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
