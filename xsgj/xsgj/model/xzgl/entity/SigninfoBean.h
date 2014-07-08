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

@property(nonatomic,strong) NSString *deptName;//部门名称
@property(nonatomic,strong) NSString *userName;//人员名称
@property(nonatomic,strong) NSString *mobileNo;//手机号码
@property(nonatomic,strong) NSString *realName;//姓名
@property(nonatomic,strong) NSString *signTime;//上传时间
@property(nonatomic,strong) NSString *signTimes;//考勤次序
@property(nonatomic,strong) NSString *photo;//上传附件id
@property(nonatomic,strong) NSString *deviceCode;//imei
@property(nonatomic,strong) NSString *signFlag;//i:签到/o:签退

@end
