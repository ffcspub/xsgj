//
//  OrderBackDetailBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderBackDetailBean : NSObject

@property(nonatomic,assign) int         PROD_ID	;//	产品id
@property(nonatomic,assign) int         PRODUCT_UNIT_ID	;//	单位
@property(nonatomic,assign) int         ITEM_NUM	;//	退货数量
@property(nonatomic,strong) NSString *	REMARK	;//	退货原因
@property(nonatomic,strong) NSString *	BATCH	;//	批次
@property(nonatomic,strong) NSString *  SPEC;
@property(nonatomic,strong) NSString *  PRODUCT_UNIT_NAME;
@property(nonatomic,strong) NSString *  PRODUCT_NAME;
@property(nonatomic,strong) NSString *  PHOTO1;

@end
