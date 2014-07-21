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

@interface QueryAttendanceHttpReponse : LK_HttpBasePageResponse


@end

@interface DetailAttendanceHttpResponse : LK_HttpBasePageResponse

@end

@interface ApplyLeaveHttpResponse : LK_HttpBaseResponse

@end

@interface QueryLeaveHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *LEAVEINFOBEAN;

@end

@interface QueryLeaveDetailHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *leaveInfoBean;

@end

@interface ApprovalLeaveHttpResponse : LK_HttpBaseResponse

@end

@interface ApplyTripHttpResponse : LK_HttpBaseResponse

@end

@interface ApproveTripHttpResponse : LK_HttpBaseResponse

@end

@interface QueryTripHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *queryTripList;

@end

@interface QueryTripDetailHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *detailTripList;

@end

@interface WorkReportHttpResponse : LK_HttpBaseResponse

@end

@interface AddAdviceHttpResponse : LK_HttpBaseResponse

@end

@interface QueryAdviceHttpResponse : LK_HttpBasePageResponse

@end

@interface QueryDetailAdviceHttpResponse : LK_HttpBasePageResponse

@end

@interface QuerySaleTaskHttpResponse : LK_HttpBasePageResponse

@end

@interface LeaveTypeHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *LEAVEINFOBEAN;

@end

@interface InsertUserCameraHttpResponse : LK_HttpBaseResponse

@end



