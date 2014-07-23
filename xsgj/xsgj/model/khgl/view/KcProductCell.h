//
//  KcProductCell.h
//  xsgj
//
//  Created by chenzf on 14-7-22.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNProduct.h"

@protocol KcProductCellDelegate;

@interface KcProductCell : UITableViewCell

@property (weak, nonatomic) id<KcProductCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) BNProduct *productData;

- (IBAction)handleBtnSelect:(id)sender;

@end


@protocol KcProductCellDelegate <NSObject>

- (void)onBtnSelectClicked:(KcProductCell *)cell;

@end