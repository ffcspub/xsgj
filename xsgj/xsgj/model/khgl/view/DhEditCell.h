//
//  DhEditCell.h
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DhEditCellDelegate;

@interface DhEditCell : UITableViewCell


@property (weak, nonatomic) id<DhEditCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *vDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfPrice;
@property (weak, nonatomic) IBOutlet UITextField *tfSubNum;
@property (weak, nonatomic) IBOutlet UITextField *tfUnit;
@property (weak, nonatomic) IBOutlet UITextField *tfZpName;
@property (weak, nonatomic) IBOutlet UITextField *tfZpPrice;
@property (weak, nonatomic) IBOutlet UITextField *tfZpNum;
@property (weak, nonatomic) NSIndexPath *indexPath;

- (IBAction)handleDelete:(id)sender;

@end


@protocol DhEditCellDelegate <NSObject>

- (void)onBtnDelClicked:(DhEditCell *)cell;

@end