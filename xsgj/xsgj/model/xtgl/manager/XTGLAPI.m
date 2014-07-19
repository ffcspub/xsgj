//
//  XTGLAPI.m
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "XTGLAPI.h"
#import "LK_API.h"
#import "ServerConfig.h"

@implementation XTGLAPI


/**
 *  按部门或部门分配加载相关全部部门信息数据
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)getUserALlDeptByRequest:(GetUserAllDeptHttpRequest *)request success:(void(^)(GetUserAllDeptHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_CONTACT_DEPT Success:^(LK_HttpBaseResponse *response) {
        success((GetUserAllDeptHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetUserAllDeptHttpResponse class]];
}

/**
 *  用户通讯录信息查询
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryContactsByRequest:(QueryContactsHttpRequest *)request success:(void(^)(QueryContactsHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_ADDRESS_BOOK Success:^(LK_HttpBaseResponse *response) {
        success((QueryContactsHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryContactsHttpResponse class]];
}

/**
 *  公告查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryNoticeByRequest:(QueryNoticeHttpRequest *)request success:(void(^)(QueryNoticeHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_ANNOUNCEMENT Success:^(LK_HttpBaseResponse *response) {
        success((QueryNoticeHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryNoticeHttpResponse class]];
}

/**
 *  公告查询详情接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)noticeDetailByRequest:(NoticeDetailHttpRequest *)request success:(void(^)(NoticeDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_ANNOUNCEMENT_DETAIL Success:^(LK_HttpBaseResponse *response) {
        success((NoticeDetailHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[NoticeDetailHttpResponse class]];
}

/**
 *  公告类型读取接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)noticeTypesByRequest:(NoticeTypesHttpRequest *)request success:(void(^)(NoticeTypesHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_ANNOUNCEMENT_TYPE Success:^(LK_HttpBaseResponse *response) {
        success((NoticeTypesHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[NoticeTypesHttpResponse class]];
}


/**
 *  修改密码接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)updatePwdByRequest:(UpdataPwdHttpRequest *)request success:(void(^)(UpdatePwdHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_updatePwd Success:^(LK_HttpBaseResponse *response) {
        success((UpdatePwdHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[UpdatePwdHttpResponse class]];
}

/**
 *  忘记密码接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)forgetPwdByRequest:(ForgetPwdHttpRequest *)request success:(void(^)(ForgetPwdHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_forgetPwd Success:^(LK_HttpBaseResponse *response) {
        success((ForgetPwdHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ForgetPwdHttpResponse class]];
}

/**
 *  企业申请接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)addApplyCorpHttpRequest:(AddApplyCorpHttpRequest *)request success:(void(^)(AddApplyCorpHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_addApplyCorp Success:^(LK_HttpBaseResponse *response) {
        success((AddApplyCorpHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[AddApplyCorpHttpResponse class]];
}
@end
