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
        success((SignUpHttpReponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[SignUpHttpReponse class]];
    
}

/**
 *  签到/签退查询
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryAttendanceByRequest:(QueryAttendanceHttpRequest *)request success:(void(^)(QueryAttendanceHttpReponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    
    [LK_APIUtil getHttpRequest:request apiPath:URL_queryAttendance Success:^(LK_HttpBaseResponse *response) {
        success((QueryAttendanceHttpReponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryAttendanceHttpReponse class]];
    
}

/**
 *  考勤详细查询
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)detailAttendanceByRequest:(DetailAttendanceHttpRequest *)request success:(void(^)(DetailAttendanceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    
    [LK_APIUtil getHttpRequest:request apiPath:URL_detailAttendance Success:^(LK_HttpBaseResponse *response) {
        success((DetailAttendanceHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[DetailAttendanceHttpResponse class]];
}

/**
 *  调休申请接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)applyLeaveByRequest:(ApplyLeaveHttpRequest *)request success:(void(^)(ApplyLeaveHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;{
    [LK_APIUtil getHttpRequest:request apiPath:URL_ApplyLeave Success:^(LK_HttpBaseResponse *response) {
        success((ApplyLeaveHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ApplyLeaveHttpResponse class]];
}

/**
 *  调休详细信息查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryLeaveByRequest:(QueryLeaveHttpRequest *)request success:(void(^)(QueryLeaveHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;{
    [LK_APIUtil getHttpRequest:request apiPath:URL_queryLeave Success:^(LK_HttpBaseResponse *response) {
        success((QueryLeaveHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryLeaveHttpResponse class]];
}

/**
 *  调休查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryLeaveDetailByRequest:(QueryLeaveDetailHttpRequest *)request success:(void(^)(QueryLeaveDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    
    [LK_APIUtil getHttpRequest:request apiPath:URL_queryLeaveDetail Success:^(LK_HttpBaseResponse *response) {
        success((QueryLeaveDetailHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryLeaveDetailHttpResponse class]];
}


/**
 *  调休审批接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)approvalLeaveByRequest:(ApprovalLeaveHttpRequest *)request success:(void(^)(ApprovalLeaveHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_ApprovalLeave Success:^(LK_HttpBaseResponse *response) {
        success((ApprovalLeaveHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ApprovalLeaveHttpResponse class]];
}

/**
 *  出差申请接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)applyTripByRequest:(ApplyTripHttpRequest *)request success:(void(^)(ApplyTripHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_applyTrip Success:^(LK_HttpBaseResponse *response) {
        success((ApplyTripHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ApplyTripHttpResponse class]];
}

/**
 *  出差审批接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)approvalTripByRequest:(ApproveTripHttpRequst *)request success:(void(^)(ApproveTripHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_approveTrip Success:^(LK_HttpBaseResponse *response) {
        success((ApproveTripHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ApproveTripHttpResponse class]];
}

/**
 *  出差查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryTripByRequest:(QueryTripHttpRequest *)request success:(void(^)(QueryTripHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_queryTrip Success:^(LK_HttpBaseResponse *response) {
        success((QueryTripHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryTripHttpResponse class]];
}

/**
 *  出差详细查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryTripDeTailByRequest:(QueryTripDetailHttpRequest *)request success:(void(^)(QueryTripDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_detailTrip Success:^(LK_HttpBaseResponse *response) {
        success((QueryTripDetailHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryTripDetailHttpResponse class]];
}

/**
 *  工作汇报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)workReportByRequest:(WorkReportHttpRequest *)request success:(void(^)(WorkReportHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_insertWorkInfo Success:^(LK_HttpBaseResponse *response) {
        success((WorkReportHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[WorkReportHttpResponse class]];
}

/**
 *  添加意见建议接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)addAdviceByRequest:(AddAdviceHttpRequest *)request success:(void(^)(AddAdviceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_addAdvice Success:^(LK_HttpBaseResponse *response) {
        success((AddAdviceHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[AddAdviceHttpResponse class]];
}

/**
 *  查询意见建议接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryAdviceByRequest:(QueryAdviceHttpRequest *)request success:(void(^)(QueryAdviceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_queryAdvice Success:^(LK_HttpBaseResponse *response) {
        success((QueryAdviceHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryAdviceHttpResponse class]];
}

/**
 *  查询意见建议详情接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryDetailAdviceByRequest:(QueryDetailAdviceHttpRequest *)request success:(void(^)(QueryDetailAdviceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_queryDetailAdvice Success:^(LK_HttpBaseResponse *response) {
        success((QueryDetailAdviceHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryDetailAdviceHttpResponse class]];
}

/**
 *  销量任务查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)QuerySaleTaskByRequest:(QuerySaleTaskHttpRequest *)request success:(void(^)(QueryDetailAdviceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_querySaleTask Success:^(LK_HttpBaseResponse *response) {
        success((QueryDetailAdviceHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryDetailAdviceHttpResponse class]];
}

/**
 *  获取调休、请假类型接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryLeaveTypeByRequest:(LeaveTypeHttpRequest *)request success:(void(^)(LeaveTypeHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_leave_type Success:^(LK_HttpBaseResponse *response) {
        success((LeaveTypeHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[LeaveTypeHttpResponse class]];
}

/**
 *  日常拍照上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)insertUserCameraByRequest:(InsertUserCameraHttpRequest *)request success:(void(^)(InsertUserCameraHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_insertUserCamera Success:^(LK_HttpBaseResponse *response) {
        success((InsertUserCameraHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[InsertUserCameraHttpResponse class]];
}

@end
