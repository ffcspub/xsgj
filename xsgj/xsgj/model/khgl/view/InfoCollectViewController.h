//
//  InfoCollectViewController.h
//  xsgj
//
//  Created by ilikeido on 14-7-14.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "KHGLAPI.h"
#import "BNCustomerInfo.h"
#import "NSDate+Helper.h"

#define NOTIFICATION_INFOVIEW_CLOSE  @"NOTIFICATION_INFOVIEW_CLOSE"

@interface InfoCollectViewController : HideTabViewController

@property (weak, nonatomic) IBOutlet UIView *viewContain;
@property (weak, nonatomic) IBOutlet UILabel *lb_currentLocation;
@property (weak, nonatomic) IBOutlet UILabel *lb_manualAdjust;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photobg;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photo;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photobgdown;
@property (weak, nonatomic) IBOutlet UILabel *lb_photo;
@property (weak, nonatomic) IBOutlet UILabel *lb_ps;
@property (weak, nonatomic) IBOutlet UITextField *tf_Mark;
@property (weak, nonatomic) IBOutlet UIButton *btn_update;
@property (weak, nonatomic) BNCustomerInfo *customerInfo;

@property (assign, nonatomic) BOOL bEnterNextview;

- (IBAction)takePhotoAction:(id)sender;

@end
