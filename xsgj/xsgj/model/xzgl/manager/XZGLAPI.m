//
//  XZGLAPI.m
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "XZGLAPI.h"
#import "XZGLHttpRequest.h"
#import "XZGLHttpResponse.h"
#import "ServerConfig.h"

@implementation XZGLAPI

/**
 *  签到/签退
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)signupByRequest:(SignUpHttpRequest *)request success:(void(^)(SignUpHttpReponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;{
    
    [LK_APIUtil getHttpRequest:request apiPath:URL_signUp Success:^(LK_HttpBaseResponse *response) {
        if ([DEFINE_SUCCESSCODE isEqual:response.MESSAGE.MESSAGECODE]) {
            
        }else{
            
        }
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[SignUpHttpReponse class]];
    
    
}

@end
