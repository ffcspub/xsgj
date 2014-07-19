//
//  CropRegisterVC.h
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"

@interface RegisterVC : HideTabViewController

@property (weak, nonatomic) IBOutlet UITextField *tfCropName;
@property (weak, nonatomic) IBOutlet UITextField *tfCropCode;
@property (weak, nonatomic) IBOutlet UITextField *tfProvince;
@property (weak, nonatomic) IBOutlet UITextField *tfCity;
@property (weak, nonatomic) IBOutlet UITextField *tfType;
@property (weak, nonatomic) IBOutlet UITextField *tfLinkMan;
@property (weak, nonatomic) IBOutlet UITextField *tfTel;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;

@end
