//
//  OrderItemBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItemBean : NSObject

@property(nonatomic,assign) int	PROD_ID	;//	产品标识
@property(nonatomic,assign) int	PRODUCT_UNIT_ID	;//	产品单位表ID
@property(nonatomic,assign) double ITEM_PRICE	;//	产品单价
@property(nonatomic,assign) int	ITEM_NUM	;//	订货数量
@property(nonatomic,assign) double	TOTAL_PRICE	;//	订货总价
@property(nonatomic,strong) NSString *	GIFT_NAME;//赠品名
@property(nonatomic,strong) NSString *	UNIT_NAME;
@property(nonatomic,strong) NSString *	SPEC;//产品规格
@property(nonatomic,strong) NSString *	PROD_NAME;
@property(nonatomic,strong) NSString *	GIFT_UNIT_NAME;//赠品单位
@property(nonatomic,assign) NSString * GIFT_TOTAL;//赠品总价
@property(nonatomic,assign) NSString * GIFT_PRICE;//赠品金额
@property(nonatomic,assign) NSString * GIFT_NUM;//赠品总价

@end
