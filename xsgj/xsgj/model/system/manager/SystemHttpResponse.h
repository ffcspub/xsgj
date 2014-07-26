//
//  UserHttpResponse.h
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpResponse.h"
#import "BNUserInfo.h"
#import "TimeIntervalBean.h"

@interface UserLoginHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) BNUserInfo *USERINFO;

-(void)saveCacheDB;

@end


@interface UpdateConfigHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSArray *	MOBILE_MENUS	;//	手机功能菜单
@property(nonatomic,strong) NSArray *	PRODUCT_TYPES	;//	产品类别
@property(nonatomic,strong) NSArray *	PRODUCT_UNITS	;//	产品单位
@property(nonatomic,strong) NSArray *	PRODUCTS	;//	产品信息
@property(nonatomic,strong) NSArray *	CUSTOMER_TYPES	;//	客户类型
@property(nonatomic,strong) NSArray *	AREAS	;//	区域
@property(nonatomic,strong) NSArray *	CUSTOMERS	;//	客户信息
@property(nonatomic,strong) NSArray *	VISIT_CONDITIONS	;//	拜访情况
@property(nonatomic,strong) NSArray *	VISIT_PLANS	;//	拜访计划
@property(nonatomic,strong) NSArray *	VISIT_RECORDS	;//	拜访记录
@property(nonatomic,strong) NSArray *	VISIT_STEP_RECORDS	;//	拜访步骤记录
@property(nonatomic,strong) NSArray *	DISPLAY_TYPES	;//	陈列类型
@property(nonatomic,strong) NSArray *	ASSET_TYPES	;//	资产类型
@property(nonatomic,strong) NSArray *	DISPLAY_CASES	;//	陈列情况
@property(nonatomic,strong) NSArray *	DISPLAY_SHAPES	;//	陈列形式
@property(nonatomic,strong) NSArray *	SIGN_CONFIGS	;//	考勤配置
@property(nonatomic,strong) NSArray *   CAMERA_TYPES;//拍照类型

@property(nonatomic,assign) int	MENU_UPDATE_STATE	;//	手机菜单是否有更新
@property(nonatomic,assign) int	PRODUCT_TYPE_UPDATE_STATE	;//	产品类别是否有更新
@property(nonatomic,assign) int	PRODUCT_UNIT_UPDATE_STATE	;//	产品单位是否有更新
@property(nonatomic,assign) int	PRODUCT_UPDATE_STATE	;//	产品是否有更新
@property(nonatomic,assign) int	CUSTOMER_TYPE_UPDATE_STATE	;//	客户类型是否有更新
@property(nonatomic,assign) int	AREA_UPDATE_STATE	;//	区域是否有更新
@property(nonatomic,assign) int	CUSTOMER_UPDATE_STATE	;//	客户是否有更新
@property(nonatomic,assign) int	VISIT_CONDITION_UPDATE_STATE	;//	拜访情况是否有更新
@property(nonatomic,assign) int	VISIT_PLAN_UPDATE_STATE	;//	拜访计划是否有更新
@property(nonatomic,assign) int	DISPLAY_TYPE_UPDATE_STATE	;//	陈列类型是否有更新
@property(nonatomic,assign) int	ASSET_TYPE_UPDATE_STATE	;//	资产类型是否有更新
@property(nonatomic,assign) int	DISPLAY_CASE_UPDATE_STATE	;//	陈列情况是否有更新
@property(nonatomic,assign) int	DISPLAY_SHAPE_UPDATE_STATE	;//	陈列形式是否有更新
@property(nonatomic,assign) int SIGN_CONFIG_UPDATE_STATE;//考勤配置是否有更新
@property(nonatomic,assign) int CAMERA_TYPE_UPDATE_STATE;//拍照类型是否有更新

-(void)saveCacheDB;

@end

@interface LocateCommitHttpResponse : LK_HttpBaseResponse

@end


@interface UploadPhotoHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSString *FILE_ID;//照片标识

@end

@interface GetWorkRangeHttpResponse : LK_HttpBasePageResponse

@end

@interface GetTimeIntervalHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong)TimeIntervalBean *TIMEINTERVALBEAN;//

@end

@interface  InsertMobileStateHttpResponse : LK_HttpBaseResponse

@end

