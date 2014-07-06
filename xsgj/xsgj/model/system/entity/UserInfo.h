//
//  UserInfo.h
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property(nonatomic,strong) NSString *sessionId;//会话id
@property(nonatomic,strong) NSString *corpId;//企业id
@property(nonatomic,strong) NSString *corpCode;//企业编码
@property(nonatomic,strong) NSString *corpName;//企业名
@property(nonatomic,strong) NSString *deptId;//部门id;
@property(nonatomic,strong) NSString *deptName;//部门名称
@property(nonatomic,strong) NSString *roleId;//角色id
@property(nonatomic,strong) NSString *roleName;//角色名称
@property(nonatomic,strong) NSString *userId;//用户id
@property(nonatomic,strong) NSString *userName;//用户名
@property(nonatomic,strong) NSString *userAuth;//用户权阴
@property(nonatomic,strong) NSString *mobileNo;//移动手机号码
@property(nonatomic,strong) NSString *realname;//姓名
@property(nonatomic,strong) NSString *leaderId;//直接领导标识
@property(nonatomic,strong) NSString *leaderName;//直接领导名称
@property(nonatomic,strong) NSString *lastUpdateTime;//服务端配置信息最近更新时间

@end
