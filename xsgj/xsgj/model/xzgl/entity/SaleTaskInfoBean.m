//
//  SaleTaskInfoBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-9.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SaleTaskInfoBean.h"
#import <NSDate+Helper.h>
#import <LKDBHelper.h>

@implementation SaleTaskInfoBean

//表名
+ (NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_SaleTaskInfoBean",[ShareValue shareInstance].userInfo.USER_ID];
}

- (void)setSALE_MONTH:(NSString *)SALE_MONTH
{
    _SALE_MONTH = SALE_MONTH;
    if (_SALE_MONTH) {
        self.TIME = [[NSDate dateFromString:_SALE_MONTH withFormat:@"yyyy-MM"] timeIntervalSince1970];
    }
}

- (void)save
{
    [SaleTaskInfoBean deleteWithWhere:[NSString stringWithFormat:@"SALE_MONTH='%@'",_SALE_MONTH]];
    [self saveToDB];
}

@end
