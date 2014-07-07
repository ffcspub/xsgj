//
//  BNVisitPlan.m
//  fxtx
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNVisitPlan.h"

@implementation BNVisitPlan


//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNVisitPlan",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
