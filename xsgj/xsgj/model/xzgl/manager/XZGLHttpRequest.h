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

@property(nonatomic,strong) NSString *sessionId;//会话id
@property(nonatomic,strong) NSString *corpId;//企业id
@property(nonatomic,strong) NSString *deptId;//部门id
@property(nonatomic,strong) NSString *userAuth;//数据权限
@property(nonatomic,strong) NSString *userId;//用户id
@property(nonatomic,strong) NSString *lng;//经度
@property(nonatomic,strong) NSString *lat;//纬度
@property(nonatomic,strong) NSString *postion;//地理位置
@property(nonatomic,strong) NSString *lng2;//纠偏经度
@property(nonatomic,strong) NSString *lat2;//纠偏纬度
@property(nonatomic,strong) NSString *postion2;//纠偏位置
@property(nonatomic,strong) NSString *signFlag;//考勤标志
@property(nonatomic,strong) NSString *deviceCode;//手机标识码(imei)
@property(nonatomic,strong) NSString *photo;//上传附件id
@property(nonatomic,strong) NSString *signTime;//上传时间

@end

@interface QueryAttendanceHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *sessionId;//会话id
@property(nonatomic,strong) NSString *corpId;//企业id
@property(nonatomic,strong) NSString *deptId;//部门id
@property(nonatomic,strong) NSString *userAuth;//数据权限
@property(nonatomic,strong) NSString *userId;//用户id
@property(nonatomic,strong) NSString *queryDeptid;//查询部门标识
@property(nonatomic,strong) NSString *userName;//登录名
@property(nonatomic,strong) NSString *realName;//姓名
@property(nonatomic,strong) NSString *mobileno;//手机号码
@property(nonatomic,strong) NSString *begintime;//上报开始时间
@property(nonatomic,strong) NSString *endTime;//上报结束时间
@property(nonatomic,strong) NSString *signId;//考勤标识
@property(nonatomic,strong) NSString *signFlag;//考勤标志  i:签到 o:签退

@end

@interface DetailAttendanceHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *sessionId;//会话id
@property(nonatomic,strong) NSString *corpId;//企业id
@property(nonatomic,strong) NSString *deptId;//部门id
@property(nonatomic,strong) NSString *userAuth;//数据权限
@property(nonatomic,strong) NSString *userId;//用户id
@property(nonatomic,strong) NSString *queryDeptid;//查询部门标识
@property(nonatomic,strong) NSString *userName;//登录名
@property(nonatomic,strong) NSString *realName;//姓名
@property(nonatomic,strong) NSString *mobileno;//手机号码
@property(nonatomic,strong) NSString *begintime;//上报开始时间
@property(nonatomic,strong) NSString *endTime;//上报结束时间
@property(nonatomic,strong) NSString *signId;//考勤标识
@property(nonatomic,strong) NSString *signFlag;//考勤标志  i:签到 o:签退

@end

@interface ApplyLeaveHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *corpId;//企业id
@property(nonatomic,strong) NSString *userId;//用户id
@property(nonatomic,strong) NSString *typeId;//请假类型
@property(nonatomic,strong) NSString *title;//请假标题
@property(nonatomic,strong) NSString *remark;//请假说明
@property(nonatomic,strong) NSString *applyTime;//申请时间
@property(nonatomic,strong) NSString *beginTime;//开始时间
@property(nonatomic,strong) NSString *endTime;//结束时间

@end

@interface QueryLeaveHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *sessionId;//会话id
@property(nonatomic,strong) NSString *corpId;//企业id
@property(nonatomic,strong) NSString *deptId;//部门id
@property(nonatomic,strong) NSString *userAuth;//数据权限
@property(nonatomic,strong) NSString *userId;//用户id
@property(nonatomic,strong) NSString *typeId;//请假类型
@property(nonatomic,strong) NSString *userName;//用户名
@property(nonatomic,strong) NSString *mobileno;//手机号码
@property(nonatomic,strong) NSString *approveState;//审批状态
@property(nonatomic,strong) NSString *beginTime;//申请时间（开始时间）
@property(nonatomic,strong) NSString *endTime;//申请时间（结束时间）
@property(nonatomic,strong) NSString *approveUser;//审批人

