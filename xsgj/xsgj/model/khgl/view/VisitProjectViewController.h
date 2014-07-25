//
//  VisitProjectViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"

@interface VisitProjectViewController : HideTabViewController


@property (weak, nonatomic) IBOutlet UILabel *lbWeekday;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;


- (IBAction)handleBtnWeek:(id)sender;

@end
