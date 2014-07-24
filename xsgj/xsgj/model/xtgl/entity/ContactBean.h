//
//  ContactBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactBean : NSObject

@property(nonatomic,assign) int USER_ID	;            //	用户标识
@property(nonatomic,strong) NSString *	USER_NAME	;//	用户名称
@property(nonatomic,strong) NSString *	REALNAME	;//	姓名
@property(nonatomic,strong) NSString *	MOBILENO	;//	手机号码
@property(nonatomic,strong) NSString *	ROLE_NAME	;//	角色名称
@property(nonatomic,strong) NSString *	DEPT_NAME	;//	部门名称
@property(nonatomic,strong) NSString * DEPT_ID;         // 部门ID
@property(nonatomic,strong) NSString * PHOTO;           //头像

@property(nonatomic,strong) NSString * USER_NAME_PINYIN;// 姓名拼音
@property(nonatomic,strong) NSString * USER_NAME_HEAD;  // 姓名首字母


@end
