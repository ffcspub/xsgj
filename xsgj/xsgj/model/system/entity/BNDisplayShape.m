//
//  BNDisplayShape.m
//  fxtx
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNDisplayShape.h"

@implementation BNDisplayShape

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNDisplayShape",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
