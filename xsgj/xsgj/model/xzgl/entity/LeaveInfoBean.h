//
//  LeaveInfoBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeaveInfoBean : NSObject

@property(nonatomic,strong) NSString *	DEPT_NAME;//	部门名称
@property(nonatomic,strong) NSString *	USER_NAME;//	用户名称
@property(nonatomic,assign) int         USER_ID;//	人员标识
@property(nonatomic,strong) NSString *	MOBILENO;//	电话号码
@property(nonatomic,strong) NSString *	REALNAME;//	姓名
@property(nonatomic,strong) NSString *	TYPE_NAME;//	调休类型名称
@property(nonatomic,strong) NSString *	TITLE;//	 主题
@property(nonatomic,strong) NSString *	REMARK;//	调休说明
@property(nonatomic,strong) NSString *	BEGIN_TIME;//	开始时间
@property(nonatomic,strong) NSString *	END_TIME;//	结束时间
@property(nonatomic,strong) NSString *	APPLY_TIME;//	申请时间
@property(nonatomic,strong) NSString *	APPROVE_USER;//	审批人标识
@property(nonatomic,strong) NSString *	APPROVE_STATE;//	审批状态
@property(nonatomic,strong) NSString *	APPROVE_REAMRK;//	审批备注
@property(nonatomic,strong) NSString *	APPROVE_TIME;//	审批时间

@end
