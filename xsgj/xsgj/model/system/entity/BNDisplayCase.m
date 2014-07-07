//
//  BNDisplayCase.m
//  fxtx
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNDisplayCase.h"

@implementation BNDisplayCase

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNDisplayCase",[ShareValue shareInstance].userInfo.USER_ID];
}


@end
