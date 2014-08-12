//
//  KcPreviewViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "PreviweDetailCell.h"
#import "PreviewNameCell.h"
#import "DzPhotoViewController.h"

@interface KcPreviewViewController : HideTabViewController<PreviweDetailCellDelegate>
{
    NSMutableArray *_arySourceData;
    int _iSendImgCount;
}

@property (weak, nonatomic) IBOutlet UIScrollView *svMainContain;
@property (weak, nonatomic) IBOutlet UIScrollView *svSubContain;
@property (weak, nonatomic) IBOutlet UITableView *tvTypeName;
@property (weak, nonatomic) IBOutlet UITableView *tvDetail;
@property (weak, nonatomic) NSArray *aryData;
@property (weak, nonatomic) BNCustomerInfo *customerInfo;
@property (weak, nonatomic) BNVistRecord *vistRecord;
@property (strong, nonatomic) NSString *strMenuId;

@end
