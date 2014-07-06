//
//  XZGLHttpResponse.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_API.h"
#import "SigninfoBean.h"
#import "TripInfoBean.h"
#import "TripDetailBean.h"

@interface SignUpHttpReponse : LK_HttpBaseResponse

@end

@interface QueryAttendanceHttpReponse : LK_HttpBaseResponse

@end

@interface DetailAttendanceHttpResponse : LK_HttpBasePageResponse

@end

@interface ApplyLeaveHttpResonse : LK_HttpBaseResponse

@end

@interface QueryLeaveHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *leaveInfoBean;

@end

@interface QueryLeaveDetailHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *leaveInfoBean;

@end

@interface ApprovalLeaveHttpResponse : LK_HttpBaseResponse

@end

@interface ApplyTripHttpResponse : LK_HttpBaseResponse

@end

@interface QueryTripHttpResponse : LK_HttpBasePageResponse

@end

@interface QueryTripDetailHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) TripDetailBean *data;

@end

@interface WorkReportHttpResponse : LK_HttpBaseResponse

@end

