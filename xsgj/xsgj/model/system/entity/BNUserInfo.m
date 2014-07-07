//
//  BNUserInfo.m
//  用户信息
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNUserInfo.h"

@implementation BNUserInfo
- (NSString *)description
{
    return [NSString stringWithFormat:
            @"\n\
            ----------UserInfoBean-------\n\
            CORP_CODE   = %@\n\
            CORP_ID     = %d\n\
            CORP_NAME   = %@\n\
            DEPT_ID     = %d\n\
            DEPT_NAME   = %@\n\
            LAST_UPDATE_TIME = %llu\n\
            LEADER_ID   = %d\n\
            LEADER_NAME = %@\n\
            MOBILENO    = %@\n\
            REALNAME    = %@\n\
            ROLE_ID     = %d\n\
            ROLE_NAME   = %@\n\
            SESSION_ID  = %@\n\
            USER_AUTH   = %@\n\
            USER_ID     = %d\n\
            USER_NAME   = %@\n\
            ----------------------------\
            ",
            _CORP_CODE,_CORP_ID,_CORP_NAME,_DEPT_ID,_DEPT_NAME,_LAST_UPDATE_TIME,_LEADER_ID,_LEADER_NAME,_MOBILENO,_REALNAME,_ROLE_ID,_ROLE_NAME,_SESSION_ID,_USER_AUTH,_USER_ID,_USER_NAME
            ];
}
@end
