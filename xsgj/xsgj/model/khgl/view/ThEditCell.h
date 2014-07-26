//
//  ThEditCell.h
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KcEditCell.h"
#import "OrderBackDetailBean.h"

@interface ThEditCell : KcEditCell

@property (weak, nonatomic) IBOutlet UITextField *tfReson;
@property (strong, nonatomic) OrderBackDetailBean *thCommitData;

- (void)setCellWithValue:(OrderBackDetailBean *)commitBean;

@end
