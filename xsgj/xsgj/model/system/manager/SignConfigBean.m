//
//  SignConfigBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SignConfigBean.h"

@implementation SignConfigBean

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_SignConfigBean",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
