//
//  ChangePasswordViewController.m
//  xsgj
//
//  Created by Geory on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "XTGLAPI.h"
#import "MBProgressHUD+Add.h"
#import "CRSA.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tf_oldpwd;
@property (weak, nonatomic) IBOutlet UITextField *tf_newpwd;
@property (weak, nonatomic) IBOutlet UITextField *tf_confirmpwd;

@end

@implementation ChangePasswordViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self setup];
    
    [self setRightBarButtonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    UILabel *lb_account = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 35)];
    lb_account.text = [NSString stringWithFormat:@"当前账号：%@",[ShareValue shareInstance].userInfo.USER_NAME];
    lb_account.textColor = HEX_RGB(0x409be4);
    lb_account.font = [UIFont systemFontOfSize:18];
    lb_account.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lb_account];
    
    UIImageView *iv_oldpwd = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lb_account.frame) + 10, 300, 40)];
    [iv_oldpwd setImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)]];
    [self.view addSubview:iv_oldpwd];
    
    UILabel *lb_oldpwd = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lb_account.frame) + 10, 80, 40)];
    lb_oldpwd.text = @"旧密码";
    lb_oldpwd.font = [UIFont boldSystemFontOfSize:17];
    lb_oldpwd.textColor = HEX_RGB(0x939fa7);
    lb_oldpwd.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lb_oldpwd];
    
    UITextField *tf_oldpwd = [[UITextField alloc] initWithFrame:CGRectMake(110, CGRectGetMaxY(lb_account.frame) + 10, 180, 40)];
    [tf_oldpwd setBorderStyle:UITextBorderStyleNone];
    tf_oldpwd.secureTextEntry = YES;
    tf_oldpwd.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:tf_oldpwd];
    _tf_oldpwd = tf_oldpwd;
    
    UIImageView *iv_newpwd = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(iv_oldpwd.frame) + 15, 300, 40)];
    [iv_newpwd setImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)]];
    [self.view addSubview:iv_newpwd];
    
    UILabel *lb_newpwd = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(iv_oldpwd.frame) + 15, 80, 40)];
    lb_newpwd.text = @"新密码";
    lb_newpwd.font = [UIFont boldSystemFontOfSize:17];
    lb_newpwd.textColor = HEX_RGB(0x939fa7);
    lb_newpwd.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lb_newpwd];
    
    UITextField *tf_newpwd = [[UITextField alloc] initWithFrame:CGRectMake(110, CGRectGetMaxY(iv_oldpwd.frame) + 15, 180, 40)];
    [tf_newpwd setBorderStyle:UITextBorderStyleNone];
    tf_newpwd.secureTextEntry = YES;
    tf_newpwd.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:tf_newpwd];
    _tf_newpwd = tf_newpwd;
    
    UIImageView *iv_confirmpwd = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(iv_newpwd.frame) + 15, 300, 40)];
    [iv_confirmpwd setImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)]];
    [self.view addSubview:iv_confirmpwd];
    
    UILabel *lb_confirmpwd = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(iv_newpwd.frame) + 15, 80, 40)];
    lb_confirmpwd.text = @"确认密码";
    lb_confirmpwd.font = [UIFont boldSystemFontOfSize:17];
    lb_confirmpwd.textColor = HEX_RGB(0x939fa7);
    lb_confirmpwd.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lb_confirmpwd];
    
    UITextField *tf_confirmpwd = [[UITextField alloc] initWithFrame:CGRectMake(110, CGRectGetMaxY(iv_newpwd.frame) + 15, 180, 40)];
    [tf_confirmpwd setBorderStyle:UITextBorderStyleNone];
    tf_confirmpwd.secureTextEntry = YES;
    tf_confirmpwd.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:tf_confirmpwd];
    _tf_confirmpwd = tf_confirmpwd;
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
}

#pragma mark - navBarButton

- (void)setRightBarButtonItem{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setFrame:CGRectMake(0, 2.f, 70.f, 33.f)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

#pragma mark - private

- (BOOL)isValidData
{
    NSString *errorMessage = nil;
    if (_tf_oldpwd.text.length == 0) {
        errorMessage = @"请输入旧密码";
    }else if(_tf_newpwd.text.length == 0){
        errorMessage = @"请输入新密码";
    }else if (_tf_confirmpwd.text.length == 0){
        errorMessage = @"请输入确认密码";
    }else if (![_tf_newpwd.text isEqualToString:_tf_confirmpwd.text]){
        errorMessage = @"密码不一致，请重新输入";
    }
    if (errorMessage.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)updatePwdRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UpdataPwdHttpRequest *request = [[UpdataPwdHttpRequest alloc] init];
    request.OLDPWD = [[CRSA shareInstance]encryptByRsa:_tf_oldpwd.text withKeyType:KeyTypePublic];
    request.NEWPWD = [[CRSA shareInstance]encryptByRsa:_tf_newpwd.text withKeyType:KeyTypePublic];
    
    [XTGLAPI updatePwdByRequest:request success:^(UpdatePwdHttpResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
        
        [self performSelector:@selector(back) withObject:nil afterDelay:.5f];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

#pragma mark - Action

- (void)submitAction:(id)sender
{
    if (![self isValidData]) {
        return;
    }
    [self updatePwdRequest];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
