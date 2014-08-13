//
//  QueryOrderBackDetailInfoBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  退货查询明细模型
 */
@interface QueryOrderBackDetailInfoBean : NSObject

@property(nonatomic,strong) NSString *  BATCH;     // 日期批次
@property(nonatomic,strong) NSString *	PROD_NAME; // 产品名称
@property(nonatomic,strong) NSString *	ITEM_NUM;  // 产品数量
@property(nonatomic,strong) NSString *	UNITNAME;  // 产品单位
@property(nonatomic,strong) NSString *	REMARK;    // 退单原因
@property(nonatomic,strong) NSString *	SPEC;      // 规格
@property(nonatomic,strong) NSNumber *	ORDER_ID; // 订单标识
@property(nonatomic,strong) NSNumber * ITEM_ID;// 主键ID

-(void)save;

@end
