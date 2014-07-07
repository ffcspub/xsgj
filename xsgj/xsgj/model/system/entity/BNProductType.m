//
//  BNProductType.m
//  产品类别
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNProductType.h"

@implementation BNProductType

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNProductType",[ShareValue shareInstance].userInfo.USER_ID];
}


@end
