//
//  OAChineseToPinyin.h
//  MobileOA
//
//  Created by lin jian on 13-3-19.
//
//

#import <Foundation/Foundation.h>

#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"
@interface OAChineseToPinyin : NSObject

+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string;

@end
