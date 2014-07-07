//
//  BNCustomerInfo.m
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNCustomerInfo.h"

@implementation BNCustomerInfo

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNCustomerInfo",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
