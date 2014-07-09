//
//  XZGLAPI.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZGLHttpRequest.h"
#import "XZGLHttpResponse.h"


@interface XZGLAPI : NSObject

/**
 *  签到/签退
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)signupByRequest:(SignUpHttpRequest *)request success:(void(^)(SignUpHttpReponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  签到/签退查询
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryAttendanceByRequest:(QueryAttendanceHttpRequest *)request success:(void(^)(QueryAttendanceHttpReponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;






@end
