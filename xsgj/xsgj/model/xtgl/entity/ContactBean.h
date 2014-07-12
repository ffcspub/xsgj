//
//  ContactBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactBean : NSObject

@property(nonatomic,assign) int USER_ID	;//	部门标识
@property(nonatomic,strong) NSString *	USER_NAME	;//	部门父标识
@property(nonatomic,strong) NSString *	REALNAME	;//	部门名称
@property(nonatomic,strong) NSString *	MOBILENO	;//	部门标识
@property(nonatomic,strong) NSString *	ROLE_NAME	;//	部门父标识
@property(nonatomic,strong) NSString *	DEPT_NAME	;//	部门名称

@end
