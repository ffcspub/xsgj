//
//  CustTypeBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-10.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustTypeBean : NSObject

@property(nonatomic,assign) int TYPE_ID;//类型ID
@property(nonatomic,assign) int TYPE_PID;//类型父ID
@property(nonatomic,strong) NSString * TYPE_NAME;//类型名称

@end
