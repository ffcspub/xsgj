//
//  DhEditCell.h
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItemBean.h"
#import "BNProduct.h"
#import "BNUnitBean.h"
#import "LeveyPopListView.h"
#import "LKDBHelper.h"

@protocol DhEditCellDelegate;

@interface DhEditCell : UITableViewCell<UITextFieldDelegate>


@property (weak, nonatomic) id<DhEditCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *vDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfPrice;
@property (weak, nonatomic) IBOutlet UITextField *tfSubNum;
@property (weak, nonatomic) IBOutlet UILabel *lbUnit;
@property (weak, nonatomic) IBOutlet UITextField *tfZpName;
@property (weak, nonatomic) IBOutlet UITextField *tfZpNum;
@property (weak, nonatomic) IBOutlet UITextField *tfZpUnit;

@property (weak, nonatomic) IBOutlet UITextField *tfZpPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalPrice;
@property (weak, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) OrderItemBean *commitData;

- (void)setCellWithValue:(OrderItemBean *)commitBean;
- (IBAction)handleDelete:(id)sender;
- (IBAction)handleBtnUnitClicked:(id)sender;

@end


@protocol DhEditCellDelegate <NSObject>

- (void)onBtnDelClicked:(DhEditCell *)cell;

@end