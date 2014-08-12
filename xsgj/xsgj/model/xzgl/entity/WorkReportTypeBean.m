//
//  WorkReportTypeBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-21.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "WorkReportTypeBean.h"
#import <LKDBHelper.h>

@implementation WorkReportTypeBean

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_WorkReportTypeBean",[ShareValue shareInstance].userInfo.USER_ID];
}



-(void)save{
    [WorkReportTypeBean deleteWithWhere:[NSString stringWithFormat:@"TYPE_ID=%d",_TYPE_ID]];
    [self saveToDB];
}

@end
