//
//  ClCostViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-18.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "IBActionSheet.h"
#import "BNDisplayShape.h"
#import "LKDBHelper.h"


@interface ClCostViewController : HideTabViewController<IBActionSheetDelegate>
{
    IBActionSheet *_actionSheet;
    BOOL _bSetEndTime;
    NSDate *_beginTime;
    NSDate *_endTime;
    NSArray *_aryClShapreData;
    
}

@property (weak, nonatomic) IBOutlet UIView *vDatePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *tfTimeBegin;
@property (weak, nonatomic) IBOutlet UITextField *tfTimeEnd;
@property (weak, nonatomic) IBOutlet UITextField *tfClType;
@property (weak, nonatomic) IBOutlet UITextField *tfClCost;
@property (weak, nonatomic) IBOutlet UIButton *btnPickerCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnPickerConfirm;


- (IBAction)handleBtnPickerConfirm:(id)sender;

- (IBAction)handleBtnPickerCancel:(id)sender;

- (IBAction)handleBtnTimeBeginClicked:(id)sender;
- (IBAction)handleBtnTimeEndClicked:(id)sender;
- (IBAction)handleBtnClTypeClicked:(id)sender;

@end
