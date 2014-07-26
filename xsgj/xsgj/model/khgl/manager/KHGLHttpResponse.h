//
//  KHGLHttpResponse.h
//  xsgj
//
//  Created by mac on 14-7-10.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpResponse.h"


@interface AllTypeHttpResponse : LK_HttpBasePageResponse

@end

@interface AddCustomerCommitHttpResponse : LK_HttpBaseResponse

@end

@interface CustomerQueryHttpResponse : LK_HttpBasePageResponse

@end

@interface CustomerDetailHttpResponse : LK_HttpBasePageResponse

@end

@interface RecordVisitHttpResponse : LK_HttpBaseResponse

@end

@interface QueryVistitRecordHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *rows;

@end

@interface QueryPlanVisitConfigsHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *PLAN_VISIT_CONFIGS;

@end

@interface UpdateVisitPlansHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *VISIT_RECORDS;

@end


@interface ActivityCommitHttpResponse : LK_HttpBaseResponse

@end

@interface InsertCompeteHttpResponse : LK_HttpBaseResponse

@end

@interface OrderCommitHttpResponse : LK_HttpBaseResponse

@end

@interface OrderQueryHttpResponse : LK_HttpBasePageResponse

@end

@interface OrderDetailHttpResponse : LK_HttpBasePageResponse

@end

@interface InsertOrderBackHttpResponse : LK_HttpBaseResponse

@end

@interface QueryOrderBackHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *QUERYORDERBACKINFOBEAN;

@end

@interface QueryOrderBackDetailHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *QUERYORDERBACKINFOBEAN;

@end

@interface StockCommitHttpResponse : LK_HttpBaseResponse

@end

@interface StoreCameraCommitHttpResponse : LK_HttpBaseResponse

@end

@interface DisplayCameraCommitHttpResponse : LK_HttpBaseResponse

@end

@interface InsertDisplayVividHttpResponse : LK_HttpBaseResponse

@end

@interface InsertDisplayCostHttpResponse : LK_HttpBaseResponse

@end

