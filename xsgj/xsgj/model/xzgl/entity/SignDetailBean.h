//
//  SignDetailBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignDetailBean : NSObject

@property(nonatomic,strong) NSString *deptName;//部门名称
@property(nonatomic,strong) NSString *userName;//人员名称
@property(nonatomic,strong) NSString *mobileno;//手机号码
@property(nonatomic,strong) NSString *realname;//姓名
@property(nonatomic,strong) NSString *signTime;//上传时间
@property(nonatomic,strong) NSString *signTimes;//考勤次序
@property(nonatomic,strong) NSString *photo;//上传附件id
@property(nonatomic,strong) NSString *deviceCode;//imei
@property(nonatomic,strong) NSString *signFlag;//i:签到 o:签退
@property(nonatomic,strong) NSString *lng;//经度
@property(nonatomic,strong) NSString *lat;//纬度
@property(nonatomic,strong) NSString *postion;//地理位置
@property(nonatomic,strong) NSString *lng2;//纠偏经度
@property(nonatomic,strong) NSString *lat2;//纠偏纬度
@property(nonatomic,strong) NSString *postion2;//纠偏地理位置

@end
