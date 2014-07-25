//
//  ApproveListViewController.h
//  xsgj
//
//  Created by ilikeido on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"

@interface ApproveListViewController : HideTabViewController

@property (weak, nonatomic) IBOutlet UIView *viewContain;

@property (weak, nonatomic) IBOutlet UILabel *lb_levelCount;

@property (weak, nonatomic) IBOutlet UILabel *lb_businessCount;

@end
