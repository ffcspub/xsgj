//
//  LeaveTypeBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "LeaveTypeBean.h"
#import <LKDBHelper.h>

@implementation LeaveTypeBean

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_LeaveTypeBean",[ShareValue shareInstance].userInfo.USER_ID];
}



-(void)save{
    [LeaveTypeBean deleteWithWhere:[NSString stringWithFormat:@"TYPE_ID=%d",_TYPE_ID]];
    [self saveToDB];
}

@end
