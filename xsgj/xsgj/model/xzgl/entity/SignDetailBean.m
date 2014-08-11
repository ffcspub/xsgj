//
//  SignDetailBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SignDetailBean.h"
#import <NSDate+Helper.h>
#import <LKDBHelper.h>

@implementation SignDetailBean


//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_SignDetailBean",[ShareValue shareInstance].userInfo.USER_ID];
}


-(void)setSIGN_TIME:(NSString *)SIGN_TIME{
    _SIGN_TIME = SIGN_TIME;
    if (_SIGN_TIME) {
        self.SIGNTIME = [[NSDate dateFromString:_SIGN_TIME withFormat:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
    }
}


-(void)save{
    [SignDetailBean deleteWithWhere:[NSString stringWithFormat:@"SIGN_TIME='%@'",_SIGN_TIME]];
    [self saveToDB];
}

@end
