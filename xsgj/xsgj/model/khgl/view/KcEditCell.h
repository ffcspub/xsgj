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
#import <NSDate+Helper.h>
#import "LK_EasySignal.h"

@protocol KcEditCellDelegate;

@interface KcEditCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) id<KcEditCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *vDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbUnit;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
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
- (IBAction)handleBtnDate:(id)sender;

@end


@protocol KcEditCellDelegate <NSObject>

- (void)onBtnAddClicked:(KcEditCell *)cell;
- (void)onBtnDelClicked:(KcEditCell *)cell;
- (void)onBtnPhotoClicked:(KcEditCell *)cell;
- (void)onBtnDateClicked:(KcEditCell *)cell;

@end

