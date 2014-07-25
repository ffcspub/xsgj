//
//  KcEditCell.h
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNProduct.h"
#import "StockCommitBean.h"
#import "BNUnitBean.h"
#import "LeveyPopListView.h"
#import "LKDBHelper.h"

@protocol KcEditCellDelegate;

@interface KcEditCell : UITableViewCell

@property (weak, nonatomic) id<KcEditCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *vDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfUnit;
@property (weak, nonatomic) IBOutlet UITextField *tfDate;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnReduce;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) StockCommitBean *commitData;

- (void)setCellWithValue:(StockCommitBean *)commitBean;
- (IBAction)handleBtnAddClicked:(id)sender;
- (IBAction)handleBtnReduceClicked:(id)sender;
- (IBAction)handleBtnPhotoClicked:(id)sender;
- (IBAction)handleBtnUnitClicked:(id)sender;

@end


@protocol KcEditCellDelegate <NSObject>

- (void)onBtnAddClicked:(KcEditCell *)cell;
- (void)onBtnDelClicked:(KcEditCell *)cell;
- (void)onBtnPhotoClicked:(KcEditCell *)cell;

@end