//
//  VisistRecordVO.m
//  xsgj
//
//  Created by ilikeido on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "VisistRecordVO.h"
#import <LKDBHelper.h>
#import <NSDate+Helper.h>

@implementation VisistRecordVO

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_VisistRecordVO",[ShareValue shareInstance].userInfo.USER_ID];
}

- (void)setSTART_DATE:(NSString *)START_DATE
{
    _START_DATE = START_DATE;
    if (_START_DATE) {
        self.TIME = [[NSDate dateFromString:_START_DATE withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
    }
}

-(void)save
{
    [VisistRecordVO deleteWithWhere:[NSString stringWithFormat:@"VISIT_ID=%d",_VISIT_ID]];
    [self saveToDB];
}

@end
