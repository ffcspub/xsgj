//
//  NSString+URL.m
//  URL转义
//
//  Created by apple on 14-6-5.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

// URL转义
- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingGB_18030_2000));
    return encodedString;
}

- (BOOL)isEmptyOrWhitespace
{
    return self == nil || !([self length] > 0) || [[self trimmedWhitespaceString] length] == 0;
}

- (NSString *)trimmedWhitespaceString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimmedWhitespaceAndNewlineString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end



