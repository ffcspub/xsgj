//
//  CusDetailViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNCustomerInfo.h"
#import "MBProgressHUD+Add.h"
#import "BNVistRecord.h"
#import "HideTabViewController.h"

@interface CusDetailViewController : HideTabViewController


@property (weak, nonatomic) IBOutlet UIScrollView *svContain;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbType;
@property (weak, nonatomic) IBOutlet UILabel *lbLinkMan;
@property (weak, nonatomic) IBOutlet UILabel *lbMobile;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbVisitTime;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (weak, nonatomic) BNCustomerInfo *customerInfo;
@property (weak, nonatomic) BNVistRecord *visitRecord;
@property (weak, nonatomic) NSString *strDateSelect;

- (IBAction)handleSms:(id)sender;
- (IBAction)handleTel:(id)sender;

@end
