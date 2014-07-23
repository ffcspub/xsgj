//
//  BNProduct.m
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNProduct.h"
#import "BNUnitBean.h"

@implementation BNProduct

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNProduct",[ShareValue shareInstance].userInfo.USER_ID];
}


@end
