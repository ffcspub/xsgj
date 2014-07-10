//
//  UserManager.m
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SystemAPI.h"
#import "LK_API.h"
#import "SystemHttpRequest.h"
#import "SystemHttpResponse.h"
#import "CRSA.h"
#import "ServerConfig.h"
#import "NSObject+EasyCopy.h"


@implementation SystemAPI



+(void)loginByCorpcode:(NSString *)corpcode username:(NSString *)username password:(NSString *)password  success:(void(^)(BNUserInfo *userinfo))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;{
    NSString *rsapassword = [[CRSA shareInstance]encryptByRsa:password withKeyType:KeyTypePublic];
    UserLoginHttpRequest *request = [[UserLoginHttpRequest alloc]init];
    request.CORP_CODE = corpcode;
    request.USER_NAME = username;
    request.USER_PASS = rsapassword;
    [LK_APIUtil getHttpRequest:request apiPath:URL_LOGIN Success:^(LK_HttpBaseResponse *response) {
        if ([DEFINE_SUCCESSCODE isEqual:response.MESSAGE.MESSAGECODE]) {
            UserLoginHttpResponse *tResponse = (UserLoginHttpResponse *)response;
            [ShareValue shareInstance].userId = [NSNumber numberWithInt:tResponse.USERINFO.USER_ID];
            [ShareValue shareInstance].userInfo = tResponse.USERINFO;
            [tResponse saveCacheDB];
            success(tResponse.USERINFO);
        }else{
            fail(NO,response.MESSAGE.MESSAGECONTENT);
        }
    } fail:^(BOOL NotReachable, NSString *descript) {
        fail(NotReachable,descript);
    } class:[UserLoginHttpResponse class]];
}

+(void)updateConfigSuccess:(void(^)())Success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    UpdateConfigHttpRequest *request = [[UpdateConfigHttpRequest alloc]init];
    BNUserInfo *userInfo = [[BNUserInfo alloc]init];
    [[ShareValue shareInstance].userInfo easyDeepCopy:userInfo];
    request.USER_INFO_BEAN = userInfo;
    NSNumber *lastupdatetime = [[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"LASTUPDATE_%D",[ShareValue shareInstance].userInfo.USER_ID]];
//    if (!lastupdatetime) {
        lastupdatetime = @0;
//    }
    request.USER_INFO_BEAN.LAST_UPDATE_TIME = [lastupdatetime unsignedLongLongValue];
    [LK_APIUtil getHttpRequest:request apiPath:URL_UPDATE_CONFIG Success:^(LK_HttpBaseResponse *response) {
        if ([DEFINE_SUCCESSCODE isEqual:response.MESSAGE.MESSAGECODE]) {
            UpdateConfigHttpResponse *tResponse = (UpdateConfigHttpResponse *)response;
            [tResponse saveCacheDB];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithUnsignedLongLong:[ShareValue shareInstance].userInfo.LAST_UPDATE_TIME] forKey:[NSString stringWithFormat:@"LASTUPDATE_%D",[ShareValue shareInstance].userInfo.USER_ID]];
            Success();
        }else{
            fail(NO,response.MESSAGE.MESSAGECONTENT);
        }
    } fail:^(BOOL NotReachable, NSString *descript) {
        fail(NotReachable,descript);
    } class:[UpdateConfigHttpResponse class]];

    
    
}

@end
