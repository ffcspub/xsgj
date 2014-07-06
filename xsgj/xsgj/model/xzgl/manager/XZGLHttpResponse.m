//
//  XZGLHttpResponse.m
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "XZGLHttpResponse.h"
#import "SigninfoBean.h"
#import "SignDetailBean.h"
#import "TripInfoBean.h"

@implementation SignUpHttpReponse

@end

@implementation QueryAttendanceHttpReponse

+(Class)__dataClass{
    return [SigninfoBean class];
}

@end

@implementation DetailAttendanceHttpResponse

+(Class)__dataClass{
    return [SignDetailBean class];
}

@end

@implementation ApplyLeaveHttpResonse

@end

@implementation QueryLeaveHttpResponse

@end

@implementation QueryLeaveDetailHttpResponse

@end

@implementation ApplyTripHttpResponse

@end

@implementation QueryTripHttpResponse

+(Class)__dataClass{
    return [TripInfoBean class];
}

@end

@implementation QueryTripDetailHttpResponse


@end


@implementation WorkReportHttpResponse


@end