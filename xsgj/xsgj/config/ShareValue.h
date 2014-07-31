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
#import <CoreLocation/CoreLocation.h>

#define VERSION 1

#define TABLEVERION 1.3

#define NOTIFICATION_SELECTPRODUCT_FIN @"NOTIFICATION_SELECTPRODUCT_FIN"
#define NOTIFICATION_SELECT_FIN @"NOTIFICATION_SELECT_FIN"

#define DEFINE_SUCCESSCODE @"00000000"

#define NumberAndCharacters @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\n" // 限制字符和数字

#define MCOLOR_GREEN HEX_RGB(0x4cd964)
#define MCOLOR_BLUE HEX_RGB(0x409BE4)
#define MCOLOR_ORGLE HEX_RGB(0xffd599)
#define MCOLOR_BLACK HEX_RGB(0x000000)
#define MCOLOR_GRAY  HEX_RGB(0x9ba6ae)
#define MCOLOR_ORGLE HEX_RGB(0xffd599)
#define MCOLOR_RED   HEX_RGB(0xf33D3A)

#define IMG_BTN_BLUE [[UIImage imageNamed:@"CommonBtn_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]

#define IMG_BTN_BLUE_S [[UIImage imageNamed:@"CommonBtn_press"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]

#define IMG_BTN_BLUE_D [[UIImage imageNamed:@"CommonBtn_disable"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]

#define IMG_BTN_ORGLE [[UIImage imageNamed:@"bg_BtnLogin_nor"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]

#define IMG_BTN_ORGLE_S [[UIImage imageNamed:@"bg_BtnLogin_press"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]

/**
 *  输入类文本标题的颜色设置
 */
#define COLOR_INPUT_TITLE       HEX_RGB(0x939a9d)
#define FONT_SIZE_INPUT_TITLE   15.f
#define COLOR_INPUT_CONTENT     HEX_RGB(0x000000)
#define FONT_SIZE_INPUT_CONTENT 13.f
#define COLOR_DETAIL_CONTENT    HEX_RGB(0x5C6871)
#define FONT_SIZE_DETAIL_CONTENT 15.f

@interface ShareValue : NSObject{
   
}

+(UIImage *)tablePart1;
+(UIImage *)tablePart2;
+(UIImage *)tablePart3;

+(UIImage *)tablePart1S;
+(UIImage *)tablePart2S;
+(UIImage *)tablePart3S;

//获取文件id对应的图片
+(NSString *)getFileUrlByFileId:(NSString *)fileId;

+(ShareValue *)shareInstance;

@property(nonatomic,strong) BNUserInfo *userInfo;

@property(nonatomic,assign) BOOL noRemberFlag;//记住密码
@property(nonatomic,assign) BOOL noAutoFlag;//自动登录
@property(nonatomic,assign) BOOL noShowPwd;//是否显示密码
@property(nonatomic,weak) NSString *corpCode;//企业编码
@property(nonatomic,weak) NSString *userName;//用户名
@property(nonatomic,weak) NSString *userPass;//登录类型
@property(nonatomic,weak) NSNumber *userId;//用户编号

@property(nonatomic,assign) CLLocationCoordinate2D currentLocation;//当前经纬度
@property(nonatomic,strong) NSString *address;//当前地址

@property(nonatomic,assign) NSNumber *lastUpdateTime;//最后更新时间

////////////////////////////////////////////////////////////////////////////////////////////////////
// eg: 左侧为文本 右侧为文本输入框或者仅用户显示的文本
// ___________________________________________________________
// |           |                                             |
// |  prompt   |           textfield or label                |
// |___________|_____________________________________________|

+ (UIButton *)getDefaulBorder; // 用于输入或者展示信息时候，带有高亮状态 press.png && normal.png
+ (UIView *)getDefaultShowBorder; // 用于展示的边框，不带有高亮，左侧有类似于双划线的 bgNO2.png
+ (UIView *)getDefaultInputBorder; // 用于提醒输入的边框，不带有高亮，顶部有类似于双划线的 bgNO1.png

+ (UILabel *)getDefaultInputTitle;   // 左侧提示的文本
+ (UITextField *)getDefaultTextField;// 右侧用户输入的文本框
+ (UILabel *)getDefaultContent;      // 右侧用于显示信息的文本
+ (UILabel *)getDefaultDetailContent;// 用于显示明细的文本
+ (UILabel *)getStarMarkPrompt; // 提示必须输入

////////////////////////////////////////////////////////////////////////////////////////////////////

+ (BOOL)legalTextFieldInputWithLegalString:(NSString *)legalString checkedString:(NSString *)checkedString;

@end
