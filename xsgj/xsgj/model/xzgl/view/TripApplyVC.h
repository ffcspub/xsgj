//
//  TripApplyVC.h
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"

/**
 *  出差申请
 */
@interface TripApplyVC : HideTabViewController

@property (weak, nonatomic) IBOutlet UIScrollView *svTripApply;
@property (weak, nonatomic) IBOutlet UITextField *tfTheme;
@property (weak, nonatomic) IBOutlet UITextField *tfDayNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfStarting;
@property (weak, nonatomic) IBOutlet UITextField *tfDestination;
@property (weak, nonatomic) IBOutlet UITextView *tvDescription;

@property (weak, nonatomic) IBOutlet UIButton *btnBeginTime;
@property (weak, nonatomic) IBOutlet UIButton *btnEndTime;

@end
