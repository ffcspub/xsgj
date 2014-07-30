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
#import "SIAlertView.h"
#import "LK_EasySignal.h"
#import <NSDate+Helper.h>
#import "ForgetPasswordVC.h"
#import "RegisterVC.h"
#import "AsnyTaskManager.h"
#import "OfflineAPI.h"

@interface LoginViewController ()<TTTAttributedLabelDelegate>{
    UIWebView *_webView;
}

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
    UIButton *btn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [btn setTitle:@"退出" forState:UIControlStateNormal];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction{
    [self exitApplication];
}

// 退出程序
- (void)exitApplication
{
    UIWindow *window =  [UIApplication sharedApplication].delegate.window;
    [UIView animateWithDuration:0.5f animations:^
     {
         window.alpha = 0;
         window.frame = CGRectMake(CGRectGetWidth(window.frame)/2,CGRectGetHeight(window.frame)/2,1, 1);
     }
                     completion:^(BOOL finished)
     {
         exit(0);
     }];
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
    [_btn_login configOrgleStyle];
    [self resetBtns];
    
    [self setLeftButtonTitle:@"退出"];
    
    if (![ShareValue shareInstance].noRemberFlag) {
        _tf_companycode.text = [ShareValue shareInstance].corpCode;
        _tf_username.text = [ShareValue shareInstance].userName;
        _tf_pwd.text = [ShareValue shareInstance].userPass;
    }
    
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"客服电话：%@",@"0591-83518200" ]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor blueColor] CGColor] range:NSMakeRange(5,hintString1.length - 5)];
    [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(id)[UIFont systemFontOfSize:15] range:NSMakeRange(0,hintString1.length )];
    [hintString1 addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] range:NSMakeRange(5,hintString1.length - 5)];
    [hintString1 addAttribute:(id)kCTUnderlineColorAttributeName value:(id)[UIColor blueColor].CGColor range:NSMakeRange(5,hintString1.length - 5)];
    _lb_tel.font = [UIFont systemFontOfSize:19];
    _lb_tel.text = hintString1;
    _lb_tel.delegate = self;
    [_lb_tel addLinkToURL:[NSURL URLWithString:@"tel:0591-83518200"] withRange:NSMakeRange(5,hintString1.length - 5)];
//     [_lb_tel addLinkToPhoneNumber:@"0591-83518200"  withRange:NSMakeRange(5,hintString1.length - 5)];
//    [((UIScrollView *)self.view) setScrollEnabled:NO];
    
    _tf_companycode.maxLength = 30;
    _tf_username.maxLength = 30;
    _tf_pwd.maxLength = 30;
}


#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    if (!_webView) {
        _webView =[[UIWebView alloc] init];
        [self.view addSubview:_webView];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
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
        [_btn_auto setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateNormal];
        [_btn_auto setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateHighlighted];
        _tf_pwd.secureTextEntry = YES;
    }else{
        [_btn_auto setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateNormal];
        [_btn_auto setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateHighlighted];
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
    [SystemAPI loginByCorpcode:_tf_companycode.text username:_tf_username.text password:_tf_pwd.text success:^(BNUserInfo *userinfo) {
        dispatch_async(dispatch_get_main_queue() , ^{
            hud.labelText = @"正在更新配置...";
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [SystemAPI updateConfigSuccess:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showTabViewController];
                        [hud removeFromSuperview];
                    });
                } fail:^(BOOL notReachable, NSString *desciption) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud removeFromSuperview];
                        [MBProgressHUD showError:desciption toView:self.view];
                    });
                }];
            });
        });
    } fail:^(BOOL notReachable, NSString *desciption) {
        [hud removeFromSuperview];
        if (notReachable) {
            if ([[ShareValue shareInstance].corpCode isEqual:_tf_companycode.text] &&
                [[ShareValue shareInstance].userName isEqual:_tf_username.text] &&
                [[ShareValue shareInstance].userPass isEqual:_tf_pwd.text]) {
                
                SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"当前网络不佳，是否进入离线模式？"
                                                      cancelButtonTitle:@"取消"
                                                          cancelHandler:^(SIAlertView *alertView) {}
                                                 destructiveButtonTitle:@"确定"
                                                     destructiveHandler:^(SIAlertView *alertView) {
                                                         [self showTabViewController];
                                                     }];
                [alert show];
            }else{
                [MBProgressHUD showError:desciption toView:self.view];
            }
        }else{
            [MBProgressHUD showError:desciption toView:self.view];
        }
    }];
}

-(void)showTabViewController{
    if (![ShareValue shareInstance].noRemberFlag) {
        [ShareValue shareInstance].corpCode = _tf_companycode.text;
        [ShareValue shareInstance].userName = _tf_username.text;
        [ShareValue shareInstance].userPass = _tf_pwd.text;
    }
    
    [ShareAppDelegate showTabViewController];
    [[AsnyTaskManager shareInstance]loadConfig];
    [[AsnyTaskManager shareInstance]startTask];//开始定时传送
    [[OfflineAPI shareInstance]sendOfflineRequest];
    [[OfflineAPI shareInstance]startListener];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"我们会在7点至20点采集您的定位信息，请在[设置]中打开定位服务，以确保定位准确性" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
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

ON_LKSIGNAL3(UIDatePicker, COMFIRM, signal){
    UIDatePicker *picker =  (UIDatePicker *)signal.sender;
    NSDate *date = picker.date;
    NSLog(@"%@",[date stringWithFormat:@"yyyy-MM-dd"] );
}

//忘记密码
- (IBAction)forgetAction:(id)sender {
    ForgetPasswordVC *vc = [[ForgetPasswordVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//企业注册
- (IBAction)regiterAction:(id)sender {
    RegisterVC *vc = [[RegisterVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
