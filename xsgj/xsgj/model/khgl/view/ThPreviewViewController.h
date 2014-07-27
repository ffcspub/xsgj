//
//  ThPreviewViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThPreviewDetailCell.h"
#import "HideTabViewController.h"
#import "DzPhotoViewController.h"
#import "PreviewNameCell.h"
#import "PreviweDetailCell.h"

@interface ThPreviewViewController : HideTabViewController<ThPreviewDetailCellDelegate>
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

@end
