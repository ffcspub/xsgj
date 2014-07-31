//
//  ForgetPasswordVC.h
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"

typedef void (^ForgetPasswordBlock)(BOOL isSuccess);

@interface ForgetPasswordVC : HideTabViewController

@property (nonatomic, copy) NSString *currentCropCode;
@property (nonatomic, copy) NSString *currentCUserName;

@property (weak, nonatomic) IBOutlet UITextField *tfCorpCode;
@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrompt;

@property (nonatomic, copy) ForgetPasswordBlock resultHandler;

@end
