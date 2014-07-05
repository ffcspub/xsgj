//
//  ShareValue.h
//  jiulifang
//
//  Created by hesh on 13-11-6.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VERSION 1

#define TABLEVERION 1.1

#define DEFINE_SUCCESSCODE @"1"

@interface ShareValue : NSObject


+(ShareValue *)shareInstance;

@property(nonatomic,assign) BOOL noRemberFlag;//记住密码
@property(nonatomic,assign) BOOL noAutoFlag;//自动登录
@property(nonatomic,assign) BOOL noShowPwd;//是否显示密码
@property(nonatomic,strong) NSString *corpCode;//企业编码
@property(nonatomic,strong) NSString *userName;//用户名
@property(nonatomic,strong) NSString *userPass;//登录类型


@end
