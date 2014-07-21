//
//  XZGLHttpRequest.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_API.h"

@interface SignUpHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID	String	非空
@property(nonatomic,assign) int         CORP_ID;//	企业ID	Long	非空
@property(nonatomic,assign) int         DEPT_ID;//	部门ID	Long	非空
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限	String	非空
@property(nonatomic,assign) int         USER_ID;//	用户ID	Long 	非空
@property(nonatomic,assign) float       LNG;//	经度 	Float	非空
@property(nonatomic,assign) float       LAT;//	纬度 	Float	非空
@property(nonatomic,strong) NSString *	POSITION;//	地理位置	String	非空
@property(nonatomic,strong) NSNumber *  LNG2;//	纠偏经度	Float	可选
@property(nonatomic,strong) NSNumber *  LAT2;//	纠偏纬度 	Float	可选
@property(nonatomic,strong) NSString *	POSITION2;//	纠偏位置 	String	可选
@property(nonatomic,strong) NSString *	SIGN_FLAG;//	考勤标志	String	非空(i:签到 o:签退)
@property(nonatomic,strong) NSString *	DEVICE_CODE;//	手机标识码（IMEI）	String	非空
@property(nonatomic,strong) NSNumber *  PHOTO;//	上传附件ID	Long	可选
@property(nonatomic,strong) NSString *  SIGN_TIME;//	上传时间	Date 非空

@end

@interface QueryAttendanceHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID	String	非空	50
@property(nonatomic,assign) int         CORP_ID;//	企业ID	Long	非空	20
@property(nonatomic,assign) int         DEPT_ID;//	部门ID	Long	非空	20
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限	String	非空	1
@property(nonatomic,assign) int         USER_ID;//	用户ID	Long 	非空	20
@property(nonatomic,strong) NSNumber *  QUERY_DEPTID;//	查询部门标识	Long	可选	20
@property(nonatomic,strong) NSString *	USER_NAME;//	登录名	String	可选	20
@property(nonatomic,strong) NSString *	REALNAME;//	姓名	String	可选	20
@property(nonatomic,strong) NSString *	MOBILENO;//	手机号码	String	可选	20
@property(nonatomic,strong) NSString *	BEGIN_TIME;//	上报开始时间	Date	可选
@property(nonatomic,strong) NSString *	END_TIME;//	上报结束时间Date可选
@property(nonatomic,strong) NSString *	SIGN_FLAG;//	考勤标志	String	可选	1

@end

@interface DetailAttendanceHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,strong) NSNumber *  QUERY_DEPTID;//	查询部门标识
@property(nonatomic,strong) NSString *	USER_NAME;//	登录名
@property(nonatomic,strong) NSString *	REALNAME;//	姓名
@property(nonatomic,strong) NSString *	MOBILENO;//	手机号码
@property(nonatomic,strong) NSString *	BEGIN_TIME;//	上报开始时间
@property(nonatomic,strong) NSString *	END_TIME;//	上报结束时间
@property(nonatomic,assign) NSNumber *  SIGN_ID;//	考勤标识
@property(nonatomic,strong) NSString *	SIGN_FLAG;//考勤标志

@end

@interface ApplyLeaveHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,assign) int         TYPE_ID	;//	请假类型
@property(nonatomic,strong) NSString *	TITLE	;//	请假标题
@property(nonatomic,strong) NSString *	REMARK	;//	请假说明
@property(nonatomic,strong) NSString *	APPLY_TIME	;//	申请时间
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	开始时间
@property(nonatomic,strong) NSString *	END_TIME	;//	结束时间
@property(nonatomic,strong) NSString *	LEADER	;//	直属领导ID
@property(nonatomic,strong) NSString *  LEAVE_DAYS;//请假天数

@end

@interface QueryLeaveHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID	;//	企业ID
@property(nonatomic,assign) int         DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID	;//	用户ID
@property(nonatomic,strong) NSString *	TYPE_ID	;//	请假类型
@property(nonatomic,strong) NSString *	USER_NAME	;//	用户名
@property(nonatomic,strong) NSString *	MOBILENO	;//	手机号码
@property(nonatomic,strong) NSString *	APPROVE_STATE	;//	审批状态
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	申请时间（开始时间）
@property(nonatomic,strong) NSString *	END_TIME	;//	申请时间（结束时间）
@property(nonatomic,assign) int         PAGE	;//	第N页
@property(nonatomic,assign) int         ROWS	;//	加载行数
@property(nonatomic,strong) NSString *	LEADER	;//	直属领导ID
@property(nonatomic,strong) NSString *	QUERY_USERID	;//	人员标识id
@property(nonatomic,strong) NSString *	APPROVE_USER	;//	审批人

@end

@interface QueryLeaveDetailHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,strong) NSString *	LEAVE_ID;//	调休ID
@property(nonatomic,strong) NSString *	TYPE_ID;//	请假类型
@property(nonatomic,strong) NSString *	USER_NAME;//	用户名
@property(nonatomic,strong) NSString *	MOBILENO;//	手机号码
@property(nonatomic,strong) NSString *	APPROVE_STATE;//	审批状态(0:未审批 1:已通过 2:未通过)
@property(nonatomic,strong) NSString *	BEGIN_TIME;//	申请时间（开始时间）
@property(nonatomic,strong) NSString *	END_TIME;//	申请时间（结束时间）
@property(nonatomic,assign) int         PAGE;//	第N页
@property(nonatomic,assign) int         ROWS;//	加载行数
@property(nonatomic,strong) NSString *	APPROVE_USER;//	审批人

@end

