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

#define URL_USERLOGIN @"loginCheck.shtml"


@implementation SystemAPI

+(void)loginByCorpcode:(NSString *)corpcode username:(NSString *)username password:(NSString *)password  success:(void(^)(BNUserInfo *userinfo))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;{
    NSString *rsapassword = [[CRSA shareInstance]encryptByRsa:password withKeyType:KeyTypePublic];
    UserLoginHttpRequest *request = [[UserLoginHttpRequest alloc]init];
    request.CORP_CODE = corpcode;
    request.USER_NAME = username;
    request.USER_PASS = rsapassword;
    [LK_APIUtil postHttpRequest:request apiPath:URL_USERLOGIN Success:^(LK_HttpBaseResponse *response) {
    
        if ([DEFINE_SUCCESSCODE isEqual:response.message.messagecode]) {
            UserLoginHttpResponse *tResponse = (UserLoginHttpResponse *)response;
            success(tResponse.USERINFO);
        }else{
            fail(NO,response.message.messagecontent);
        }
    } fail:^(BOOL NotReachable, NSString *descript) {
        fail(NotReachable,descript);
    } class:[UserLoginHttpResponse class]];
}

@end
