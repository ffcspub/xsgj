//
//  DistributionDetailVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DistributionDetailVC.h"

@interface DistributionDetailVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *svRoot;

@property (weak, nonatomic) IBOutlet UILabel *lblOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkMan;
@property (weak, nonatomic) IBOutlet UILabel *lblTel;
@property (weak, nonatomic) IBOutlet UILabel *lblAddr;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark;

@end

@implementation DistributionDetailVC

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
    
    self.title = @"配送详情";
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    
    [self UI_setup];
    
    [self updateDistributionInfoBean];
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
    
    // 单号
    UIView *vOrderNumber = [ShareValue getDefaultShowBorder];
    vOrderNumber.frame = rect;
    [self.svRoot addSubview:vOrderNumber];
    
    UILabel *lblOrderNumberTitle = [ShareValue getDefaultInputTitle];
    lblOrderNumberTitle.frame = rectTitle;
    lblOrderNumberTitle.text = @"单      号";
    [self.svRoot addSubview:lblOrderNumberTitle];
    
    UILabel *lblOrderNumberValue = [ShareValue getDefaultDetailContent];
    lblOrderNumberValue.frame = rectContent;
    [self.svRoot addSubview:lblOrderNumberValue];
    self.lblOrderNumber = lblOrderNumberValue;
    
    // 客户名称
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vName = [ShareValue getDefaultShowBorder];
    vName.frame = rect;
    [self.svRoot addSubview:vName];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblNameTitle = [ShareValue getDefaultInputTitle];
    lblNameTitle.frame = rectTitle;
    lblNameTitle.text = @"客户名称";
    [self.svRoot addSubview:lblNameTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblNameValue = [ShareValue getDefaultDetailContent];
    lblNameValue.frame = rectContent;
    [self.svRoot addSubview:lblNameValue];
    self.lblName = lblNameValue;
    
    // 联系人
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vLinkMan = [ShareValue getDefaultShowBorder];
    vLinkMan.frame = rect;
    [self.svRoot addSubview:vLinkMan];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblLinkManTitle = [ShareValue getDefaultInputTitle];
    lblLinkManTitle.frame = rectTitle;
    lblLinkManTitle.text = @"联  系  人";
    [self.svRoot addSubview:lblLinkManTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblLinkManValue = [ShareValue getDefaultDetailContent];
    lblLinkManValue.frame = rectContent;
    [self.svRoot addSubview:lblLinkManValue];
    self.lblLinkMan = lblLinkManValue;
    
    // 联系电话
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vTel = [ShareValue getDefaultShowBorder];
    vTel.frame = rect;
    [self.svRoot addSubview:vTel];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblTelTitle = [ShareValue getDefaultInputTitle];
    lblTelTitle.frame = rectTitle;
    lblTelTitle.text = @"联系电话";
    [self.svRoot addSubview:lblTelTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblTelValue = [ShareValue getDefaultDetailContent];
    lblTelValue.frame = rectContent;
    [self.svRoot addSubview:lblTelValue];
    self.lblTel = lblTelValue;
    
    // 配送地址
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vAddr = [ShareValue getDefaultShowBorder];
    vAddr.frame = rect;
    [self.svRoot addSubview:vAddr];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblAddrTitle = [ShareValue getDefaultInputTitle];
    lblAddrTitle.frame = rectTitle;
    lblAddrTitle.text = @"配送地址";
    [self.svRoot addSubview:lblAddrTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblAddrValue = [ShareValue getDefaultDetailContent];
    lblAddrValue.frame = rectContent;
    [self.svRoot addSubview:lblAddrValue];
    self.lblAddr = lblAddrValue;
    
    // 配送产品
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vProductName = [ShareValue getDefaultShowBorder];
    vProductName.frame = rect;
    [self.svRoot addSubview:vProductName];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblProductTitle = [ShareValue getDefaultInputTitle];
    lblProductTitle.frame = rectTitle;
    lblProductTitle.text = @"配送产品";
    [self.svRoot addSubview:lblProductTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblProductNameValue = [ShareValue getDefaultDetailContent];
    lblProductNameValue.frame = rectContent;
    [self.svRoot addSubview:lblProductNameValue];
    self.lblProductName = lblProductNameValue;
    
    // 预约时间
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vBookTime = [ShareValue getDefaultShowBorder];
    vBookTime.frame = rect;
    [self.svRoot addSubview:vBookTime];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblBookTimeTitle = [ShareValue getDefaultInputTitle];
    lblBookTimeTitle.frame = rectTitle;
    lblBookTimeTitle.text = @"预约时间";
    [self.svRoot addSubview:lblBookTimeTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblBookTimeValue = [ShareValue getDefaultDetailContent];
    lblBookTimeValue.frame = rectContent;
    [self.svRoot addSubview:lblBookTimeValue];
    self.lblTime = lblBookTimeValue;
    
    // 状态
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vState = [ShareValue getDefaultShowBorder];
    vState.frame = rect;
    [self.svRoot addSubview:vState];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblStateTitle = [ShareValue getDefaultInputTitle];
    lblStateTitle.frame = rectTitle;
    lblStateTitle.text = @"状      态";
    [self.svRoot addSubview:lblStateTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblStateValue = [ShareValue getDefaultDetailContent];
    lblStateValue.frame = rectContent;
    [self.svRoot addSubview:lblStateValue];
    self.lblState = lblStateValue;
    
    // 预约时间
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIView *vRemark = [ShareValue getDefaultShowBorder];
    vRemark.frame = rect;
    [self.svRoot addSubview:vRemark];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblRemarkTitle = [ShareValue getDefaultInputTitle];
    lblRemarkTitle.frame = rectTitle;
    lblRemarkTitle.text = @"备      注";
    [self.svRoot addSubview:lblRemarkTitle];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UILabel *lblRemarkValue = [ShareValue getDefaultDetailContent];
    lblRemarkValue.frame = rectContent;
    [self.svRoot addSubview:lblRemarkValue];
    self.lblRemark = lblRemarkValue;
    
    // 初始化
    self.svRoot.backgroundColor = HEX_RGB(0xefeff4);
    self.svRoot.contentSize = CGSizeMake(CGRectGetWidth(self.svRoot.bounds), CGRectGetMaxY(rect) + 10.f); // 设置可滚动区域
}

- (void)updateDistributionInfoBean
{
    self.lblOrderNumber.text = self.disBean.DATE_ID;
    self.lblName.text = self.disBean.CUST_NAME;
    self.lblLinkMan.text = self.disBean.LINKMAN;
    self.lblTel.text = self.disBean.PHONE;
    self.lblAddr.text = self.disBean.ADDRESS;
    self.lblProductName.text = self.disBean.PROD_NAME;
    self.lblTime.text = self.disBean.YY_TIME;
    self.lblState.text = self.disBean.STATE_NAME;
    self.lblRemark.text = self.disBean.REMARK;
}

@end
