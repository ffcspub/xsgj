//
//  BNDisplayType.m
//  fxtx
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNDisplayType.h"

@implementation BNDisplayType

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNDisplayType",[ShareValue shareInstance].userInfo.USER_ID];
}


@end
