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
#import "BNCustomerInfo.h"
#import "BNVistRecord.h"
#import "ProductDelView.h"

@interface KcReportViewController : HideTabViewController<UITextFieldDelegate,KcProductCellDelegate,ProductDelViewDelegate>
{
    BNProductType *_proTypeShow;
    NSArray *_aryProductData;
    NSArray *_aryProductTypeData;
    NSArray *_aryProTypeTreeData;
    NSMutableArray *_aryProductSelect;
    NSMutableArray *_aryProDataTemp;
    NSMutableArray *_aryFilter;
    NSMutableArray *_aryTraversalRet;
    BOOL _bSearch;
}

@property (weak, nonatomic) IBOutlet UIScrollView *svSelect;
@property (weak, nonatomic) IBOutlet UITableView *tvProduct;
@property (weak, nonatomic) IBOutlet UITextField *tfType;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSeleltAll;
@property (weak, nonatomic) BNCustomerInfo *customerInfo;
@property (weak, nonatomic) BNVistRecord *vistRecord;
@property (strong, nonatomic) NSString *strMenuId;

- (IBAction)handleBtnTypeClicked:(id)sender;
- (IBAction)handleBtnSelectAll:(id)sender;


@end
