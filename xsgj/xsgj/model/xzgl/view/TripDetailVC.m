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

@interface TripDetailVC ()

@property (nonatomic, strong) TripDetailBean *tripDetail;

@property (weak, nonatomic) IBOutlet UIScrollView *svRoot;
@property (weak, nonatomic) IBOutlet BorderView *vGroupTheme;
@property (weak, nonatomic) IBOutlet BorderView *vGroupDays;
@property (weak, nonatomic) IBOutlet BorderView *vGroupBeginTime;
@property (weak, nonatomic) IBOutlet BorderView *vGroupEndTime;
@property (weak, nonatomic) IBOutlet BorderView *vGroupStarting;
@property (weak, nonatomic) IBOutlet BorderView *vGroupDestination;
@property (weak, nonatomic) IBOutlet BorderView *vGroupApprovalName;
@property (weak, nonatomic) IBOutlet BorderView *vGroupApprovalState;
@property (weak, nonatomic) IBOutlet BorderView *vGroupDetail;
@property (weak, nonatomic) IBOutlet BorderView *vGroupApprovalDescription;

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
    
    self.title = @"出差详情";
    
    [self UI_setup];
    
    [self updateTripInfo];
    
    [self loadTripDetail];
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
    self.svRoot.contentSize = CGSizeMake(CGRectGetWidth(self.svRoot.bounds), self.vGroupApprovalDescription.frame.size.height + self.vGroupApprovalDescription.frame.origin.y);
    
    self.vGroupTheme.borderStyle = BorderViewStyleGroupTop;
    self.vGroupDays.borderStyle = BorderViewStyleGroupMiddle;
    self.vGroupBeginTime.borderStyle = BorderViewStyleGroupMiddle;
    self.vGroupEndTime.borderStyle = BorderViewStyleGroupMiddle;
    self.vGroupStarting.borderStyle = BorderViewStyleGroupMiddle;
    self.vGroupDestination.borderStyle = BorderViewStyleGroupMiddle;
    self.vGroupApprovalName.borderStyle = BorderViewStyleGroupMiddle;
    self.vGroupApprovalState.borderStyle = BorderViewStyleGroupBottom;
    self.vGroupDetail.borderStyle = BorderViewStyleMutableColumn;
    self.vGroupApprovalDescription.borderStyle = BorderViewStyleMutableColumn;
    
    if (self.showStyle == TripDetailShowStyleQuery) {
        self.lblInputFlag.alpha = 0.f;
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


#pragma mark - 事件

- (IBAction)agreeAction:(id)sender
{
    if (![self verifyData]) {
        [MBProgressHUD showError:@"请填写审批意见!" toView:self.view];
        return;
    }
    
    [self handleTripAction:YES];
}

- (IBAction)refuseAction:(id)sender
{
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
    self.lblApprovalState.text = self.tripInfo.APPROVE_STATE;
    self.lblApplyDesc.text = self.tripInfo.REMARK;
}

- (void)updateTripDetail
{
    self.lblTheme.text = self.tripDetail.TITLE;
    self.lblBeginTime.text = self.tripDetail.BEGIN_TIME;
    self.lblEndTime.text = self.tripDetail.END_TIME;
    self.lblStarting.text = self.tripDetail.TRIP_FROM;
    self.lblDestination.text = self.tripDetail.TRIP_TO;
    self.lblApprovalState.text = self.tripDetail.APPROVE_STATE;
    self.lblApplyDesc.text = self.tripDetail.REMARK;
    self.tvApprovalDesc.text = self.tripInfo.APPROVE_REMARK;

    //???: 审批人显示的是哪个字段？
    self.lblApprovalMan.text = self.tripDetail.APPROVE_USER_NAME;
    
    //!!!: TripInfoBean模型没有天数信息
    //self.lblDays.text = self.tripDetail.TRIP_DAYS;
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
