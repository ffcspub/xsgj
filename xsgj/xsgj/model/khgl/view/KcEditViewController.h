//
//  KcEditViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DzPhotoViewController.h"
#import "KcEditCell.h"

@interface KcEditViewController : DzPhotoViewController<KcEditCellDelegate>
{
    NSIndexPath *_selectIndex;
}


@property (weak, nonatomic) IBOutlet UITableView *tvContain;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property (weak, nonatomic) IBOutlet UIButton *btnPreview;
@property (weak, nonatomic) NSArray *aryData;


- (IBAction)handleBtnCommitClicked:(id)sender;
- (IBAction)handleBtnPreviewClicked:(id)sender;

@end
