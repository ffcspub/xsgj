//
//  BNCustomerInfo.h
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNVistRecord.h"

@interface BNCustomerInfo : NSObject
// 客户id
@property (nonatomic,assign)    int CUST_ID;
/**
 * 客户名称
 */
@property (nonatomic,strong)      NSString* CUST_NAME;
@property (nonatomic,strong)      NSString* SORT_KEY;
/**
 * 类型id
 */
@property (nonatomic,assign)    int TYPE_ID;
@property (nonatomic,strong)      NSString* TYPE_NAME;
/**
 * 区域id
 */
@property (nonatomic,assign)    int AREA_ID;

@property (nonatomic,strong)      NSString* AREA_NAME;

@property (nonatomic,assign)    int ORDER_NO;

/**
 * 联系人名称
 */
@property (nonatomic,strong)      NSString* LINKMAN;
/**
 * 联系电话
 */
@property (nonatomic,strong)      NSString* TEL;
/**
 * 客户所在位置的纬度
 */
@property (nonatomic,strong)    NSNumber * LAT;
/**
 * 客户所在位置的经度
 */
@property (nonatomic,strong)    NSNumber * LNG;
/**
 * 联系地址
 */
@property (nonatomic,strong)      NSString* ADDRESS;
/**
 * 照片地址
 */
@property (nonatomic,strong)      NSString* PHOTO;
/**
 * 备注
 */
@property (nonatomic,strong)      NSString* REMARK;

/** 登录时返回的SESSION_ID */
@property (nonatomic,strong)      NSString* SESSION_ID;
/** 企业标识 */
@property (nonatomic,assign)    int CORP_ID;
/** 部门标识 */
@property (nonatomic,assign)    int DEPT_ID;
/** 用户标识 */
@property (nonatomic,assign)    int USER_ID;
/** 用户数据权限 */
@property (nonatomic,strong)      NSString* USER_AUTH;
// 拜访记录
@property (nonatomic,strong)      BNVistRecord *VISIT_RECORD;
@end
