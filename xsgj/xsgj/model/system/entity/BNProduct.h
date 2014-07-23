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

@property (nonatomic,strong) 	NSString *PROD_CODE;//产品编码

@property (nonatomic,strong) 	NSString *BARCODE;//产品条形码

@property (nonatomic,strong) 	NSString *SPEC;//全名

@end
