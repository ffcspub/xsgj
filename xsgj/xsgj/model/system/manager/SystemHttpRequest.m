//
//  UserHttpRequest.m
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SystemHttpRequest.h"
#import <OpenUDID.h>
#import <NSDate+Helper.h>

@implementation UserLoginHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _LOGINTYPE = @"2";
        _DEVICE_CODE = [OpenUDID value];
    }
    return self;
}

@end

@implementation UpdateConfigHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _UPDATE_TYPE = 3;
    }
    return self;
}

@end

@implementation LocateCommitHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
        _LOC_WAY = 4;
        _COMMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}


@end
