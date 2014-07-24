//
//  MobileInfoDisBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-25.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileInfoDisBean : NSObject

@property(nonatomic,strong) NSString *	DISTRIBUTION_ID;	;//	配送id
@property(nonatomic,strong) NSString *	DATE_ID;	;//	配送单号
@property(nonatomic,strong) NSString *	CUST_NAME;	;//	收件人
@property(nonatomic,strong) NSString *	ADDRESS;	;//	配送地址
@property(nonatomic,strong) NSString *	LINKMAN;	;//	联系人
@property(nonatomic,strong) NSString *	PHONE;	;//	联系电话
@property(nonatomic,strong) NSString *	STATE;	;//	订单状态id
@property(nonatomic,strong) NSString *	YY_TIME;	;//	预约时间
@property(nonatomic,strong) NSString *	PROD_NAME;	;//	配送产品
@property(nonatomic,strong) NSString *	REMARK;	;//	备注

@end
