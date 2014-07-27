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
#import <NSDate+Helper.h>
#import "LK_EasySignal.h"


@interface ThCommitData : OrderBackDetailBean

// add by chenzf 20140727
@property(nonatomic,strong) UIImage *PhotoImg;//非api数据，仅用于UI存储
@property(nonatomic,strong) NSData *PhotoData;//非api数据，仅用于UI存储

@end

@interface ThEditCell : KcEditCell

@property (weak, nonatomic) IBOutlet UITextField *tfReson;
@property (strong, nonatomic) ThCommitData *thCommitData;

- (void)setCellWithValue:(ThCommitData *)commitBean;

@end
