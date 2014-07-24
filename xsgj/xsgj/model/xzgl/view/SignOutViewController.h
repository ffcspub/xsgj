//
//  SignOutViewController.h
//  xsgj
//
//  Created by Geory on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"

@interface SignOutViewController : HideTabViewController

@property (weak, nonatomic) IBOutlet UIView *viewContain;
@property (weak, nonatomic) IBOutlet UILabel *lb_currentLocation;
@property (weak, nonatomic) IBOutlet UILabel *lb_manualAdjust;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photobg;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photo;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photobgdown;
@property (weak, nonatomic) IBOutlet UILabel *lb_photo;
@property (weak, nonatomic) IBOutlet UILabel *lb_ps;

@property (weak, nonatomic) IBOutlet UIButton *btn_update;


- (IBAction)takePhotoAction:(id)sender;

@end
