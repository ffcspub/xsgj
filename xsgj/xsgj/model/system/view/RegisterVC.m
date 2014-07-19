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
        [MBProgressHUD showError:@"请填写完企业编码" toView:self.view];
        return;
    }
    
    // 通信
    
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在提交···" toView:self.view];
    
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
	if ([self.tfCropName.text isEmptyOrWhitespace] ||
        [self.tfCropCode.text isEmptyOrWhitespace] ||
        [self.tfProvince.text isEmptyOrWhitespace] ||
        [self.tfCity.text isEmptyOrWhitespace] ||
        [self.tfType.text isEmptyOrWhitespace] ||
        [self.tfLinkMan.text isEmptyOrWhitespace] ||
        [self.tfTel.text isEmptyOrWhitespace] ||
        [self.tfEmail.text isEmptyOrWhitespace]) {
        
        return NO;
	}
    
    return YES;
}



@end
