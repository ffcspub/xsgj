//
//  DeptInfoBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeptInfoBean : NSObject

@property(nonatomic,assign) int DEPT_ID;//部门标识
@property(nonatomic,assign) int DEPT_PID;//部门父标识
@property(nonatomic,strong) NSString *DEPT_NAME;//部门名称

@end
