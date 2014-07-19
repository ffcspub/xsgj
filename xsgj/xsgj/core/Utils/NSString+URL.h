//
//  NSString+URL.h
//  URL转义
//
//  Created by apple on 14-6-5.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)
// URL转义
- (NSString *)URLEncodedString;

// 字符串是否为空
- (BOOL)isEmptyOrWhitespace;

// 去除空格
- (NSString *)trimmedWhitespaceString;

// 取出回车
- (NSString *)trimmedWhitespaceAndNewlineString;

// 判断是是否为手机号
- (BOOL)isTelephone;

@end
