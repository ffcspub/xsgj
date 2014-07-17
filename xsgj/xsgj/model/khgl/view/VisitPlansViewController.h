//
//  VisitPlansViewController.h
//  xsgj
//
//  Created by ilikeido on 14-7-14.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"

@interface VisitPlansViewController : HideTabViewController

@property (weak, nonatomic) IBOutlet UIScrollView *sv_tab;

@property (weak, nonatomic) IBOutlet UIScrollView *sv_content;

@property (weak, nonatomic) IBOutlet UIButton *btn_submit;

@end
