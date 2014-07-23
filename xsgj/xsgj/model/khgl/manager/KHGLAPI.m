//
//  KHGLAPI.m
//  xsgj
//
//  Created by mac on 14-7-10.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KHGLAPI.h"
#import "LK_API.h"
#import "ServerConfig.h"
#import "NSData+Base64.h"


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
    [LK_APIUtil getHttpRequest:request apiPath:URL_queryPlanVisitConfigs Success:^(LK_HttpBaseResponse *response) {
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


/**
 *  活动上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)commitActivityByRequest:(ActivityCommitHttpRequest *)request success:(void(^)(ActivityCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_ACTIVITY_COMMIT_URL Success:^(LK_HttpBaseResponse *response) {
        success((ActivityCommitHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ActivityCommitHttpResponse class]];
}


/**
 *  竞品上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)insertCompeteByRequest:(InsertCompeteHttpRequest *)request success:(void(^)(InsertCompeteHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_insertCompete Success:^(LK_HttpBaseResponse *response) {
        success((InsertCompeteHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[InsertCompeteHttpResponse class]];
}

/**
 *  订单上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)commitOrderByRequest:(OrderCommitHttpRequest *)request success:(void(^)(OrderCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    
    [LK_APIUtil getHttpRequest:request apiPath:URL_ORDER_COMMIT Success:^(LK_HttpBaseResponse *response) {
        success((OrderCommitHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[OrderCommitHttpResponse class]];
}


/**
 *  订单查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryOrderByRequest:(OrderQueryHttpRequest *)request success:(void(^)(OrderQueryHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_QUERY_ORDERS Success:^(LK_HttpBaseResponse *response) {
        success((OrderQueryHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[OrderQueryHttpResponse class]];

}


/**
 *  订单详情查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryOrderDetailByRequest:(OrderDetailHttpRequest *)request success:(void(^)(OrderDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    
    [LK_APIUtil getHttpRequest:request apiPath:URL_ORDER_DETAIL Success:^(LK_HttpBaseResponse *response) {
        success((OrderDetailHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[OrderDetailHttpResponse class]];
}

/**
 *  退货查请接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)insertOrderBackByRequest:(InsertOrderBackHttpRequest *)request success:(void(^)(InsertOrderBackHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_ORDER_BACK_COMMIT Success:^(LK_HttpBaseResponse *response) {
        success((InsertOrderBackHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[InsertOrderBackHttpResponse class]];
}

/**
 *  退单查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryOrderBackByRequest:(QueryOrderBackHttpRequest *)request success:(void(^)(QueryOrderBackHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    
    [LK_APIUtil getHttpRequest:request apiPath:URL_QUERY_ORDER_BACK Success:^(LK_HttpBaseResponse *response) {
        success((QueryOrderBackHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryOrderBackHttpResponse class]];
}

/**
 *  退单详情查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryOrderBackDetailByRequest:(QueryOrderBackDetailHttpRequest *)request success:(void(^)(QueryOrderBackDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_ORDER_BACK_DETAIL Success:^(LK_HttpBaseResponse *response) {
        success((QueryOrderBackDetailHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryOrderBackDetailHttpResponse class]];

}


/**
 *  库存上传接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)commitStockByRequest:(StockCommitHttpRequest *)request  success:(void(^)(StockCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_STOCK_COMMIT Success:^(LK_HttpBaseResponse *response) {
        success((StockCommitHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[StockCommitHttpResponse class]];
}


/**
 *  店招拍照上传接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)storeCameraCommitByRequest:(StoreCameraCommitHttpRequest *)request  success:(void(^)(StoreCameraCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_storeCameraCommit Success:^(LK_HttpBaseResponse *response) {
        success((StoreCameraCommitHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[StoreCameraCommitHttpResponse class]];
}


/**
 *  陈列拍照上传接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)displayCameraCommitByRequest:(DisplayCameraCommitHttpRequest *)request success:(void(^)(DisplayCameraCommitHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_displayCameraCommit Success:^(LK_HttpBaseResponse *response) {
        success((DisplayCameraCommitHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[DisplayCameraCommitHttpResponse class]];
}

/**
 *  陈列生动上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)insertDisplayVividByRequest:(InsertDisplayVividHttpRequest *)request success:(void(^)(InsertDisplayVividHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_insertDisplayVivid Success:^(LK_HttpBaseResponse *response) {
        success((InsertDisplayVividHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[InsertDisplayVividHttpResponse class]];
}

/**
 *  陈列费用上报接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)insertDisplayCostByRequest:(InsertDisplayCostHttpRequest *)request success:(void(^)(InsertDisplayCostHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_insertDisplayCost Success:^(LK_HttpBaseResponse *response) {
        success((InsertDisplayCostHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[InsertDisplayCostHttpResponse class]];
}


+(NSString*)base64forData:(NSData*)theData {
	
	const uint8_t* input = (const uint8_t*)[theData bytes];
	NSInteger length = [theData length];
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
	NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
		for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
