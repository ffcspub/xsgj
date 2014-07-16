//
//  xsgjTests.m
//  xsgjTests
//
//  Created by ilikeido on 14-7-4.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LK_API.h"
#import "SystemAPI.h"
#import "SystemHttpRequest.h"
#import "SystemHttpResponse.h"
#import "XZGLAPI.h"
#import "XZGLHttpRequest.h"
#import "XZGLHttpResponse.h"
#import "SignDetailBean.h"

@interface xsgjTests : XCTestCase


@end

@implementation xsgjTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//测试登录界面接口
- (void)testLoginByCorpcode
{
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    //界面发起登录请求
    [SystemAPI loginByCorpcode:@"zlbzb" username:@"linwei" password:@"123456" success:^(BNUserInfo *userinfo) {
        //成功后更新配置文件
        [SystemAPI updateConfigSuccess:^{
        } fail:^(BOOL notReachable, NSString *desciption) {
        }];
    } fail:^(BOOL notReachable, NSString *desciption) {
    }];
    [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:20]];
}

//测试考勤详情接口
-(void)testDetailAttendance{
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
//    ApplyLeaveHttpRequest *request = [[ApplyLeaveHttpRequest alloc]init];
    DetailAttendanceHttpRequest *request = [[DetailAttendanceHttpRequest alloc]init];
    [XZGLAPI detailAttendanceByRequest:request success:^(DetailAttendanceHttpResponse *response) {
    for (SignDetailBean *infoBean in response.DATA) {
    NSLog(@"%@,%@",infoBean.DEPT_NAME,infoBean.USER_NAME );
    }
    } fail:^(BOOL notReachable, NSString *desciption) {
   
    }];
    [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:20]];
}

@end
