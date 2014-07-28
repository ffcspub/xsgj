//
//  DeptInfoBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DeptInfoBean.h"
#import "NSObject+LKDBHelper.h"

@implementation DeptInfoBean

+(void)getOwnerAndChildAreaIds:(int)deptId result:(NSMutableString *)result
{
    [result appendFormat:@"'%d',",deptId];
    NSArray *array = [DeptInfoBean searchWithWhere:[NSString stringWithFormat:@"DEPT_PID = %d",deptId] orderBy:nil offset:0 count:20];
    for (DeptInfoBean *bean in array)
    {
        [self getOwnerAndChildAreaIds:bean.DEPT_ID result:result];
    }
}

+(NSString *)getOwnerAndChildDeptIds:(int)deptId
{
    NSMutableString *deptIds = [NSMutableString string];
    [DeptInfoBean getOwnerAndChildAreaIds:deptId result:deptIds];
    return [deptIds substringToIndex:deptIds.length - 1];
}
@end
