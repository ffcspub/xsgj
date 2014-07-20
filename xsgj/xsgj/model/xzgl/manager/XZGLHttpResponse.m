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
#import "AdviceInfoBean.h"
#import "AdviceDetailBean.h"
#import "SaleTaskInfoBean.h"
#import "LeaveinfoBean.h"

@implementation SignUpHttpReponse

@end

@implementation QueryAttendanceHttpReponse

+(Class)__DATAClass{
    return [SigninfoBean class];
}

@end

@implementation DetailAttendanceHttpResponse

+(Class)__DATAClass{
    return [SignDetailBean class];
}

@end

@implementation ApplyLeaveHttpResponse

@end

@implementation ApprovalLeaveHttpResponse

@end

@implementation QueryLeaveHttpResponse

@end

@implementation QueryLeaveDetailHttpResponse

@end

@implementation ApplyTripHttpResponse

@end

@implementation ApproveTripHttpResponse


@end

@implementation QueryTripHttpResponse

+(Class)__DATAClass{
    return [TripInfoBean class];
}

@end

@implementation QueryTripDetailHttpResponse


@end

@implementation WorkReportHttpResponse

@end

@implementation AddAdviceHttpResponse

@end

@implementation QueryAdviceHttpResponse

+(Class)__DATAClass{
    return [AdviceInfoBean class];
}

@end

@implementation QueryDetailAdviceHttpResponse

+(Class)__DATAClass{
    return [AdviceDetailBean class];
}

@end

@implementation QuerySaleTaskHttpResponse

+(Class)__DATAClass{
    return [SaleTaskInfoBean class];
}


@end

@implementation LeaveTypeHttpResponse

+(Class)__LeaveInfoBeanCLASS{
    return [LeaveinfoBean class];
}

@end

@implementation InsertUserCameraHttpResponse

@end