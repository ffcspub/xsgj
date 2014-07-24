//
//  SignConfigBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignConfigBean : NSObject

@property(nonatomic,assign) int BEGIN_TIME;//如：7：00输出为700；15：00输出为1500
@property(nonatomic,assign) int END_TIME;

@end
