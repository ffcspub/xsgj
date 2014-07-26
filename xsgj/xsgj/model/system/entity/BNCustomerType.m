//
//  BNCustomerType.m
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNCustomerType.h"
#import <LKDBHelper.h>

@implementation BNCustomerType

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNCustomerType",[ShareValue shareInstance].userInfo.USER_ID];
}


+(void)getOwnerAndChildTypeIds:(int)typeid result:(NSMutableString *)result{
    [result appendFormat:@"%d,",typeid];
    NSArray *array = [BNCustomerType searchWithWhere:[NSString stringWithFormat:@"TYPE_PID=%d",typeid] orderBy:nil offset:0 count:20];
    for (BNCustomerType *type in array) {
        [self getOwnerAndChildTypeIds:type.TYPE_ID result:result];
    }
}

+(NSString *)getOwnerAndChildTypeIds:(int)typeid{
    NSMutableString *typeids = [NSMutableString string];
    [BNCustomerType getOwnerAndChildTypeIds:typeid result:typeids];
    return [typeids substringToIndex:typeids.length - 1];
}

@end
