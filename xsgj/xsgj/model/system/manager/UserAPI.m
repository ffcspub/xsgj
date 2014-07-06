//
//  UserManager.m
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "UserAPI.h"
#import "LK_API.h"
#import "UserHttpRequest.h"
#import "UserHttpResponse.h"

#define URL_USERLOGIN @"login/loginCheck.shtml"

@implementation UserAPI

+(void)loginByCorpcode:(NSString *)corpcode username:(NSString *)username password:(NSString *)password  success:(void(^)(UserInfo *userinfo))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;{
    UserLoginHttpRequest *request = [[UserLoginHttpRequest alloc]init];
    
    [LK_APIUtil postHttpRequest:request apiPath:URL_USERLOGIN Success:^(LK_HttpBaseResponse *response) {
        
        //-----test
        success(nil);
        return ;
        
        
        if ([DEFINE_SUCCESSCODE isEqual:response.message.messagecode]) {
            UserLoginHttpResponse *tResponse = (UserLoginHttpResponse *)response;
            success(tResponse.userInfo);
        }else{
            fail(NO,response.message.messagecontent);
        }
    } fail:^(BOOL NotReachable, NSString *descript) {
        fail(NotReachable,descript);
    } class:[UserLoginHttpResponse class]];
}

@end