@interface ApprovalLeaveHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,assign) int         LEAVE_ID;//	调休id
@property(nonatomic,strong) NSString *	APPROVE_STATE;//	审批状态(0:未审批 1:已通过 2:未通过)
@property(nonatomic,strong) NSString *	APPROVE_TIME;//	审批时间
@property(nonatomic,assign) int         APPROVE_USER;//	审批人
@property(nonatomic,strong) NSString *	APPROVE_REMARK;//	审批结果说明

@end

@interface ApplyTripHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,strong) NSString *	TITLE	;//	主题
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	出差开始时间
@property(nonatomic,strong) NSString *	END_TIME	;//	出差结束时间
@property(nonatomic,strong) NSString *	TRIP_FROM	;//	出差始发地
@property(nonatomic,strong) NSString *	TRIP_TO	;//	出差目的地
@property(nonatomic,assign) NSString *  TRIP_DAYS;//出差天数
@property(nonatomic,strong) NSString *	REMARK	;//	出差说明
@property(nonatomic,strong) NSString *	APPLY_TIME	;//	申请时间
@property(nonatomic,strong) NSString *	APPROVE_USER	;//	审批人
@end

@interface ApproveTripHttpRequst : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,assign) int         TRIP_ID	;//	出差标识
@property(nonatomic,strong) NSString *	APPROVE_STATE	;//	审批状态
@property(nonatomic,strong) NSString *	APPROVE_REMARK	;//	审批描述
@property(nonatomic,strong) NSString *	APPROVE_TIME	;//	审批时间

@end

@interface QueryTripHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,assign) int         TRIP_ID	;//	出差标识
@property(nonatomic,strong) NSString *	TITLE	;//	主题
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	出差开始时间
@property(nonatomic,strong) NSString *	END_TIME	;//	出差结束时间
@property(nonatomic,strong) NSString *	TRIP_FROM	;//	出差始发地
@property(nonatomic,strong) NSString *	TRIP_TO	;//	出差目的地
@property(nonatomic,strong) NSString *	APPLY_TIME	;//	申请时间
@property(nonatomic,strong) NSString *	APPROVE_USER	;//	审批人
@property(nonatomic,strong) NSString *	APPROVE_STATE	;//	审批状态0:未审批 1:已通过 2:未通过
@property(nonatomic,strong) NSString *	APPROVE_TIME	;//	审批时间

@end

@interface QueryTripDetailHttpRequest : LK_HttpBaseRequest
@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,assign) int TRIP_ID;//出差标识

@end

@interface WorkReportHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID	;//	企业ID
@property(nonatomic,assign) int         DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID	;//	用户ID
@property(nonatomic,strong) NSString *	TYPE_ID	;//	类型
@property(nonatomic,strong) NSString *	CONTENT	;//	内容
@property(nonatomic,strong) NSString *	COMMITTIME	;//	上报时间

@end

@interface AddAdviceHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID	;//	企业ID
@property(nonatomic,assign) int         DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID	;//	用户ID
@property(nonatomic,strong) NSString *	CONTENT	;//	上报内容
@property(nonatomic,strong) NSString *	COMMITTIME	;//	上报时间

@end

@interface QueryAdviceHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID	;//	企业ID
@property(nonatomic,assign) int         DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID	;//	用户ID
@property(nonatomic,assign) int         QUERY_DEPTID	;//	查询部门标识
@property(nonatomic,strong) NSString *	USER_NAME	;//	登录名
@property(nonatomic,strong) NSString *	REALNAME	;//	姓名
@property(nonatomic,strong) NSString *	MOBILENO	;//	手机号码
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	上报开始时间
@property(nonatomic,strong) NSString *	END_TIME	;//	上报结束时间

@end

@interface QueryDetailAdviceHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID	;//	企业ID
@property(nonatomic,assign) int         DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID	;//	用户ID
@property(nonatomic,assign) int         QUERY_DEPTID	;//	查询部门标识
@property(nonatomic,strong) NSString *	USER_NAME	;//	登录名
@property(nonatomic,strong) NSString *	REALNAME	;//	姓名
@property(nonatomic,strong) NSString *	MOBILENO	;//	手机号码
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	上报开始时间
@property(nonatomic,strong) NSString *	END_TIME	;//	上报结束时间

@end

@interface QuerySaleTaskHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID	;//	企业ID
@property(nonatomic,assign) int         DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID	;//	用户ID
@property(nonatomic,assign) int         QUERY_DEPTID	;//	查询部门标识
@property(nonatomic,strong) NSString *	USER_NAME	;//	登录名
@property(nonatomic,strong) NSString *	REALNAME	;//	姓名
@property(nonatomic,strong) NSString *	MOBILENO	;//	手机号码
@property(nonatomic,strong) NSString *	BEGIN_MONTH	;//	查询起始月份
@property(nonatomic,strong) NSString *	END_MONTH	;//	查询终止月份

@end

@interface LeaveTypeHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID	;//	企业ID
@property(nonatomic,assign) int         DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID	;//	用户ID

@end

@interface InsertUserCameraHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID	;//	企业ID
@property(nonatomic,assign) int         DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID	;//	用户ID
@property(nonatomic,strong) NSString *	REMARK	;//	备注
@property(nonatomic,strong) NSString *	PHOTO1	;//	照片1ID
@property(nonatomic,strong) NSString *	PHOTO2	;//	照片2ID
@property(nonatomic,strong) NSString *	PHOTO3	;//	照片3ID
@property(nonatomic,strong) NSString *	PHOTO4	;//	照片4ID
@property(nonatomic,strong) NSString *	PHOTO5	;//	照片5ID
@property(nonatomic,strong) NSString *	COMITTIME	;//	上报时间

@end

