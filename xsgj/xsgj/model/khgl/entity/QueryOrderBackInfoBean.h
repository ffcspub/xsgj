//
//  QueryOrderBackInfoBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryOrderBackInfoBean : NSObject

@property(nonatomic,assign) int ORDER_ID;//退单ID
@property(nonatomic,strong) NSString *CUST_NAME;//客户名称
@property(nonatomic,strong) NSString *COMMITTIME;//退单时间
@property(nonatomic,strong) NSString *PROD_NAME;//产品名称

@end
