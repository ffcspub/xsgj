//
//  DistributionCell.h
//  xsgj
//
//  Created by xujunwen on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistributionCell : UITableViewCell

+ (UINib *)nib;

+ (CGFloat)cellHeight;

@end

@interface DistributionCell (BindData)

- (void)configureForData:(id)data;

@end
