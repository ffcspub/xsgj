//
//  LoginViewController.h
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>
#import "HideTabViewController.h"

@interface LoginViewController : HideTabViewController

@property (weak, nonatomic) IBOutlet UITextField *tf_companycode;

@property (weak, nonatomic) IBOutlet UITextField *tf_username;

@property (weak, nonatomic) IBOutlet UITextField *tf_pwd;

@property (weak, nonatomic) IBOutlet UIButton *btn_rember;

@property (weak, nonatomic) IBOutlet UIButton *btn_auto;

@property (weak, nonatomic) IBOutlet UIButton *btn_login;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *lb_tel;


@end
