//
//  BNVisitPlan.h
//  fxtx
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNVisitPlan : NSObject
@property (nonatomic,assign)    int WEEKDAY;
@property (nonatomic,assign)    int CUST_ID;
@property (nonatomic,assign)    int ORDER_NO;
@property (nonatomic,assign)    int LINE_ID;//	线路id	Long
@property (nonatomic,assign)    int CORP_ID;//	企业id	Long
@property (nonatomic,assign)    int CHECK_STATE;//	审核状态0:未审核1:通过2:未通过3:申请删除	Integer
@property (nonatomic,assign)    int USER_ID;//	用户id	long
@end
