//
//  BNPartnerType.h
//  xsgj
//
//  Created by ilikeido on 14-7-26.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNPartnerType : NSObject

@property (nonatomic,assign)    int 	TYPE_ID	;//	类别id
@property (nonatomic,strong)    NSString* 	TYPE_NAME	;//	类别名
@property (nonatomic,assign)    int 	TYPE_PID;//类别父id
@property (nonatomic,assign)    int 	ORDER_NO;//排序编号

@end
