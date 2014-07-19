//
//  CropRegisterVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "RegisterVC.h"
#import "NSString+URL.h"
#import "MBProgressHUD+Add.h"
#import "XTGLAPI.h"
#import <UIAlertView+Blocks.h>
#import <IQKeyboardManager.h>
#import "SIAlertView.h"
#import <NSDate+Helper.h>

@interface RegisterVC ()

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件

- (IBAction)registerAction:(id)sender
{
    [self closeInputKeyboard];
    
    if (![self verifyInput]) {
        [MBProgressHUD showError:@"信息未填完整,请填写完整后提交!" toView:self.view];
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
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在提交···" toView:self.view];
    [hud showAnimated:YES whileExecutingBlock:^{
        [XTGLAPI addApplyCorpHttpRequest:request success:^(AddApplyCorpHttpResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
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
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }];
}

- (void)closeInputKeyboard
{
    [self.tfCropName resignFirstResponder];
    [self.tfCropCode resignFirstResponder];
    [self.tfProvince resignFirstResponder];
    [self.tfCity resignFirstResponder];
    [self.tfType resignFirstResponder];
    [self.tfLinkMan resignFirstResponder];
    [self.tfTel resignFirstResponder];
    [self.tfEmail resignFirstResponder];
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
        
        return NO;
	}
    
    return YES;
}



@end
