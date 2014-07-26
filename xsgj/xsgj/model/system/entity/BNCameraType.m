//
//  BNCameraType.m
//  xsgj
//
//  Created by mac on 14-7-22.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "BNCameraType.h"

@implementation BNCameraType


//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNCameraType",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
