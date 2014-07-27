//
//  PreviewNameCell.h
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KcEditCell.h"

@interface PreviewNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbName;

- (void)setCellValue:(KcCommitData *)commitData;

@end
