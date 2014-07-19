//
//  XTGLHttpResponse.m
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "XTGLHttpResponse.h"
#import "DeptInfoBean.h"
#import "ContactBean.h"
#import "NoticeInfoBean.h"
#import "NoticeDetailBean.h"
#import "NoticeTypeBean.h"

@implementation GetUserAllDeptHttpResponse

+(Class)__DATAClass{
    return [DeptInfoBean class];
}

@end

@implementation QueryContactsHttpResponse

+(Class)__DATAClass{
    return [ContactBean class];
}

@end

@implementation QueryNoticeHttpResponse

+(Class)__DATAClass{
    return [NoticeInfoBean class];
}

@end

@implementation NoticeDetailHttpResponse

+(Class)__DATAClass{
    return [NoticeDetailBean class];
}

@end

@implementation NoticeTypesHttpResponse

+(Class)__DATAClass{
    return [NoticeTypeBean class];
}

@end

@implementation UpdatePwdHttpResponse

@end

@implementation ForgetPwdHttpResponse


@end

@implementation AddApplyCorpHttpResponse


@end

