//
//  BNCustomerType.m
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNCustomerType.h"

@implementation BNCustomerType

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNCustomerType",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
