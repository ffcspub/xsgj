//
//  SaleTaskInfoBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-9.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaleTaskInfoBean : NSObject

@property(nonatomic,strong) NSString *	DEPT_NAME	;//	部门名称
@property(nonatomic,strong) NSString *	USER_NAME	;//	人员名称
@property(nonatomic,strong) NSString *	MOBILENO	;//	手机号码
@property(nonatomic,strong) NSString *	REALNAME	;//	姓名
@property(nonatomic,strong) NSString *	SALE_MONTH	;//	所在月份
@property(nonatomic,strong) NSString *  SALE_TARGET	;//	销售目标
@property(nonatomic,strong) NSString *  SALE_FINISH	;//	销售完成统计
@property(nonatomic,strong) NSString *	SALE_PERCENT	;//	销售完成百分比

@end
