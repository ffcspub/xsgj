//
//  ThPreviewDetailCell.h
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThEditCell.h"

@protocol ThPreviewDetailCellDelegate;

@interface ThPreviewDetailCell : UITableViewCell

@property (weak, nonatomic) id<ThPreviewDetailCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *lbSpec;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbUnit;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbReson;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (strong, nonatomic) ThCommitData *cellCommitBean;


- (void)setCellValue:(ThCommitData *)commitData;
- (IBAction)handleBtnModifyClicked:(id)sender;
- (IBAction)handleBtnCancelClicked:(id)sender;

@end

@protocol ThPreviewDetailCellDelegate <NSObject>

- (void)onBtnModifyClicked:(ThPreviewDetailCell *)cell;
- (void)onBtnCancelClicked:(ThPreviewDetailCell *)cell;

@end