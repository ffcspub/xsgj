//
//  LoginViewController.h
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tf_companycode;

@property (weak, nonatomic) IBOutlet UITextField *tf_username;

@property (weak, nonatomic) IBOutlet UITextField *tf_pwd;

@property (weak, nonatomic) IBOutlet UIButton *btn_rember;

@property (weak, nonatomic) IBOutlet UIButton *btn_auto;

@property (weak, nonatomic) IBOutlet UIButton *btn_login;

@end
