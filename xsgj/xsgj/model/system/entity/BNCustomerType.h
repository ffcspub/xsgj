//
//  BNCustomerType.h
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNCustomerType : NSObject
// 类型id
@property (nonatomic,assign)    int TYPE_ID;
// 类型父id
@property (nonatomic,assign)    int TYPE_PID;
// 类型名
@property (nonatomic,strong)      NSString* TYPE_NAME;
@end
