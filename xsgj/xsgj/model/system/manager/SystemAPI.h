//
//  UserManager.h
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNUserInfo.h"
#import "SystemHttpRequest.h"
#import "SystemHttpResponse.h"

@interface SystemAPI : NSObject

//登录
+(void)loginByCorpcode:(NSString *)corpcode username:(NSString *)username password:(NSString *)password  success:(void(^)(BNUserInfo *userinfo))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

//更新配置
+(void)updateConfigSuccess:(void(^)())success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

//定时定位上报(采用百度地图）
+(void)commitLocateSuccess:(void(^)())success LOC_TYPE:(NSString *)type LNG:(double)lng LAT:(double)lat fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

//手机状态上报
+(void)insertMobileSuccess:(void(^)())success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  照片上传接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)uploadPhotoByFileName:(NSString *)fileName data:(NSData *)data success:(void(^)(NSString *fileId))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  读取手机上报工作时间范围
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)getWorkRangeByRequest:(GetWorkRangeHttpRequest *)request success:(void(^)(GetWorkRangeHttpResponse *reponse))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  读取手机上报时间间隔
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)getTimeIntervalByRequest:(GetTimeIntervalHttpRequest *)request success:(void(^)(GetTimeIntervalHttpResponse *reponse))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

@end
