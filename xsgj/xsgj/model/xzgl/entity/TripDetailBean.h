//
//  TripDetailBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripDetailBean : NSObject

@property(nonatomic,strong) NSString *	DEPT_NAME	;//	部门名称
@property(nonatomic,assign) int         USER_ID	;//	人员标识
@property(nonatomic,strong) NSString *	USER_NAME	;//	人员名称
@property(nonatomic,strong) NSString *	MOBILENO	;//	手机号码
@property(nonatomic,strong) NSString *	REALNAME	;//	姓名
@property(nonatomic,strong) NSString *	TITLE	;//	主题
@property(nonatomic,strong) NSString *	REMARK	;//	出差说明
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	出差开始时间
@property(nonatomic,strong) NSString *	END_TIME 	;//	出差结束时间
@property(nonatomic,strong) NSString *	TRIP_FROM	;//	出发地
@property(nonatomic,strong) NSString *	TRIP_TO	;//	目的地
@property(nonatomic,strong) NSString *	APPLY_TIME	;//	申请时间
@property(nonatomic,assign) int         APPROVE_USER	;//	审批人
@property(nonatomic,strong) NSString *	APPROVE_STATE	;//	审批状态
@property(nonatomic,strong) NSString *	APPROVE_REMARK	;//	审批说明
@property(nonatomic,strong) NSString *	APPROVE_TIME	;//	审批时间
@property(nonatomic,strong) NSString *	APPROVE_USER_NAME	;//	审批人用户名
@property(nonatomic,strong) NSString *	APPROVE_MOBILENO	;//	审批人电话号码
@property(nonatomic,strong) NSString *	APPROVE_REALNAME	;//	审批人姓名

@end
