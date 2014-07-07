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
@end



