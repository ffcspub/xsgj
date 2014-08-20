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

//获取服务器更新时间
+(void)getServerUpdatetimeSuccess:(void(^)(unsigned  long long lastupdatetime))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;



//定时定位上报(采用百度地图）
+(void)commitLocateSuccess:(void(^)())success LOC_TYPE:(NSString *)type LNG:(double)lng LAT:(double)lat fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

//手机状态上报
+(void)insertMobileSuccess:(void(^)())success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

//手机状态上报离线
+(void)insertDownMobileSuccess:(void(^)())success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  照片上传接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 *
 *  @return 返回照片的ID
 */
+(void)uploadPhotoByFileName:(NSString *)fileName data:(NSData *)data success:(void(^)(NSString *fileId))success fail:(void(^)(BOOL notReachable,NSString *desciption,NSString *fileId))fail;

@end
