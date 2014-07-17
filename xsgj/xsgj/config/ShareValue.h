//
//  ShareValue.h
//  jiulifang
//
//  Created by hesh on 13-11-6.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNUserInfo.h"
#import "UIColor+External.h"
#import "UIButton+Style.h"

#define VERSION 1

#define TABLEVERION 1.3

#define DEFINE_SUCCESSCODE @"00000000"

#define MCOLOR_GREEN HEX_RGB(0x4cd964)
#define MCOLOR_BLUE HEX_RGB(0x409BE4)
#define MCOLOR_ORGLE HEX_RGB(0xffd599)
#define MCOLOR_BLACK HEX_RGB(0x000000)
#define MCOLOR_GRAY  HEX_RGB(0x9ba6ae)
#define MCOLOR_ORGLE HEX_RGB(0xffd599)
#define MCOLOR_RED   HEX_RGB(0xf33D3A)

#define IMG_BTN_BLUE [[UIImage imageNamed:@"CommonBtn_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]

#define IMG_BTN_BLUE_S [[UIImage imageNamed:@"CommonBtn_press"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]

#define IMG_BTN_ORGLE [[UIImage imageNamed:@"bg_BtnLogin_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]

#define IMG_BTN_ORGLE_S [[UIImage imageNamed:@"bg_BtnLogin_press"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]

@interface ShareValue : NSObject


+(ShareValue *)shareInstance;

@property(nonatomic,strong) BNUserInfo *userInfo;

@property(nonatomic,assign) BOOL noRemberFlag;//记住密码
@property(nonatomic,assign) BOOL noAutoFlag;//自动登录
@property(nonatomic,assign) BOOL noShowPwd;//是否显示密码
@property(nonatomic,weak) NSString *corpCode;//企业编码
@property(nonatomic,weak) NSString *userName;//用户名
@property(nonatomic,weak) NSString *userPass;//登录类型
@property(nonatomic,weak) NSNumber *userId;//用户编号

@end
