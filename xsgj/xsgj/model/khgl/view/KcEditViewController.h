//
//  KcEditViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "KcEditCell.h"
#import "DzPhotoViewController.h"

@interface KcEditViewController : HideTabViewController<KcEditCellDelegate>
{
    NSIndexPath *_selectIndex;
    NSMutableArray *_aryKcData;
    KcEditCell *_cellForDate;
    KcEditCell *_cellForPhoto;
    int _iExpandProdId;
    int _iSendImgCount;
}


@property (weak, nonatomic) IBOutlet UITableView *tvContain;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property (weak, nonatomic) IBOutlet UIButton *btnPreview;
@property (weak, nonatomic) NSArray *aryData;
@property (weak, nonatomic) BNCustomerInfo *customerInfo;
@property (weak, nonatomic) BNVistRecord *vistRecord;


- (IBAction)handleBtnCommitClicked:(id)sender;
- (IBAction)handleBtnPreviewClicked:(id)sender;

@end
