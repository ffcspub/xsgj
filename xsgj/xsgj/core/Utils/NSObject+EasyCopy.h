//
//  NSObject+EasyCopy.h
//  AFNETTEST
//
//  Created by hesh on 13-8-26.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (EasyCopy)

-(void)easyShallowCopy:(NSObject *)object;

-(void)easyDeepCopy:(NSObject *)object;

@end
