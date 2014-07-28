//
//  MyCusCell.h
//  xsgj
//
//  Created by chenzf on 14-7-28.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustDetailBean.h"

@interface MyCusCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbVisitTime;
@property (weak, nonatomic) IBOutlet UILabel *lbType;


- (void)setCellWithValue:(CustDetailBean *)customerInfo;

@end
