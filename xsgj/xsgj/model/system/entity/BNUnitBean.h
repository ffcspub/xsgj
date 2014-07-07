//
//  BNUnitBean.h
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNUnitBean : NSObject

// 产品ID
@property (nonatomic,assign)    int PROD_ID;
// 产品单位名称
@property (nonatomic,strong)      NSString* UNITNAME;
// 产品价格
@property (nonatomic,assign)    double PROD_PRICE;
// 单位ID
@property (nonatomic,assign)    int PRODUCT_UNIT_ID;
// 父级单位ID
@property (nonatomic,assign)    int TB__PRODUCT_UNIT_ID;
// 顺序
@property (nonatomic,assign)    int UNIT_ORDER;

@end
