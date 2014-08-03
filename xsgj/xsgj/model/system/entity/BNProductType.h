//
//  BNProductType.h
//  产品类别
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNProductType : NSObject

// 类别ID
@property (nonatomic,assign)    int CLASS_ID;
// 类别父PID
@property (nonatomic,assign)    int CLASS_PID;
// 类别名称
@property (nonatomic,strong)      NSString* CLASS_NAME;
// 类别排序
@property (nonatomic,assign)    int ORDER_NO;

+(NSString *)getOwnerAndChildTypeIds:(int)typeid;

@end
