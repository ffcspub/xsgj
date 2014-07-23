//
//  VisitRecordCell.h
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitRecordCell : UITableViewCell

+ (UINib *)nib;

+ (CGFloat)cellHeight;

@end

@interface VisitRecordCell (BindData)

- (void)configureForData:(id)data;

@end