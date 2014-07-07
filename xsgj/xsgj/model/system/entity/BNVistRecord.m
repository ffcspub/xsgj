//
//  BNVistRecord.m
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNVistRecord.h"

@implementation BNVistRecord

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNVistRecord",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
