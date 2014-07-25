//
//  TimeIntervalBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-25.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TimeIntervalBean.h"

@implementation TimeIntervalBean

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_TimeIntervalBean",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
