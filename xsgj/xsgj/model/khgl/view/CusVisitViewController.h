//
//  CusVisitViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-16.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusVisitCell.h"
#import "HideTabViewController.h"
#import "IBActionSheet.h"
#import "BNCustomerInfo.h"
#import "BNVistRecord.h"
#import "LeveyPopListView.h"
#import "BNVisitCondition.h"

@interface CusVisitViewController : HideTabViewController<IBActionSheetDelegate>
{
    NSArray *_aryVisitType;
}


@property (weak, nonatomic) IBOutlet UIScrollView *svContain;
@property (weak, nonatomic) IBOutlet UITableView *tvFuncBg;
@property (weak, nonatomic) IBOutlet UILabel *lbCusName;
@property (weak, nonatomic) IBOutlet UILabel *lbVisitType;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentLocation;
@property (weak, nonatomic) IBOutlet UILabel *lbAdjustLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnVisitBegin;
@property (weak, nonatomic) IBOutlet UIButton *btnVisitEnd;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property (weak, nonatomic) IBOutlet UIImageView *ivIconOver;
@property (weak, nonatomic) IBOutlet UILabel *lbVisitTime;
@property (strong, nonatomic) BNCustomerInfo *customerInfo;
@property (strong, nonatomic) BNVistRecord *vistRecord;

- (IBAction)handleBtnRefreshClicked:(id)sender;
- (IBAction)handleBtnMapClicked:(id)sender;
- (IBAction)handleBtnVisitCaseClicked:(id)sender;
- (IBAction)handleBtnVisitBeginClicked:(id)sender;
- (IBAction)handleBtnVisitEndClicked:(id)sender;

@end
