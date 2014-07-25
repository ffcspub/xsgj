//
//  ThPreviewDetailCell.h
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderBackDetailBean.h"

@interface ThPreviewDetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbUnit;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbReson;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;



- (void)setCellValue:(OrderBackDetailBean *)commitData;
- (IBAction)handleBtnModifyClicked:(id)sender;
- (IBAction)handleBtnCancelClicked:(id)sender;

@end
