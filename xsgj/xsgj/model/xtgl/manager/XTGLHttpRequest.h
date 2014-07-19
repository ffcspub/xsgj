//
//  XTGLHttpRequest.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpRequest.h"

@interface GetUserAllDeptHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID	String	非空
@property(nonatomic,assign) int         CORP_ID;//	企业ID	Long	非空
@property(nonatomic,assign) int         DEPT_ID;//	部门ID	Long	非空
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限	String	非空
@property(nonatomic,assign) int         USER_ID;//	用户ID	Long 	非空

@end

@interface QueryContactsHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID	String	非空
@property(nonatomic,assign) int         CORP_ID;//	企业ID	Long	非空
@property(nonatomic,assign) int         DEPT_ID;//	部门ID	Long	非空
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限	String	非空
@property(nonatomic,assign) int         USER_ID;//	用户ID	Long 	非空
@property(nonatomic,strong) NSNumber *	QUERY_DEPTID	;//	查询部门标识
@property(nonatomic,strong) NSString *	REALNAME	;//	姓名
@property(nonatomic,strong) NSString *	MOBILENO	;//	手机号码

@end

@interface QueryNoticeHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID	String	非空
@property(nonatomic,assign) int         CORP_ID;//	企业ID	Long	非空
@property(nonatomic,assign) int         DEPT_ID;//	部门ID	Long	非空
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限	String	非空
@property(nonatomic,assign) int         USER_ID;//	用户ID	Long 	非空
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	发布开始时间
@property(nonatomic,strong) NSString *	END_TIME	;//	发布结束时间
@property(nonatomic,strong) NSString *	TYPE_ID	;//	公告类型 1:部门公告 2.区域公告
@property(nonatomic,strong) NSString *	LOOK_FLAG	;//	是否查看过期公告  0:查看  1:不查看

@end

@interface NoticeDetailHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID	String	非空
@property(nonatomic,assign) int         CORP_ID;//	企业ID	Long	非空
@property(nonatomic,assign) int         DEPT_ID;//	部门ID	Long	非空
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限	String	非空
@property(nonatomic,assign) int         USER_ID;//	用户ID	Long 	非空
@property(nonatomic,assign) int         NOTICE_ID;//公告标识

@end

@interface NoticeTypesHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID	String	非空
@property(nonatomic,assign) int         CORP_ID;//	企业ID	Long	非空
@property(nonatomic,assign) int         DEPT_ID;//	部门ID	Long	非空
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限	String	非空
@property(nonatomic,assign) int         USER_ID;//	用户ID	Long 	非空

@end

@interface UpdataPwdHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID	String	非空
@property(nonatomic,assign) int         CORP_ID;//	企业ID	Long	非空
@property(nonatomic,assign) int         DEPT_ID;//	部门ID	Long	非空
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限	String	非空
@property(nonatomic,assign) int         USER_ID;//	用户ID	Long 	非空
@property(nonatomic,strong) NSString *  OLDPWD;//旧密码
@property(nonatomic,strong) NSString *  NEWPWD;//新密码

@end

@interface ForgetPwdHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *USER_NAME;//登录用户名
@property(nonatomic,strong) NSString *CORP_CODE;//企业编码

@end


@interface AddApplyCorpHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString * 	NAME	;//	名称
@property(nonatomic,strong) NSString * 	CODE	;//	编码
@property(nonatomic,strong) NSString * 	AREAADDRESS	;//	区域地址
@property(nonatomic,strong) NSString * 	TYPE	;//	行业类型
@property(nonatomic,strong) NSString * 	LINKNAME	;//	联系人
@property(nonatomic,strong) NSString * 	TEL	;//	电话
@property(nonatomic,strong) NSString * 	EMAIL	;//	邮件
@property(nonatomic,strong) NSString * 	COMMITTIME	;//	申请时间
@property(nonatomic,strong) NSString * 	REMARK	;//	备注

@end
