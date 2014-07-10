//
//  KHGLAPI.m
//  xsgj
//
//  Created by mac on 14-7-10.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KHGLAPI.h"
<<<<<<< HEAD
#import "LK_API.h"
#import "ServerConfig.h"

@implementation KHGLAPI

+(void)allTypeInfoByRequest:(AllTypeHttpRequest *)request success:(void(^)(AllTypeHttpRequest *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_allTypeinfo Success:^(LK_HttpBaseResponse *response) {
        success((AllTypeHttpRequest *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[AllTypeHttpRequest class]];
}

/**
 *  新客户信息上报
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)addCustomerCommitByRequest:(AddCustomerCommitHttpRequest *)request success:(void(^)(AddCustomerCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_addCustomerCommit Success:^(LK_HttpBaseResponse *response) {
        success((AddCustomerCommitHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[AddCustomerCommitHttpResponse class]];
}

/**
 *  客户信息查询
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)customerQueryByRequest:(CustomerQueryHttpRequest *)request success:(void(^)(CustomerQueryHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_queryCustomer Success:^(LK_HttpBaseResponse *response) {
        success((CustomerQueryHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CustomerQueryHttpResponse class]];
}

/**
 *  客户详情信息查询
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)customerDetailByRequest:(CustomerDetailHttpRequest *)request success:(void(^)(CustomerDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_customerDetail Success:^(LK_HttpBaseResponse *response) {
        success((CustomerDetailHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CustomerDetailHttpResponse class]];
}

/**
 *  离店登记接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)recordVisitByRequest:(RecordVisitHttpRequest *)request success:(void(^)(RecordVisitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_recordVisit Success:^(LK_HttpBaseResponse *response) {
        success((RecordVisitHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[RecordVisitHttpResponse class]];
}

/**
 *  查询拜访记录接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryVisitRecordByRequest:(QueryVistitRecordHttpRequest *)request success:(void(^)(QueryVistitRecordHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_recordVisit Success:^(LK_HttpBaseResponse *response) {
        success((QueryVistitRecordHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryVistitRecordHttpResponse class]];
}

/**
 *  查询拜访规划接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryPlanVisiConfigsByRequest:(QueryPlanVisitConfigsHttpRequest *)request success:(void(^)(QueryPlanVisitConfigsHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_planVisit Success:^(LK_HttpBaseResponse *response) {
        success((QueryPlanVisitConfigsHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryPlanVisitConfigsHttpResponse class]];
}

/**
 *  提交拜访规划接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)updateVisitPlansByRequest:(UpdateVisitPlansHttpRequest *)request success:(void(^)(UpdateVisitPlansHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_updateVisitPlans Success:^(LK_HttpBaseResponse *response) {
        success((UpdateVisitPlansHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[UpdateVisitPlansHttpResponse class]];
}


=======

@implementation KHGLAPI

>>>>>>> de114e4ff721da211b17de3b55ff0f0094a9752a
@end
