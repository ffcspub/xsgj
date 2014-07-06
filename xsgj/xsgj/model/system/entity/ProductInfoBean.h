//
//  ProductInfoBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfoBean : NSObject

@property(nonatomic,strong) NSString *prodId;//产品Id
@property(nonatomic,strong) NSString *prodName;//产品名称
@property(nonatomic,strong) NSString *classId;//类别id
@property(nonatomic,strong) NSString *prodCode;//产品编码
@property(nonatomic,strong) NSString *barCode;//产品条件码

@end
