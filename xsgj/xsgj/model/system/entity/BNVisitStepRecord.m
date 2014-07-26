//
//  BNVisitStepRecord.m
//  fxtx
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNVisitStepRecord.h"
#import <LKDBHelper.h>

@implementation BNVisitStepRecord


//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNVisitStepRecord",[ShareValue shareInstance].userInfo.USER_ID];
}

-(void)save{
    int count = [BNVisitStepRecord rowCountWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='%d'",_VISIT_NO,_OPER_MENU]];
    if (count > 0) {
        [[LKDBHelper getUsingLKDBHelper]updateToDB:self where:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='%d'",_VISIT_NO,_OPER_MENU]];
    }else{
        [self saveToDB];
    }
}

@end
