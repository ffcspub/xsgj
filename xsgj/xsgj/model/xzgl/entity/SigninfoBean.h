//
//  SigninfoBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

//考勤记录
@interface SigninfoBean : NSObject

@property(nonatomic,strong) NSString *	DEPT_NAME	;//	部门名称
@property(nonatomic,strong) NSString *	USER_NAME	;//	人员名称
@property(nonatomic,strong) NSString *	MOBILENO	;//	手机号码
@property(nonatomic,strong) NSString *	REALNAME	;//	姓名
@property(nonatomic,strong) NSString *  SIGN_TIME 	;//	上传时间
@property(nonatomic,assign) int         SIGN_TIMES	;//	考勤次序
@property(nonatomic,assign) int         PHOTO	;//	上传附件ID
@property(nonatomic,strong) NSString *	DEVICE_CODE	;//	IMEI
@property(nonatomic,strong) NSString *	SIGN_FLAG	;//	i:签到/o:签退


@end
