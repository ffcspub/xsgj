//
//  LeaveinfoBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "LeaveinfoBean.h"
#import <NSDate+Helper.h>
#import <LKDBHelper.h>

@implementation LeaveinfoBean

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_LeaveinfoBean",[ShareValue shareInstance].userInfo.USER_ID];
}

-(void)setAPPLY_TIME:(NSString *)APPLY_TIME{
    _APPLY_TIME = APPLY_TIME;
    if (_APPLY_TIME) {
        self.APPLYTIME = [[NSDate dateFromString:_APPLY_TIME withFormat:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
    }
}

-(void)save{
    [LeaveinfoBean deleteWithWhere:[NSString stringWithFormat:@"LEAVE_ID='%@'",_LEAVE_ID]];
    [self saveToDB];
}

+(void)deleteAll{
    [[LKDBHelper getUsingLKDBHelper]deleteWithClass:[LeaveinfoBean class] where:nil];
}

@end
