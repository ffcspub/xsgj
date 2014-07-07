//
//  BNUnitBean.m
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNUnitBean.h"

@implementation BNUnitBean

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNUnitBean",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
