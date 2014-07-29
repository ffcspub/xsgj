//
//  HdReportViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPhotoViewController.h"

@interface HdReportViewController : CLPhotoViewController<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *tfHdName;
@property (weak, nonatomic) IBOutlet UITextView *txHdDescription;
@property (weak, nonatomic) IBOutlet UILabel *lbPlaceholder;


@end
