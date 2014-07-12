//
//  QueryOrderBackDetailInfoBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryOrderBackDetailInfoBean : NSObject

@property(nonatomic,assign) int         ORDER_ID;//	退单ID
@property(nonatomic,strong) NSString *	PROD_NAME;//	产品名称
@property(nonatomic,strong) NSString *	ITEM_NUM;//	产品数量
@property(nonatomic,strong) NSString *	UNITNAME;//	产品单位
@property(nonatomic,strong) NSString *	REMARK;//	退单原因
@property(nonatomic,strong) NSString *	BATCH;//	批次

@end
