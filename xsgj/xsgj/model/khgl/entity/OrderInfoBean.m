//
//  OrderInfoBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "OrderInfoBean.h"
#import <LKDBHelper.h>
#import <NSDate+Helper.h>

@implementation OrderInfoBean

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_OrderInfoBean",[ShareValue shareInstance].userInfo.USER_ID];
}

- (void)setCOMMITTIME:(NSString *)COMMITTIME
{
    _COMMITTIME = COMMITTIME;
    if (_COMMITTIME) {
        self.TIME = [[NSDate dateFromString:_COMMITTIME withFormat:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
    }
}

-(void)save
{
    [OrderInfoBean deleteWithWhere:[NSString stringWithFormat:@"ORDER_ID=%d",_ORDER_ID]];
    [self saveToDB];
}

@end
