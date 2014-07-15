//
//  BNUserInfo.h
//  用户信息
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNUserInfo : NSObject
// 企业ID
@property (nonatomic,assign) int CORP_ID;
// 部门ID
@property (nonatomic,assign) int DEPT_ID;
// 角色ID
@property (nonatomic,assign) int ROLE_ID;
// 用户ID
@property (nonatomic,assign) int USER_ID;
// 用户登录名称
@property (nonatomic,strong) NSString* USER_NAME;
// 用户密码
@property (nonatomic,strong) NSString* USER_PASS;
// 用户权限
@property (nonatomic,strong) NSString* USER_AUTH;
// 移动手机号码
@property (nonatomic,strong) NSString* MOBILENO;
// 姓名
@property (nonatomic,strong) NSString* REALNAME;
// 用户类型
@property (nonatomic,strong) NSString* USER_TYPE;
// IMEI设备唯一标示
@property (nonatomic,strong) NSString* DEVICE_CODE;
// 状态
@property (nonatomic,strong) NSString* STATE;
// 直接领导标识
@property (nonatomic,assign) int LEADER_ID;
// 直接领导名称
@property (nonatomic,strong) NSString* LEADER_NAME;
// 会话ID
@property (nonatomic,strong) NSString* SESSION_ID;
// 企业编码
@property (nonatomic,strong) NSString* CORP_CODE;
// 企业名称
@property (nonatomic,strong) NSString* CORP_NAME;
// 部门名称
@property (nonatomic,strong) NSString* DEPT_NAME;
// 角色名称
@property (nonatomic,strong) NSString* ROLE_NAME;
// 上次更新时间
@property (nonatomic,assign) unsigned  long long LAST_UPDATE_TIME;

+(BNUserInfo *)loadcacheByUserId:(int)userid;

@end
