//
//  KcReportViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "RATreeView.h"
#import "TreeViewCell.h"
#import "BNProductType.h"
#import "BNProduct.h"
#import "LKDBHelper.h"
#import "KcProductCell.h"

@interface KcReportViewController : HideTabViewController<UITextFieldDelegate,KcProductCellDelegate>
{
    NSArray *_aryProductData;
    NSArray *_aryProductTypeData;
    NSMutableArray *_aryProductSelect;
    BNProductType *_proTypeShow;
    NSMutableArray *_aryFilter;
    BOOL _bSearch;
}

@property (weak, nonatomic) IBOutlet UITableView *tvProduct;
@property (weak, nonatomic) IBOutlet UITextField *tfType;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSeleltAll;


- (IBAction)handleBtnTypeClicked:(id)sender;
- (IBAction)handleBtnSelectAll:(id)sender;


@end
