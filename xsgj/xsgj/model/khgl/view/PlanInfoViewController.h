//
//  PlanInfoViewController.h
//  xsgj
//
//  Created by ilikeido on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfo.h"
#import "HideTabViewController.h"

@interface PlanInfoViewController : HideTabViewController

@property(nonatomic,strong) CustomerInfo *customerInfo;

@end