@end

@interface QueryLeaveDetailHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *sessionId;//会话id
@property(nonatomic,strong) NSString *corpId;//企业id
@property(nonatomic,strong) NSString *deptId;//部门id
@property(nonatomic,strong) NSString *userAuth;//数据权限
@property(nonatomic,strong) NSString *userId;//用户id
@property(nonatomic,strong) NSString *leaveId;//调休id
@property(nonatomic,strong) NSString *typeId;//请假类型
@property(nonatomic,strong) NSString *userName;//用户名
@property(nonatomic,strong) NSString *mobileno;//手机号码
@property(nonatomic,strong) NSString *approveState;//审批状态（0:未审批 1:已通过 2:未通过）
@property(nonatomic,strong) NSString *beginTime;//申请时间(开始时间)
@property(nonatomic,strong) NSString *endTime;//申请时间(结束时间)
@property(nonatomic,strong) NSString *approveUser;//审批人

@end

@interface ApprovalLeaveHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *leaveId;//调休id
@property(nonatomic,strong) NSString *approveState;//审批状态
@property(nonatomic,strong) NSString *approveTime;//审批时间
@property(nonatomic,strong) NSString *corpId;//企业id
@property(nonatomic,strong) NSString *userId;//用户id
@property(nonatomic,strong) NSString *approveUser;//审批人
@property(nonatomic,strong) NSString *approveRemark;//审批结果说明

@end

@interface ApplyTripHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *corpId;//企业标识
@property(nonatomic,strong) NSString *userId;//用户标识
@property(nonatomic,strong) NSString *title;//主题
@property(nonatomic,strong) NSString *beginTime;//出差开始时间
@property(nonatomic,strong) NSString *endTime;//出差结束时间
@property(nonatomic,strong) NSString *tripForm;//出差始发地
@property(nonatomic,strong) NSString *tripTo;//出差目的地
@property(nonatomic,strong) NSString *remark;//出差说明
@property(nonatomic,strong) NSString *approveTime;//申请时间
@property(nonatomic,strong) NSString *approveUser;//审批人

@end

@interface ApproveTripHttpRequst : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *tripId;//出差标识
@property(nonatomic,strong) NSString *corpId;//企业标识
@property(nonatomic,strong) NSString *userId;//用户标识
@property(nonatomic,strong) NSString *approveState;//审批状态 0未审批 1:已通过 2:未通过
@property(nonatomic,strong) NSString *approveRemark;//审批描述
@property(nonatomic,strong) NSString *approveTime;//审批时间

@end

@interface QueryTripHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *tripId;//出差示识
@property(nonatomic,strong) NSString *corpId;//企业标识
@property(nonatomic,strong) NSString *userId;//用户标识
@property(nonatomic,strong) NSString *title;//主题
@property(nonatomic,strong) NSString *beginTime;//出差开始时间
@property(nonatomic,strong) NSString *endTime;//出差结束时间
@property(nonatomic,strong) NSString *tripFrom;//出差始发地
@property(nonatomic,strong) NSString *tripTo;//出差目的地
@property(nonatomic,strong) NSString *applyTime;//申请时间
@property(nonatomic,strong) NSString *approveUser;//审批人
@property(nonatomic,strong) NSString *approveState;//审批状态 0:未审批1:已通过  2:未通过
@property(nonatomic,strong) NSString *approveTime;//审批时间

@end

@interface QueryTripDetailHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *tripId;//出差标识

@end

@interface WorkReportHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *sessionId;//会话id
@property(nonatomic,strong) NSString *corpId;//企业id
@property(nonatomic,strong) NSString *deptId;//部门id
@property(nonatomic,strong) NSString *userAuth;//数据权限
@property(nonatomic,strong) NSString *userId;//用户id
@property(nonatomic,strong) NSString *typeId;//类型
@property(nonatomic,strong) NSString *content;//内容
@property(nonatomic,strong) NSString *committime;//上报时间

@end


