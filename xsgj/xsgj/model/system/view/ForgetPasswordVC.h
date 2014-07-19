//
//  ForgetPasswordVC.h
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"

@interface ForgetPasswordVC : HideTabViewController

@property (weak, nonatomic) IBOutlet UITextField *tfCorpCode;
@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrompt;

@end
