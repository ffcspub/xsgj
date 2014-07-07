//
//  UserHttpRequest.m
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SystemHttpRequest.h"
#import <OpenUDID.h>

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
