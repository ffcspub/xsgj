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

@interface TripDetailVC ()

@property (nonatomic, strong) TripDetailBean *data;

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
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在加载···" toView:self.view];
    [hud showAnimated:YES whileExecutingBlock:^{
        [XZGLAPI queryTripDeTailByRequest:rquest success:^(QueryTripDetailHttpResponse *response) {
            
            self.data = response.data;
            [self refreshUI];
    
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:response.MESSAGE.MESSAGECONTENT toView:self.view];
        } fail:^(BOOL notReachable, NSString *desciption) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }];
}

- (void)refreshUI
{
    self.lblTheme.text = self.data.TITLE;
    //!!!: 天数实体中没有
    self.lblDays.text = @"1";
    self.lblBeginTime.text = self.data.BEGIN_TIME;
    self.lblEndTime.text = self.data.END_TIME;
    self.lblStarting.text = self.data.TRIP_FROM;
    self.lblDestination.text = self.data.TRIP_TO;
    self.lblApprovalMan.text = self.data.APPROVE_USER_NAME;
    self.lblApprovalState.text = self.data.APPROVE_STATE;
    self.lblApplyDesc.text = self.data.REMARK;
}

- (void)handleTripAction:(BOOL)isAgree
{
    ApproveTripHttpRequst *request = [[ApproveTripHttpRequst alloc] init];
    //TODO: 为请求赋值参数
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"处理中···" toView:self.view];
    [hud showAnimated:YES whileExecutingBlock:^{
        [XZGLAPI approvalTripByRequest:request success:^(ApproveTripHttpResponse *response) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:response.MESSAGE.MESSAGECONTENT toView:self.view];
            [self performSelector:@selector(back) withObject:nil afterDelay:1.f];
            
        } fail:^(BOOL notReachable, NSString *desciption) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
