//
//  DhEditViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "DhEditCell.h"

@interface DhEditViewController : HideTabViewController<DhEditCellDelegate>
{
    NSIndexPath *_selectIndex;
}


@property (weak, nonatomic) IBOutlet UIButton *btnType;
@property (weak, nonatomic) IBOutlet UIButton *btnName;
@property (weak, nonatomic) IBOutlet UITextField *tfType;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITableView *tvContain;
@property (weak, nonatomic) IBOutlet UIButton *btnPreview;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property (weak, nonatomic) NSArray *aryData;


- (IBAction)handleBtnTypeClicked:(id)sender;
- (IBAction)handleBtnNameClicked:(id)sender;
- (IBAction)handleCommit:(id)sender;
- (IBAction)handlePreview:(id)sender;


@end
