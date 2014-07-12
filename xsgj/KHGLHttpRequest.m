//
//  KHGLHttpRequest.m
//  xsgj
//
//  Created by mac on 14-7-10.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KHGLHttpRequest.h"
#import "OrderItemBean.h"
#import "OrderBackDetailBean.h"
#import "StockCommitBean.h"

@implementation AllTypeHttpRequest

@end

@implementation AddCustomerCommitHttpRequest

@end

@implementation CustomerQueryHttpRequest


@end


@implementation CustomerDetailHttpRequest

@end

@implementation RecordVisitHttpRequest


@end

@implementation QueryVistitRecordHttpRequest


@end

@implementation QueryPlanVisitConfigsHttpRequest


@end

@implementation UpdateVisitPlansHttpRequest

@end


@implementation ActivityCommitHttpRequest

@end

@implementation OrderCommitHttpRequest

+(Class)__DATAClass{
    return [OrderItemBean class];
}

@end

@implementation OrderQueryHttpRequest

@end

@implementation OrderDetailHttpRequest

+(Class)__DATAClass{
    return [OrderBackDetailBean class];
}

@end

@implementation InsertOrderBackHttpRequest

@end

@implementation QueryOrderBackHttpRequest

@end

@implementation QueryOrderBackDetailHttpRequest


@end

@implementation StockCommitHttpRequest

+(Class)__DATAClass{
    return [StockCommitBean class];
}

@end

@implementation DisplayCameraCommitHttpRequest

@end

@implementation InsertDisplayVividHttpRequest

@end

@implementation InsertDisplayCostHttpRequest

@end

@implementation UploadPhotoHttpRequest

@end


