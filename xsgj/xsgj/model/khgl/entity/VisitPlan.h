//
//  VisitPlan.h
//  xsgj
//
//  Created by ilikeido on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisitPlan : NSObject

@property(nonatomic,strong) NSString *	CUST_ID	;//	客户id
@property(nonatomic,assign) int         USER_ID;//	用户id
@property(nonatomic,assign) int         CORP_ID;//	企业id
@property(nonatomic,assign) int     CHECK_STATE	;//	审批状态
@property(nonatomic,strong) NSString *	CHECK_REMARK;//	审批备注

@end
