//
//  KHGLHttpRequest.h
//  xsgj
//
//  Created by mac on 14-7-10.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpRequest.h"


@interface AllTypeHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *SESSION_ID;//会话ID
@property(nonatomic,assign) int CORP_ID;//企业ID
@property(nonatomic,assign) int DEPT_ID;//部门ID
@property(nonatomic,strong) NSString *USER_AUTH;//数据权限
@property(nonatomic,assign) int USER_ID;//用户ID

@end

@interface AddCustomerCommitHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,assign) int         CLASS_ID;//	客户类型ID
@property(nonatomic,strong) NSString *	CUST_NAME	;//	客户名称
@property(nonatomic,strong) NSString *	CUST_CODE	;//	客户编码
@property(nonatomic,strong) NSString *	LINKMAN	;//	联系人
@property(nonatomic,strong) NSString *	TEL	;//	联系电话
@property(nonatomic,strong) NSString *	ADDRESS	;//	联系地址
@property(nonatomic,strong) NSString *	REMARK	;//	备注
@property(nonatomic,strong) NSString *	PHOTO	;//	照片
@property(nonatomic,strong) NSNumber *	LNG	;//	经度
@property(nonatomic,strong) NSNumber *	LAT	;//	纬度
@property(nonatomic,strong) NSString *	POSITION	;//	地理位置
@property(nonatomic,strong) NSString *	COMMITTIME	;//	创建时间

@end

@interface CustomerQueryHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID	;//	企业ID
@property(nonatomic,assign) int         DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID	;//	用户ID
@property(nonatomic,strong) NSNumber *  TYPE_ID	;//	客户类型标识
@property(nonatomic,strong) NSString *	CUST_NAME	;//	客户名称

@end

@interface CustomerDetailHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,strong) NSNumber *	CUST_ID;//	客户标识
@property(nonatomic,strong) NSNumber *	TYPE_ID;//	客户类型标识
@property(nonatomic,strong) NSString *	CUST_NAME;//	客户名称

@end

@interface RecordVisitHttpRequest : LK_HttpBaseRequest

@property(nonatomic,assign) int         USER_ID;//	用户标识
@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话标识
@property(nonatomic,assign) int         CORP_ID;//	企业标识
@property(nonatomic,assign) int         DEPT_ID;//	部门标识
@property(nonatomic,strong) NSString *	USER_AUTH	;//	用户数据权限
@property(nonatomic,assign) int         CONF_ID;//	线路配置id
@property(nonatomic,assign) int         CUST_ID;//	客户标识
@property(nonatomic,strong) NSString *  VISIT_NO;//	拜访编号(随机生成的uuid)
@property(nonatomic,strong) NSString *	VISIT_TYPE	;//	拜访类型(0表示临时拜访 1表示计划拜访)
@property(nonatomic,strong) NSString *	VISIT_DATE	;//	计划拜访日期
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	开始时间
@property(nonatomic,strong) NSNumber *	BEGIN_LAT	;//	开始纬度
@property(nonatomic,strong) NSNumber *	BEGIN_LNG	;//	开始经度
@property(nonatomic,strong) NSString *	BEGIN_POS	;//	开始位置
@property(nonatomic,strong) NSNumber *	BEGIN_LAT2	;//	纠偏纬度
@property(nonatomic,strong) NSNumber *	BEGIN_LNG2	;//	纠偏经度
@property(nonatomic,strong) NSString *	BEGIN_POS2	;//	纠偏位置
@property(nonatomic,strong) NSString *	END_TIME	;//	结束拜访时间
@property(nonatomic,strong) NSNumber *	END_LAT	;//	结束纬度
@property(nonatomic,strong) NSNumber *	END_LNG	;//	结束经度
@property(nonatomic,strong) NSString *	END_POS	;//	结束位置
@property(nonatomic,strong) NSNumber *	END_LAT2	;//	纠偏结束纬度
@property(nonatomic,strong) NSNumber *	END_LNG2	;//	纠偏结束经度
@property(nonatomic,strong) NSString *	END_POS2	;//	纠偏结束位置

@end


@interface QueryVistitRecordHttpRequest : LK_HttpBaseRequest

@property(nonatomic,assign) int USER_ID	;//	用户标识
@property(nonatomic,strong) NSString * 	SESSION_ID	;//	会话标识
@property(nonatomic,assign) int         CORP_ID	;//	企业标识
@property(nonatomic,assign) int         DEPT_ID 	;//	部门标识
@property(nonatomic,strong) NSString * 	CUST_NAME	;//	客户姓名
@property(nonatomic,strong) NSString * 	BEGIN_TIME	;//	起始时间
@property(nonatomic,strong) NSString * 	END_TIME	;//	结束时间
@property(nonatomic,strong) NSString * 	USER_AUTH	;//	用户数据权限
@property(nonatomic,strong) NSNumber * 	QUERY_DEPTID	;//	要查询的部门id
@property(nonatomic,strong) NSNumber * 	QUERY_USER_ID	;//	要查询的用户id

@end

@interface QueryPlanVisitConfigsHttpRequest : LK_HttpBaseRequest

@property(nonatomic,assign) int         USER_ID	;//	用户标识
@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话标识
@property(nonatomic,assign) int         CORP_ID;//	企业标识
@property(nonatomic,assign) int         DEPT_ID;//	部门标识
@property(nonatomic,strong) NSString *	USER_AUTH	;//	用户数据权限
@property(nonatomic,strong) NSString *	PLAN_DATE	;//	起始时期

@end

@interface UpdateVisitPlansHttpRequest : LK_HttpBaseRequest

@property(nonatomic,assign) int         USER_ID;//	用户标识
@property(nonatomic,strong) NSString *	SESSION_ID;//	会话标识
@property(nonatomic,assign) int         CORP_ID;//	企业标识
@property(nonatomic,assign) int         DEPT_ID;//	部门标识
@property(nonatomic,strong) NSString *	USER_AUTH;//	用户数据权限
@property(nonatomic,strong) NSString *	PLAN_DATE;//	计划拜访日期
@property(nonatomic,strong) NSString *	WEEKDAY;//	星期几
@property(nonatomic,strong) NSArray  *	VISIT_PLANS;//	拜访计划

@end

