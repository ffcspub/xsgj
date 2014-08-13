//
//  CropRegisterVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "RegisterVC.h"
#import "LK_EasySignal.h"
#import "NSString+URL.h"
#import "MBProgressHUD+Add.h"
#import "XTGLAPI.h"
#import <UIAlertView+Blocks.h>
#import <IQKeyboardManager.h>
#import "SIAlertView.h"
#import <NSDate+Helper.h>
#import "OfflineRequestCache.h"

@interface RegisterVC () <UITextFieldDelegate>

@end

@implementation RegisterVC

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
    
    self.title = @"申请试用";
    
    UIButton *rightButton = [self defaultRightButtonWithTitle:@"提交"];
    [rightButton addTarget:self
                    action:@selector(registerAction:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self UI_setup];
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
    CGFloat width     = CGRectGetWidth(self.svRoot.bounds) - xOffset * 2; // 边框行宽
    CGRect rect       = CGRectMake(xOffset, topOffset, width, rowHeight); // 边框区域
    
    CGFloat wTitle = 80.f;
    CGFloat xTitle = xOffset+titleOffset;
    CGRect rectTitle  = CGRectMake(xTitle, topOffset, wTitle, rowHeight);
    CGRect rectStar   = CGRectMake(xTitle + wTitle - 12, topOffset + 14, 10.f, 20.f);
    
    CGFloat xContent = CGRectGetMaxX(rectTitle) + titleOffset;
    CGFloat wContent = width - xOffset - wTitle - 2*titleOffset;
    CGRect rectContent  = CGRectMake(xContent, topOffset, wContent, rowHeight);
    
    // 主题
    UIButton *btnCropName = [ShareValue getDefaulBorder];
    btnCropName.frame = rect;
    [self.svRoot addSubview:btnCropName];
    
    UILabel *lblCropName = [ShareValue getDefaultInputTitle];
    lblCropName.frame = rectTitle;
    lblCropName.text = @"企业名称";
    [self.svRoot addSubview:lblCropName];
    
    UILabel *lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svRoot addSubview:lblStart];
    
    UITextField *tfCropName = [ShareValue getDefaultTextField];
    tfCropName.frame = rectContent;
    tfCropName.keyboardType = UIKeyboardTypeDefault;
    //tfCropName.delegate = self;
    tfCropName.maxLength = 20;
    [self.svRoot addSubview:tfCropName];
    self.tfCropName = tfCropName;
    
    // 出差天数
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIButton *btnCropCode = [ShareValue getDefaulBorder];
    btnCropCode.frame = rect;
    [self.svRoot addSubview:btnCropCode];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblCropCode = [ShareValue getDefaultInputTitle];
    lblCropCode.frame = rectTitle;
    lblCropCode.text = @"企业编码";
    [self.svRoot addSubview:lblCropCode];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight + yOffset);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svRoot addSubview:lblStart];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UITextField *tfCropCode = [ShareValue getDefaultTextField];
    tfCropCode.placeholder = @"用英文或数字组成,长度不能超过20";
    tfCropCode.frame = rectContent;
    tfCropCode.font = [UIFont systemFontOfSize:12.f];
    tfCropCode.keyboardType = UIKeyboardTypeASCIICapable;
    tfCropCode.delegate = self;
    [self.svRoot addSubview:tfCropCode];
    self.tfCropCode = tfCropCode;
    
    // 所属区域
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIButton *btnAddr = [ShareValue getDefaulBorder];
    btnAddr.frame = rect;
    [self.svRoot addSubview:btnAddr];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblAddr = [ShareValue getDefaultInputTitle];
    lblAddr.frame = rectTitle;
    lblAddr.text = @"所属区域";
    [self.svRoot addSubview:lblAddr];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight + yOffset);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svRoot addSubview:lblStart];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    CGRect rectProvince = CGRectMake(rectContent.origin.x, rectContent.origin.y, CGRectGetWidth(rectContent) / 2 - 20, CGRectGetHeight(rectContent));
    UITextField *tfProvince = [ShareValue getDefaultTextField];
    tfProvince.frame = rectProvince;
    tfProvince.textAlignment = NSTextAlignmentCenter;
    tfProvince.maxLength = 5;
    //tfProvince.delegate = self;
    [self.svRoot addSubview:tfProvince];
    self.tfProvince = tfProvince;
    
    CGRect rectProvinceLabel = CGRectMake(CGRectGetMaxX(rectProvince), CGRectGetMinY(rectProvince), 20.f, CGRectGetHeight(rectProvince));
    UILabel *lblProvince = [ShareValue getDefaultContent];
    lblProvince.frame = rectProvinceLabel;
    lblProvince.text = @"省";
    [self.svRoot addSubview:lblProvince];
    
    CGRect rectCity = CGRectMake(CGRectGetMaxX(rectProvinceLabel), CGRectGetMinY(rectProvinceLabel), CGRectGetWidth(rectContent) / 2 - 20, CGRectGetHeight(rectContent));
    UITextField *tfCity = [ShareValue getDefaultTextField];
    tfCity.frame = rectCity;
    tfCity.textAlignment = NSTextAlignmentCenter;
    tfCity.maxLength = 5;
    //tfCity.delegate = self;
    [self.svRoot addSubview:tfCity];
    self.tfCity = tfCity;
    
    CGRect rectCityLabel = CGRectMake(CGRectGetMaxX(rectCity), CGRectGetMinY(rectCity), 20.f, CGRectGetHeight(rectCity));
    UILabel *lblCity = [ShareValue getDefaultContent];
    lblCity.frame = rectCityLabel;
    lblCity.text = @"市";
    [self.svRoot addSubview:lblCity];
    
    // 行业类型
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIButton *btnType = [ShareValue getDefaulBorder];
    btnType.frame = rect;
    [self.svRoot addSubview:btnType];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblType = [ShareValue getDefaultInputTitle];
    lblType.frame = rectTitle;
    lblType.text = @"行业类型";
    [self.svRoot addSubview:lblType];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight + yOffset);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svRoot addSubview:lblStart];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UITextField *tfType = [ShareValue getDefaultTextField];
    tfType.frame = rectContent;
    tfType.maxLength = 10;
    //tfType.delegate = self;
    [self.svRoot addSubview:tfType];
    self.tfType = tfType;
    
    // 联系人
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIButton *btnLinkMan = [ShareValue getDefaulBorder];
    btnLinkMan.frame = rect;
    [self.svRoot addSubview:btnLinkMan];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblLinkMan = [ShareValue getDefaultInputTitle];
    lblLinkMan.frame = rectTitle;
    lblLinkMan.text = @"联  系  人";
    [self.svRoot addSubview:lblLinkMan];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight + yOffset);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svRoot addSubview:lblStart];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UITextField *tfLinkMan = [ShareValue getDefaultTextField];
    tfLinkMan.frame = rectContent;
    tfLinkMan.maxLength = 10;
    //tfLinkMan.delegate = self;
    [self.svRoot addSubview:tfLinkMan];
    self.tfLinkMan = tfLinkMan;
    
    // 手机号码
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIButton *btnTel = [ShareValue getDefaulBorder];
    btnTel.frame = rect;
    [self.svRoot addSubview:btnTel];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblTel = [ShareValue getDefaultInputTitle];
    lblTel.frame = rectTitle;
    lblTel.text = @"手机号码";
    [self.svRoot addSubview:lblTel];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight + yOffset);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svRoot addSubview:lblStart];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UITextField *tfTel = [ShareValue getDefaultTextField];
    tfTel.frame = rectContent;
    tfTel.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    tfTel.delegate = self;
    [self.svRoot addSubview:tfTel];
    self.tfTel = tfTel;
    
    // 邮箱
    rect = CGRectOffset(rect, 0.f, rowHeight + yOffset);
    UIButton *btnEmail = [ShareValue getDefaulBorder];
    btnEmail.frame = rect;
    [self.svRoot addSubview:btnEmail];
    
    rectTitle = CGRectOffset(rectTitle, 0.f, rowHeight + yOffset);
    UILabel *lblEmail = [ShareValue getDefaultInputTitle];
    lblEmail.frame = rectTitle;
    lblEmail.text = @"电子邮箱";
    [self.svRoot addSubview:lblEmail];
    
    rectStar = CGRectOffset(rectStar, 0.f, rowHeight + yOffset);
    lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = rectStar;
    [self.svRoot addSubview:lblStart];
    
    rectContent = CGRectOffset(rectContent, 0.f, rowHeight + yOffset);
    UITextField *tfEmail = [ShareValue getDefaultTextField];
    tfEmail.frame = rectContent;
    tfEmail.keyboardType = UIKeyboardTypeEmailAddress;
    //tfEmail.delegate = self;
    tfEmail.maxLength = 20;
    [self.svRoot addSubview:tfEmail];
    self.tfEmail = tfEmail;
    
    // 初始化
    self.svRoot.backgroundColor = HEX_RGB(0xefeff4);
    self.svRoot.contentSize = CGSizeMake(CGRectGetWidth(self.svRoot.bounds), CGRectGetMaxY(rect) + yOffset); // 设置可滚动区域
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 企业编码限制长度20
    if (textField == self.tfCropCode || textField == self.tfCropName || textField == self.tfTel)
    {
        if (textField == self.tfCropCode) {
            if ([textField.text length] > 0) {
                textField.font = [UIFont systemFontOfSize:FONT_SIZE_INPUT_CONTENT];
            } else {
                textField.font = [UIFont systemFontOfSize:12.f];
            }
        }
        
        if (![ShareValue legalTextFieldInputWithLegalString:NumberAndCharacters checkedString:string] || range.location >= 20)
        {
            return NO;
        }
    }
    // 电子邮箱限制长度20
    else if (textField == self.tfEmail) {
        if (range.location >= 20) {
            return NO;
        }
    }
    // 省市限制长度为5
    else if (textField == self.tfProvince || textField == self.tfCity) {
        if (range.location >= 5) {
            return NO;
        }
    }
    // 行业类型和联系人显示10
    else if (textField == self.tfType || textField == self.tfLinkMan) {
        if (range.location >= 10) {
            return NO;
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件

- (IBAction)registerAction:(id)sender
{
    // 关闭键盘
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (![self verifyInput]) {
        return;
    }
    
    // 通信
    AddApplyCorpHttpRequest *request = [[AddApplyCorpHttpRequest alloc] init];
    request.NAME = self.tfCropName.text;
    request.CODE = self.tfCropCode.text;
    request.AREAADDRESS = [NSString stringWithFormat:@"%@省%@市", self.tfProvince.text, self.tfCity.text];
    request.TYPE = self.tfType.text;
    request.LINKNAME = self.tfLinkMan.text;
    request.TEL = self.tfTel.text;
    request.EMAIL = self.tfEmail.text;
    request.COMMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    request.REMARK = @"";
    
    [MBProgressHUD showMessag:@"正在提交···" toView:ShareAppDelegate.window];
    [XTGLAPI addApplyCorpHttpRequest:request success:^(AddApplyCorpHttpResponse *response) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"申请资料提交成功"];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  
                              }];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  [self.navigationController popViewControllerAnimated:YES];
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        if (notReachable) {
            OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:@"申请试用"];
            [cache saveToDB];
            
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showSuccess:DEFAULT_OFFLINEMESSAGE toView:nil];
            
            [self performSelector:@selector(backToFront) withObject:nil afterDelay:0.f];
        } else {
            
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showError:desciption toView:nil];
        }
    }];
}

- (void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)verifyInput
{
    //TODO: 更多的输入验证
	if (self.tfCropName.text.length == 0 ||
        self.tfCropCode.text.length == 0 ||
        self.tfProvince.text.length == 0 ||
        self.tfCity.text.length == 0 ||
        self.tfType.text.length == 0 ||
        self.tfLinkMan.text.length == 0 ||
        self.tfTel.text.length == 0 ||
        self.tfEmail.text.length == 0) {
        
        [MBProgressHUD showError:@"信息未填完整,请填写完整后提交!" toView:self.view];
        return NO;
	}
    
    // 需求不需要电话号码验证
    /*
    if (![self.tfTel.text isTelephone]) {
        
        [MBProgressHUD showError:@"联系电话输入有误!" toView:self.view];
        return NO;
    }
    */
    
    if (![self.tfEmail.text isEmail]) {
        
        [MBProgressHUD showError:@"电子邮箱输入有误!" toView:self.view];
        return NO;
    }
    
    return YES;
}



@end
