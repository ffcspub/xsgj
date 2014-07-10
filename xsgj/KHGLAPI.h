//
//  KHGLAPI.h
//  xsgj
//
//  Created by mac on 14-7-10.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHGLHttpRequest.h"
#import "KHGLHttpResponse.h"

@interface KHGLAPI : NSObject

/**
 *  客户类型信息读取接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)allTypeInfoByRequest:(AllTypeHttpRequest *)request success:(void(^)(AllTypeHttpRequest *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  新客户信息上报
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)addCustomerCommitByRequest:(AddCustomerCommitHttpRequest *)request success:(void(^)(AddCustomerCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  客户信息查询
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)customerQueryByRequest:(CustomerQueryHttpRequest *)request success:(void(^)(CustomerQueryHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  客户详情信息查询
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)customerDetailByRequest:(CustomerDetailHttpRequest *)request success:(void(^)(CustomerDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  离店登记接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)recordVisitByRequest:(RecordVisitHttpRequest *)request success:(void(^)(RecordVisitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;


/**
 *  查询拜访记录接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryVisitRecordByRequest:(QueryVistitRecordHttpRequest *)request success:(void(^)(QueryVistitRecordHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  查询拜访规划接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryPlanVisiConfigsByRequest:(QueryPlanVisitConfigsHttpRequest *)request success:(void(^)(QueryPlanVisitConfigsHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  提交拜访规划接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)updateVisitPlansByRequest:(UpdateVisitPlansHttpRequest *)request success:(void(^)(UpdateVisitPlansHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
=======

@interface KHGLAPI : NSObject

+(void)allTypeInfoByRequest:(AllTypeHttpRequest *)request success:(void(^)(QueryDetailAdviceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_querySaleTask Success:^(LK_HttpBaseResponse *response) {
        success((QueryDetailAdviceHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryDetailAdviceHttpResponse class]];
}
>>>>>>> de114e4ff721da211b17de3b55ff0f0094a9752a


@end
