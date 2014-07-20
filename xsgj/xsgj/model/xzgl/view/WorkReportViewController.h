//
//  WorkReportViewController.h
//  xsgj
//
//  Created by Geory on 14-7-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"
#import "LeveyPopListView.h"

@interface WorkReportViewController : HideTabViewController<LeveyPopListViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_inputType;
@property (weak, nonatomic) IBOutlet UIImageView *iv_contentbg;
@property (weak, nonatomic) IBOutlet UIImageView *iv_inputbg;

- (IBAction)selectReportTypeAction:(id)sender;

@end
