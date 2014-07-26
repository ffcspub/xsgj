//
//  BNAreaInfo.m
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNAreaInfo.h"
#import <LKDBHelper.h>

@implementation BNAreaInfo

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNAreaInfo",[ShareValue shareInstance].userInfo.USER_ID];
}



#pragma mark - function
+(void)getOwnerAndChildAreaIds:(int)areaId result:(NSMutableString *)result{
    [result appendFormat:@"%d,",areaId];
    NSArray *array = [BNAreaInfo searchWithWhere:[NSString stringWithFormat:@"AREA_PID=%d",areaId] orderBy:nil offset:0 count:20];
    for (BNAreaInfo *area in array) {
        [self getOwnerAndChildAreaIds:area.AREA_ID result:result];
    }
}

+(NSString *)getOwnerAndChildAreaIds:(int)areaId{
    NSMutableString *areaids = [NSMutableString string];
    [BNAreaInfo getOwnerAndChildAreaIds:areaId result:areaids];
    return [areaids substringToIndex:areaids.length - 1];
}


@end
