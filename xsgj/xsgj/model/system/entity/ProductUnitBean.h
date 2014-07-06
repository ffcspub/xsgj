//
//  ProductUnitBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductUnitBean : NSObject

@property(nonatomic,strong) NSString *prodId;//产品id
@property(nonatomic,strong) NSString *unitName;//产品单位名称
@property(nonatomic,strong) NSString *prodPrice;//产品价格
@property(nonatomic,strong) NSString *prodUnitId;//单位id
@property(nonatomic,strong) NSString *tbProductUnitId;//父级单位id

@end
