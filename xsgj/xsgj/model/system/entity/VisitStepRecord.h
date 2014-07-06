//
//  VisitStepRecord.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisitStepRecord : NSObject

@property(nonatomic,strong) NSString *visitNo;//拜访记录uuid
@property(nonatomic,strong) NSString *operMenu;//菜单id
@property(nonatomic,strong) NSString *operNum;//操作次数

@end
