//
//  KHGLHttpResponse.m
//  xsgj
//
//  Created by mac on 14-7-10.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KHGLHttpResponse.h"
#import "CustTypeBean.h"
#import "CustInfoBean.h"
#import "CustDetailBean.h"
#import "VisistRecordVO.h"
#import "PlanVisitConfig.h"

@implementation AllTypeHttpResponse

+(Class)__DATACLASS{
    return [CustTypeBean class];
}

@end

@implementation AddCustomerCommitHttpResponse


@end

@implementation CustomerQueryHttpResponse

+(Class)__DATACLASS{
    return [CustInfoBean class];
}

@end

@implementation CustomerDetailHttpResponse

+(Class)__DATACLASS{
    return [CustDetailBean class];
}

@end

@implementation RecordVisitHttpResponse

@end

@implementation QueryVistitRecordHttpResponse

+(Class)__VISIT_RECORDSClass{
    return [VisistRecordVO class];
}

@end

@implementation QueryPlanVisitConfigsHttpResponse

+(Class)__PLAN_VISIT_CONFIGSClass{
    return [PlanVisitConfig class];
}

@end


@implementation UpdateVisitPlansHttpResponse

+(Class)__VISIT_RECORDSClass{
    return [VisistRecordVO class];
}

@end