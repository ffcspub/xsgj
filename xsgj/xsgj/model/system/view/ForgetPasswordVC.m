//
//  ForgetPasswordVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ForgetPasswordVC.h"
#import "NSString+URL.h"
#import "MBProgressHUD+Add.h"
#import "XTGLAPI.h"
#import <UIAlertView+Blocks.h>
#import <IQKeyboardManager.h>
#import "SIAlertView.h"

@interface ForgetPasswordVC ()

@end

@implementation ForgetPasswordVC

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
    
    self.title = @"忘记密码";
    
    UIButton *rightButton = [self defaultRightButtonWithTitle:@"提交"];
    [rightButton addTarget:self
                    action:@selector(forgetPasswordAction:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    // 设置样式
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 事件

- (IBAction)forgetPasswordAction:(id)sender
{
    [self.tfCorpCode resignFirstResponder];
    [self.tfUserName resignFirstResponder];
    
    if ([self.tfCorpCode.text isEmptyOrWhitespace]) {
        [MBProgressHUD showError:@"请填写完企业编码" toView:self.view];
        return;
    } else if ([self.tfUserName.text isEmptyOrWhitespace]) {
        [MBProgressHUD showError:@"请填写用户账号" toView:self.view];
        return;
    }
    
    ForgetPwdHttpRequest *request = [[ForgetPwdHttpRequest alloc] init];
    request.CORP_CODE = self.tfCorpCode.text;
    request.USER_NAME = self.tfUserName.text;
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在提交···" toView:self.view];
    [hud showAnimated:YES whileExecutingBlock:^{
        [XTGLAPI forgetPwdByRequest:request success:^(ForgetPwdHttpResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:response.MESSAGE.MESSAGECONTENT toView:self.view];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }];
}

@end
