//
//  WorkReportViewController.h
//  xsgj
//
//  Created by Geory on 14-7-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"
#import "LeveyPopListView.h"

@interface WorkReportViewController : HideTabViewController<LeveyPopListViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btn_inputType;
@property (weak, nonatomic) IBOutlet UIImageView *iv_contentbg;
@property (weak, nonatomic) IBOutlet UIImageView *iv_inputbg;
@property (weak, nonatomic) IBOutlet UITextView *tv_content;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photobg;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photo;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photobgdown;
@property (weak, nonatomic) IBOutlet UILabel *lb_photo;

- (IBAction)selectReportTypeAction:(id)sender;
- (IBAction)takePhotoAction:(id)sender;

@end
