//
//  BNSignConfigBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "BNSignConfigBean.h"

@implementation BNSignConfigBean

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNSignConfigBean",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
