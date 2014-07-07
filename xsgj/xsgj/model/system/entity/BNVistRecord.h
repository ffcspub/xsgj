//
//  BNVistRecord.h
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNVistRecord : NSObject

// 拜访uuid
@property (nonatomic,strong)      NSString* VISIT_NO;
/**
 * 客户ID
 */
@property (nonatomic,assign)    int  CUST_ID;

/**
 * 客户姓名
 */
@property (nonatomic,strong)      NSString* CUST_NAME;

/**
 * 拜访时间
 */
@property (nonatomic,strong)      NSString* BEGIN_TIME;

/**
 * 起始纬度
 */
@property (nonatomic,assign)    double BEGIN_LAT;

/**
 * 起始经度
 */
@property (nonatomic,assign)    double BEGIN_LNG;

/**
 * 起始地址
 */
@property (nonatomic,strong)      NSString* BEGIN_POS;

/**
 * 纠偏起始纬度
 */
@property (nonatomic,assign)    double BEGIN_LAT2;

/**
 * 纠偏起始经度
 */
@property (nonatomic,assign)    double BEGIN_LNG2;

/**
 * 纠偏起始地址
 */
@property (nonatomic,strong)      NSString* BEGIN_POS2;


/**
 * 结束时间
 */
@property (nonatomic,strong)      NSString* END_TIME;

/**
 * 结束纬度
 */
@property (nonatomic,assign)    double END_LAT;

/**
 * 结束经度
 */
@property (nonatomic,assign)    double END_LNG;

/**
 * 结束位置
 */
@property (nonatomic,strong)      NSString* END_POS;

/**
 * 纠偏结束纬度
 */
@property (nonatomic,assign)    double END_LAT2;

/**
 * 纠偏结束经度
 */
@property (nonatomic,assign)    double END_LNG2;

/**
 * 纠偏结束地址
 */
@property (nonatomic,strong)      NSString* END_POS2;

@property (nonatomic,assign)    int  VISIT_TYPE;

@property (nonatomic,strong)      NSString* VISIT_CONDITION_CODE;

@property (nonatomic,strong)      NSString* VISIT_CONDITION_NAME;

@property (nonatomic,strong)      NSString* VISIT_DATE;

@property (nonatomic,assign)    int  SYNC_STATE;
/** 登录时返回的SESSION_ID */
@property (nonatomic,strong)      NSString* SESSION_ID;
/** 企业标识 */
@property (nonatomic,assign)    int  CORP_ID;
/** 部门标识 */
@property (nonatomic,assign)    int  DEPT_ID;
/** 用户标识 */
@property (nonatomic,assign)    int  USER_ID;
/** 用户数据权限 */
@property (nonatomic,strong)      NSString* USER_AUTH;
@end
