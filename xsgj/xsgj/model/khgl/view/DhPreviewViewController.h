//
//  DhPreviewViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "PreviewNameCell.h"
#import "DhPreviweDetailCell.h"
#import "DzPhotoViewController.h"
#import "BNPartnerInfoBean.h"

@interface DhPreviewViewController : HideTabViewController<DhPreviweDetailCellDelegate>
{
    NSMutableArray *_arySourceData;
}

@property (weak, nonatomic) IBOutlet UIScrollView *svMainContain;
@property (weak, nonatomic) IBOutlet UIScrollView *svSubContain;
@property (weak, nonatomic) IBOutlet UITableView *tvTypeName;
@property (weak, nonatomic) IBOutlet UITableView *tvDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbCooperation;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) NSArray *aryData;
@property (weak, nonatomic) BNCustomerInfo *customerInfo;
@property (weak, nonatomic) BNVistRecord *vistRecord;
@property (weak, nonatomic) BNPartnerInfoBean *partnerInfo;
@property (strong, nonatomic) NSString *strMenuId;

@end

