//
//  LoginViewController.m
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+External.h"
#import "MBProgressHUD+Add.h"
#import "SystemAPI.h"
#import <UIAlertView+Blocks.h>
#import <IQKeyboardManager.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewContain;

@end

@implementation LoginViewController

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
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    [[IQKeyboardManager sharedManager] setEnable:YES];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_OR_LATER) {
        [self.navigationController.navigationBar setTranslucent:NO];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //        self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    }
#endif
    _viewContain.layer.borderColor = HEX_RGB(0xd3d3d3).CGColor;
    _viewContain.layer.borderWidth = 1.0;
    [_btn_login setBackgroundImage:[[UIImage imageNamed:@"bg_BtnLogin_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_btn_login setBackgroundImage:[[UIImage imageNamed:@"bg_BtnLogin_press@2x"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    
    [self resetBtns];
    if (![ShareValue shareInstance].noRemberFlag) {
        _tf_companycode.text = [ShareValue shareInstance].corpCode;
        _tf_username.text = [ShareValue shareInstance].userName;
        _tf_pwd.text = [ShareValue shareInstance].userPass;
    }
    
//    [((UIScrollView *)self.view) setScrollEnabled:NO];
}

-(NSString *)title{
    return @"登录";
}

-(void)resetBtns{
    
    if (![ShareValue shareInstance].noRemberFlag) {
        [_btn_rember setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateNormal];
        [_btn_rember setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateHighlighted];
    }else{
        [_btn_rember setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateNormal];
        [_btn_rember setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateHighlighted];
    }
    
    if (![ShareValue shareInstance].noShowPwd) {
        [_btn_auto setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateNormal];
        [_btn_auto setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateHighlighted];
        _tf_pwd.secureTextEntry = YES;
    }else{
        [_btn_auto setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateNormal];
        [_btn_auto setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateHighlighted];
        _tf_pwd.secureTextEntry = NO;
    }
}

#pragma mark -action
- (IBAction)loginAction:(id)sender {
    if (![self isVailData]) {
        return;
    }
    [self loginRequest];
}

-(void)loginRequest{
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在登录" toView:self.view];
    [hud showAnimated:YES whileExecutingBlock:^{
        [SystemAPI loginByCorpcode:_tf_companycode.text username:_tf_username.text password:_tf_pwd.text success:^(BNUserInfo *userinfo) {
            dispatch_async(dispatch_get_main_queue() , ^{
                MBProgressHUD *mhud = [[MBProgressHUD alloc]initWithWindow:ShareAppDelegate.window ];
                mhud.labelText = @"正在更新配置...";
                [mhud showAnimated:YES whileExecutingBlock:^{
                    [SystemAPI updateConfigSuccess:^{
                        [self showTabViewController];
                        [mhud removeFromSuperview];
                    } fail:^(BOOL notReachable, NSString *desciption) {
                        [mhud removeFromSuperview];
                        [MBProgressHUD showError:desciption toView:self.view];
                    }];
                }];
                [mhud show:YES];
            });
        } fail:^(BOOL notReachable, NSString *desciption) {
            if (notReachable) {
                if ([[ShareValue shareInstance].corpCode isEqual:_tf_companycode.text] && [[ShareValue shareInstance].userName isEqual:_tf_username.text] && [[ShareValue shareInstance].userPass isEqual:_tf_pwd.text]) {
                    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消" action:nil];
                    RIButtonItem *sureItem = [RIButtonItem itemWithLabel:@"确定" action:^{
                        [self showTabViewController];
                    }];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不佳，是否进入离线模式？" cancelButtonItem: cancelItem otherButtonItems:sureItem, nil];
                    [alert show];
                }else{
                    [MBProgressHUD showError:desciption toView:self.view];
                }
            }else{
                [MBProgressHUD showError:desciption toView:self.view];
            }
        }];
    }];
    
}

-(void)showTabViewController{
    if (![ShareValue shareInstance].noRemberFlag) {
        [ShareValue shareInstance].corpCode = _tf_companycode.text;
        [ShareValue shareInstance].userName = _tf_username.text;
        [ShareValue shareInstance].userPass = _tf_pwd.text;
    }
    [ShareAppDelegate showTabViewController];
}

-(BOOL)isVailData{
    NSString *errorMessage = nil;
    if (_tf_companycode.text.length == 0) {
        errorMessage = @"请输入企业编码";
    }else if(_tf_username.text.length == 0){
        errorMessage = @"请输入用户名";
    }else if(_tf_pwd.text.length == 0){
        errorMessage = @"请输入密码";
    }
    if (errorMessage.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (IBAction)remberAction:(id)sender {
    [ShareValue shareInstance].noRemberFlag = ![ShareValue shareInstance].noRemberFlag;
    [self resetBtns];
}

- (IBAction)autoAction:(id)sender {
    [ShareValue shareInstance].noShowPwd = ![ShareValue shareInstance].noShowPwd;
    [self resetBtns];
}


@end
