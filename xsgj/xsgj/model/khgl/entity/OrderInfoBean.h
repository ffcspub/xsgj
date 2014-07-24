//
//  OrderInfoBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfoBean : NSObject

@property(nonatomic,strong) NSString *	DEPT_NAME	;//	部门名称
@property(nonatomic,strong) NSString *	USER_NAME	;//	人员名称
@property(nonatomic,strong) NSString *	MOBILENO	;//	手机号码
@property(nonatomic,strong) NSString *	REALNAME	;//	姓名
@property(nonatomic,strong) NSNumber *	TOTAL_PRICE	;//	订单总价
@property(nonatomic,assign) int         ORDER_ID	;//	订单ID
@property(nonatomic,strong) NSString *	COMMITTIME	;//	上报时间
@property(nonatomic,strong) NSString *	CREATETIME	;//	创建时间
@property(nonatomic,strong) NSString *	CUST_NAME	;//	订货客户

@end
