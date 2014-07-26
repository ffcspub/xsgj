//
//  BNVistRecord.m
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNVistRecord.h"
#import <OpenUDID.h>
#import <LKDBHelper.h>

@implementation BNVistRecord

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNVistRecord",[ShareValue shareInstance].userInfo.USER_ID];
}

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long int date = (long long int)time;
        _VISIT_NO = [NSString stringWithFormat:@"%@%qu",[OpenUDID value],date];
    }
    return self;
}


-(void)save{
    int row = [BNVistRecord rowCountWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@'",_VISIT_NO]];
    if (row>0) {
        [[LKDBHelper getUsingLKDBHelper]updateToDB:self where:[NSString stringWithFormat:@"VISIT_NO='%@'",_VISIT_NO]];
    }else{
        [self saveToDB];
    }
}

@end
