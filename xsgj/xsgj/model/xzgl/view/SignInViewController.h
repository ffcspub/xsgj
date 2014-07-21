//
//  SignInViewController.h
//  xsgj
//
//  Created by ilikeido on 14-7-14.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"

@interface SignInViewController : HideTabViewController

@property (weak, nonatomic) IBOutlet UIView *viewContain;
@property (weak, nonatomic) IBOutlet UILabel *lb_currentLocation;
@property (weak, nonatomic) IBOutlet UILabel *lb_manualAdjust;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photobg;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photo;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photobgdown;
@property (weak, nonatomic) IBOutlet UILabel *lb_photo;
@property (weak, nonatomic) IBOutlet UILabel *lb_ps;

@end
