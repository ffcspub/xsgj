//
//  CustDetailBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustDetailBean : NSObject

@property(nonatomic,assign) int     CUST_ID	;//	客户标识
@property(nonatomic,strong) NSString * 	CUST_NAME	;//	客户名称
@property(nonatomic,assign) int     TYPE_ID	;//	类型标识
@property(nonatomic,strong) NSString * 	TYPE_NAME	;//	类型名称
@property(nonatomic,strong) NSString * 	LINKMAN	;//	联系人
@property(nonatomic,strong) NSString * 	TEL	;//	联系电话
@property(nonatomic,strong) NSString * 	ADDRESS	;//	地址
@property(nonatomic,strong) NSString * 	LASTEST_VISIT	;//	最近拜访日期
@property(nonatomic,strong) NSString * 	REMARK	;//	备注
@property(nonatomic,strong) NSString * 	PHOTO	;//	拍照
@property(nonatomic,strong) NSString * 	LNG	;//	经度
@property(nonatomic,strong) NSString * 	LAT	;//	纬度

@end
