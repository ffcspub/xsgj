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

/**
 *  考勤详细查询
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)detailAttendanceByRequest:(DetailAttendanceHttpRequest *)request success:(void(^)(DetailAttendanceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  调休申请接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)applyLeaveByRequest:(ApplyLeaveHttpRequest *)request success:(void(^)(ApplyLeaveHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  调休详细信息查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryLeaveByRequest:(QueryLeaveHttpRequest *)request success:(void(^)(QueryLeaveHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  调休查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryLeaveDetailByRequest:(QueryLeaveDetailHttpRequest *)request success:(void(^)(QueryLeaveDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  调休审批接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)approvalLeaveByRequest:(ApprovalLeaveHttpRequest *)request success:(void(^)(ApprovalLeaveHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  出差申请接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)applyTripByRequest:(ApplyTripHttpRequest *)request success:(void(^)(ApplyTripHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  出差审批接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)approvalTripByRequest:(ApproveTripHttpRequst *)request success:(void(^)(ApproveTripHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  出差查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryTripByRequest:(QueryTripHttpRequest *)request success:(void(^)(QueryTripHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  出差详细查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryTripDeTailByRequest:(QueryTripDetailHttpRequest *)request success:(void(^)(QueryTripDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  工作汇报类型获取接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)workReportTypeByRequest:(WorkTypeHttpRequest *)request success:(void(^)(WorkTypeHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  工作汇报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)workReportByRequest:(WorkReportHttpRequest *)request success:(void(^)(WorkReportHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  添加意见建议接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)addAdviceByRequest:(AddAdviceHttpRequest *)request success:(void(^)(AddAdviceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  查询意见建议接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryAdviceByRequest:(QueryAdviceHttpRequest *)request success:(void(^)(QueryAdviceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  查询意见建议详情接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryDetailAdviceByRequest:(QueryDetailAdviceHttpRequest *)request success:(void(^)(QueryDetailAdviceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;


/**
 *  销量任务查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)QuerySaleTaskByRequest:(QuerySaleTaskHttpRequest *)request success:(void(^)(QueryDetailAdviceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  获取调休、请假类型接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryLeaveTypeByRequest:(LeaveTypeHttpRequest *)request success:(void(^)(LeaveTypeHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  日常拍照上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)insertUserCameraByRequest:(InsertUserCameraHttpRequest *)request success:(void(^)(InsertUserCameraHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;


@end
