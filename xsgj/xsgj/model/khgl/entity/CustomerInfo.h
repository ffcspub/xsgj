//
//  CustomerInfo.h
//  xsgj
//
//  Created by ilikeido on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerInfo : NSObject

@property(nonatomic,assign) int         CUST_ID	;//	客户id
@property(nonatomic,strong) NSString *	CUST_NAME	;//	客户姓名
@property(nonatomic,assign) int         TYPE_ID;//	类型id
@property(nonatomic,assign) int         AREA_ID;//	区域id
@property(nonatomic,strong) NSString *	LINKMAN	;//	联系人
@property(nonatomic,strong) NSString *	TEL	;//	电话
@property(nonatomic,strong) NSNumber *	LAT	;//	纬度
@property(nonatomic,strong) NSNumber *	LNG	;//	经度
@property(nonatomic,strong) NSString *	ADDRESS	;//	地址
@property(nonatomic,strong) NSString *	PHOTO	;//	照片id
@property(nonatomic,strong) NSString *	REMARK	;//	备注
@property(nonatomic,assign) int	CHECK_STATE	;//	审核状态
@property(nonatomic,strong) NSString *	CHECK_REMARK	;//	审核备注


-(NSString *)applyStateName;//获取申请类型

-(NSString *)stateName;

-(void)setOldCheckState:(int)oldCheckState;//设计旧审核状态

-(int) oldCheckState;//原审核状态

-(void)setOfflineState:(BOOL)isOffline;

-(BOOL)isOffline;


@end
