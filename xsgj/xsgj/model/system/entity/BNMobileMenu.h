//
//  BNMobileMenu.h
//  配置更新
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNMobileMenu : NSObject

// 菜单ID
@property (nonatomic,assign)  int MENU_ID;
// 菜单编码,与手机端的menu_Id对应
@property (nonatomic,assign)  int MENU_CODE;
//菜单图标
@property (nonatomic,strong)  NSString *ICON;
// 菜单名称
@property (nonatomic,strong)  NSString* MENU_NAME;
// 排序
@property (nonatomic,assign)  int ORDER_NO;
// 是否必填 1:必填 0:选填
@property (nonatomic,strong)  NSString* REQUIRED;
// 菜单状态 1:显示 0:隐藏
@property (nonatomic,assign)  int STATE;
// 父菜单
@property(nonatomic,assign) int PARENT_ID;

-(void)save;

@end
