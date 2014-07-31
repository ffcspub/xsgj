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
@property (weak, nonatomic) IBOutlet UIButton *btnCodeBg;
@property (weak, nonatomic) IBOutlet UIButton *btnUserBg;
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
    
    self.tfUserName.text = self.currentCUserName;
    self.tfCorpCode.text = self.currentCropCode;
    
    UIButton *rightButton = [self defaultRightButtonWithTitle:@"提交"];
    [rightButton addTarget:self
                    action:@selector(forgetPasswordAction:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    // 设置样式
    [self.btnCodeBg setBackgroundImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateNormal];
    [self.btnCodeBg setBackgroundImage:[[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateHighlighted];
    
    [self.btnUserBg setBackgroundImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateNormal];
    [self.btnUserBg setBackgroundImage:[[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateHighlighted];
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
            if ([self.tfCorpCode.text isEqual:[ShareValue shareInstance].corpCode] && [self.tfUserName.text isEqual:[ShareValue shareInstance].userName]) {
                [ShareValue shareInstance].userPass = nil;
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:response.MESSAGE.MESSAGECONTENT toView:self.view];
            
            SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"密码重置成功,密码为123456"
                                                  cancelButtonTitle:@"取消"
                                                      cancelHandler:^(SIAlertView *alertView) {}
                                             destructiveButtonTitle:@"确定" destructiveHandler:^(SIAlertView *alertView) {
                                                 
                                                 // 修改成功
                                                 if (self.resultHandler) {
                                                     self.resultHandler(YES);
                                                 }
                                                 
                                                 // 成功后退回登陆界面
                                                 [self performSelector:@selector(back) withObject:nil afterDelay:.5f];
                                             }];
            alert.transitionStyle = SIAlertViewTransitionStyleBounce;
            [alert show];
            
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
