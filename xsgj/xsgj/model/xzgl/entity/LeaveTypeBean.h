//
//  LeaveTypeBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeaveTypeBean : NSObject

@property(nonatomic,strong) NSString *TYPE_NAME ;//调休类型名称
@property(nonatomic,assign) int TYPE_ID;//调休类型id

-(void)save;

@end
