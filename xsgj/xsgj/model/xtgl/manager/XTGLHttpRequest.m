//
//  XTGLHttpRequest.m
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "XTGLHttpRequest.h"

@implementation GetUserAllDeptHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation QueryContactsHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}


@end

@implementation QueryNoticeHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation NoticeDetailHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation UpdataPwdHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end
