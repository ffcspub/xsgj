//
//  TempVisitViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "IBActionSheet.h"
#import "LeveyPopListView.h"
#import "BNCustomerType.h"
#import "BNAreaInfo.h"
#import "BNCustomerInfo.h"
#import "LKDBHelper.h"
#import "BNVistRecord.h"

typedef enum
{
    Type_CusType = 0,
    Type_CusArea,
    
}SelectTreeType;

@interface TempVisitViewController : HideTabViewController<IBActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *svContain;
@property (weak, nonatomic) IBOutlet UIButton *btnCusInfo;
@property (weak, nonatomic) IBOutlet UILabel *lbCusTypeSelect;
@property (weak, nonatomic) IBOutlet UILabel *lbCusAreaSelect;
@property (weak, nonatomic) IBOutlet UILabel *lbCusNameSelect;
@property (weak, nonatomic) IBOutlet UILabel *lbCusName;
@property (weak, nonatomic) IBOutlet UILabel *lbCusType;
@property (weak, nonatomic) IBOutlet UILabel *lbContacts;
@property (weak, nonatomic) IBOutlet UILabel *lbMobile;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbLastVisit;
@property (strong, nonatomic) BNCustomerInfo *customerInfoSelect;
@property (strong, nonatomic) BNVistRecord *visitRecordSelect;

- (IBAction)handleBtnCusTypeClicked:(id)sender;
- (IBAction)handleBtnCusAreaClicked:(id)sender;
- (IBAction)handleBtnCusTNameClicked:(id)sender;
- (IBAction)handleBtnCusInfoClicked:(id)sender;
- (IBAction)handleBtnSmsClicked:(id)sender;
- (IBAction)handleBtnPhoneClicked:(id)sender;

@end
