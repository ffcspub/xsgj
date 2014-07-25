//
//  BNMessage.m
//  结果信息
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNMessage.h"

@implementation BNMessage

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNMessage",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
