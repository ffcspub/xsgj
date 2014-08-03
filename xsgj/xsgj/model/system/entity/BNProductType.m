//
//  BNProductType.m
//  产品类别
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNProductType.h"
#import <LKDBHelper.h>

@implementation BNProductType

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNProductType",[ShareValue shareInstance].userInfo.USER_ID];
}

+(void)getOwnerAndChildTypeIds:(int)typeid result:(NSMutableString *)result{
    [result appendFormat:@"%d,",typeid];
    NSArray *array = [BNProductType searchWithWhere:[NSString stringWithFormat:@"CLASS_PID=%d",typeid] orderBy:nil offset:0 count:20];
    for (BNProductType *type in array) {
        [self getOwnerAndChildTypeIds:type.CLASS_ID result:result];
    }
}

+(NSString *)getOwnerAndChildTypeIds:(int)typeid{
    NSMutableString *typeids = [NSMutableString string];
    [BNProductType getOwnerAndChildTypeIds:typeid result:typeids];
    return [typeids substringToIndex:typeids.length - 1];
}

@end
