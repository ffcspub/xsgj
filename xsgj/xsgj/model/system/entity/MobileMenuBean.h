//
//  MobileMenuBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileMenuBean : NSObject

@property(nonatomic,strong) NSString *menuId;//菜单id
@property(nonatomic,strong) NSString *menuCode;//菜单编码
@property(nonatomic,strong) NSString *menuName;//菜单名
@property(nonatomic,strong) NSString *orderNo;//排序编号
@property(nonatomic,strong) NSString *required;//主要用于拜访步骤菜单，标识该步骤是否必须进行，0表示非必须，1表示必须
@property(nonatomic,strong) NSString *state;//菜单状态，0表示隐藏，1表示显示
@property(nonatomic,strong) NSString *updatetime;//菜单更新时间

@end
