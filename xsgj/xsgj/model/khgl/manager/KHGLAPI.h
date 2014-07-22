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

/**
 *  活动上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)commitActivityByRequest:(ActivityCommitHttpRequest *)request success:(void(^)(ActivityCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  竞品上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)insertCompeteByRequest:(InsertCompeteHttpRequest *)request success:(void(^)(InsertCompeteHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;


/**
 *  订单上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)commitOrderByRequest:(OrderCommitHttpRequest *)request success:(void(^)(OrderCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;


/**
 *  订单查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryOrderByRequest:(OrderQueryHttpRequest *)request success:(void(^)(OrderQueryHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  订单详情查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryOrderDetailByRequest:(OrderDetailHttpRequest *)request success:(void(^)(OrderDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  退货查请接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)insertOrderBackByRequest:(InsertOrderBackHttpRequest *)request success:(void(^)(InsertOrderBackHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  退单查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryOrderBackByRequest:(QueryOrderBackHttpRequest *)request success:(void(^)(QueryOrderBackHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  退单详情查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryOrderBackDetailByRequest:(QueryOrderBackDetailHttpRequest *)request success:(void(^)(QueryOrderBackDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  库存上传接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)commitStockByRequest:(StockCommitHttpRequest *)request  success:(void(^)(StockCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  店招拍照上传接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)storeCameraCommitByRequest:(StoreCameraCommitHttpRequest *)request  success:(void(^)(StoreCameraCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  陈列拍照上传接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)displayCameraCommitByRequest:(DisplayCameraCommitHttpRequest *)request success:(void(^)(DisplayCameraCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  陈列生动上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)insertDisplayVividByRequest:(InsertDisplayVividHttpRequest *)request success:(void(^)(InsertDisplayVividHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  陈列费用上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)insertDisplayCostByRequest:(InsertDisplayCostHttpRequest *)request success:(void(^)(InsertDisplayCostHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  照片上传接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)uploadPhotoByFileName:(NSString *)fileName data:(NSData *)data success:(void(^)(NSString *fileId))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;



@end;
