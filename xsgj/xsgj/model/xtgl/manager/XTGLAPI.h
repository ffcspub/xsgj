//
//  XTGLAPI.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTGLHttpRequest.h"
#import "XTGLHttpResponse.h"

@interface XTGLAPI : NSObject

/**
 *  按部门或部门分配加载相关全部部门信息数据
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)getUserALlDeptByRequest:(GetUserAllDeptHttpRequest *)request success:(void(^)(GetUserAllDeptHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  用户通讯录信息查询
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryContactsByRequest:(QueryContactsHttpRequest *)request success:(void(^)(QueryContactsHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  公告查询接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)queryNoticeByRequest:(QueryNoticeHttpRequest *)request success:(void(^)(QueryNoticeHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  公告查询详情接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)noticeDetailByRequest:(NoticeDetailHttpRequest *)request success:(void(^)(NoticeDetailHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  公告类型读取接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)noticeTypesByRequest:(NoticeTypesHttpRequest *)request success:(void(^)(NoticeTypesHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;

/**
 *  修改密码接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)updatePwdByRequest:(UpdataPwdHttpRequest *)request success:(void(^)(UpdatePwdHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;


@end
