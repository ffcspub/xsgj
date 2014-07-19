//
//  UserManager.h
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNUserInfo.h"

@interface SystemAPI : NSObject

//登录
+(void)loginByCorpcode:(NSString *)corpcode username:(NSString *)username password:(NSString *)password  success:(void(^)(BNUserInfo *userinfo))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

//更新配置
+(void)updateConfigSuccess:(void(^)())success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

//定时定位上报(采用百度地图）
+(void)commitLocateSuccess:(void(^)())success LOC_TYPE:(NSString *)type LNG:(double)lng LAT:(double)lat fail:(void(^)(BOOL notReachable,NSString *desciption))fail;


@end
