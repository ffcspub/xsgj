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
#import "OrderDetailBean.h"
#import "QueryOrderBackInfoBean.h"
#import "QueryOrderBackDetailInfoBean.h"

@implementation AllTypeHttpResponse

+(Class)__DATAClass{
    return [CustTypeBean class];
}

@end

@implementation AddCustomerCommitHttpResponse


@end

@implementation CustomerQueryHttpResponse

+(Class)__DATAClass{
    return [CustInfoBean class];
}

@end

@implementation CustomerDetailHttpResponse

+(Class)__DATAClass{
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

@implementation ActivityCommitHttpResponse

@end

@implementation InsertCompeteHttpResponse


@end

@implementation OrderCommitHttpResponse


@end

@implementation OrderQueryHttpResponse

+(Class)__DATAClass{
    return [VisistRecordVO class];
}

@end

@implementation OrderDetailHttpResponse

+(Class)__DATAClass{
    return [OrderDetailBean class];
}

@end

@implementation InsertOrderBackHttpResponse


@end

@implementation QueryOrderBackHttpResponse

+(Class)__DATAClass{
    return [QueryOrderBackInfoBean class];
}

@end

@implementation QueryOrderBackDetailHttpResponse

+(Class)__DATAClass{
    return [QueryOrderBackDetailInfoBean class];
}

@end

@implementation StockCommitHttpResponse


@end

@implementation StoreCameraCommitHttpResponse

@end

@implementation DisplayCameraCommitHttpResponse

@end

@implementation InsertDisplayVividHttpResponse

@end

@implementation InsertDisplayCostHttpResponse

@end

@implementation UploadPhotoHttpResponse

@end




