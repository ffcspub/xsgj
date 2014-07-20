//
//  LeaveApplicationViewController.h
//  xsgj
//
//  Created by Geory on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"
#import "LeveyPopListView.h"

@interface LeaveApplicationViewController : HideTabViewController<LeveyPopListViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
