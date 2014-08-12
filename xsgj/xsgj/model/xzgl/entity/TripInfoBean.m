//
//  TripInfoBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TripInfoBean.h"
#import <NSDate+Helper.h>
#import <LKDBHelper.h>

@implementation TripInfoBean

//表名
+ (NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_TripInfoBean",[ShareValue shareInstance].userInfo.USER_ID];
}

- (void)setAPPLY_TIME:(NSString *)APPLY_TIME
{
    _APPLY_TIME = APPLY_TIME;
    if (_APPLY_TIME) {
        self.APPLYTIME = [[NSDate dateFromString:_APPLY_TIME withFormat:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
    }
}

- (void)save
{
    [TripInfoBean deleteWithWhere:[NSString stringWithFormat:@"APPLY_TIME='%@'",_APPLY_TIME]];
    [self saveToDB];
}

@end
