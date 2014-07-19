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
