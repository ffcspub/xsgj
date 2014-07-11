//
//  ShareValue.h
//  jiulifang
//
//  Created by hesh on 13-11-6.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNUserInfo.h"

#define VERSION 1

#define TABLEVERION 1.3

#define DEFINE_SUCCESSCODE @"00000000"

@interface ShareValue : NSObject


+(ShareValue *)shareInstance;

@property(nonatomic,strong) BNUserInfo *userInfo;

@property(nonatomic,assign) BOOL noRemberFlag;//记住密码
@property(nonatomic,assign) BOOL noAutoFlag;//自动登录
@property(nonatomic,assign) BOOL noShowPwd;//是否显示密码
@property(nonatomic,weak) NSString *corpCode;//企业编码
@property(nonatomic,weak) NSString *userName;//用户名
@property(nonatomic,weak) NSString *userPass;//登录类型
@property(nonatomic,weak) NSNumber *userId;//用户编号

@end
