//
//  VisitPlan.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisitPlan : NSObject

@property(nonatomic,strong) NSString *weekday;//星期几
@property(nonatomic,strong) NSString *custId;//客户id
@property(nonatomic,strong) NSString *orderId;//排序编号
@property(nonatomic,strong) NSString *lineId;//线路id
@property(nonatomic,strong) NSString *corpId;//企业id
@property(nonatomic,strong) NSString *checkState;//审核状态 0:未审核 1:通过 2:未通过 3:申请删除
@property(nonatomic,strong) NSString *userId;//用户id

@end
