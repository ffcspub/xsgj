//
//  UserHttpRequest.h
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpRequest.h"
#import "BNUserInfo.h"

@interface UserLoginHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *CORP_CODE;
@property(nonatomic,strong) NSString *USER_NAME;
@property(nonatomic,strong) NSString *USER_PASS;
@property(nonatomic,strong) NSString *LOGINTYPE;
@property(nonatomic,strong) NSString *DEVICE_CODE;

@end

@interface UpdateConfigHttpRequest: LK_HttpBaseRequest

@property(nonatomic,strong) BNUserInfo *USER_INFO_BEAN;
@property(nonatomic,assign) int UPDATE_TYPE;

@end

@interface LocateCommitHttpRequest : LK_HttpBaseRequest

@property(nonatomic,assign) int CORP_ID;
@property(nonatomic,assign) int USER_ID;
@property(nonatomic,assign) int LOC_WAY;
@property(nonatomic,strong) NSString *LOC_TYPE;
@property(nonatomic,strong) NSNumber *LNG;
@property(nonatomic,strong) NSNumber *LAT;
@property(nonatomic,strong) NSString *COMMITTIME;

@end


@interface UploadPhotoHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString * 	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int	CORP_ID	;//	企业ID
@property(nonatomic,assign) int	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int	USER_ID	;//	用户ID
@property(nonatomic,assign) int	CUST_ID	;//	客户标识
@property(nonatomic,strong) NSString * 	FILE_NAME	;//	拍照名称
@property(nonatomic,strong) NSString * 	FILE_ID	;//	文件ID
@property(nonatomic,strong) NSString * 	DATA	;//	拍照数据

@end

@interface  GetWorkRangeHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID

@end

@interface GetTimeIntervalHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID

@end
