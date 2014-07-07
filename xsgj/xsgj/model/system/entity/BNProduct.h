//
//  BNProduct.h
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNProduct : NSObject
// 产品ID
@property (nonatomic,assign)    int PROD_ID;
// 产品名称
@property (nonatomic,strong)      NSString* PROD_NAME;
// 类别ID
@property (nonatomic,assign)    int CLASS_ID;
// 产品单元<内为BNUnitBean类型>
@property (nonatomic,strong)      NSArray*  UNIT_BEANS;

@end
