//
//  XZGLHttpRequest.m
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "XZGLHttpRequest.h"
#import <NSDate+Helper.h>
#import <OpenUDID.h>

@implementation SignUpHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
        _SIGN_FLAG = @"i";
        _DEVICE_CODE = [OpenUDID value];
        _SIGN_TIME = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}

@end

@implementation QueryAttendanceHttpRequest

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

@implementation DetailAttendanceHttpRequest

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

@implementation ApplyLeaveHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation QueryLeaveHttpRequest

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

@implementation QueryLeaveDetailHttpRequest

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

@implementation ApprovalLeaveHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _APPROVE_USER = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}
@end

@implementation ApplyTripHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation ApproveTripHttpRequst

-(id)init{
    self = [super init];
    if (self) {
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
        
    }
    return self;
}

@end

@implementation QueryTripHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation QueryTripDetailHttpRequest


@end

@implementation WorkReportHttpRequest

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

@implementation AddAdviceHttpRequest

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

@implementation QueryAdviceHttpRequest

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

