//
//  NSDiction+External.h
//  AFNETTEST
//
//  Created by hesh on 13-8-22.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LK_NSDictionary2Object)

-(id)objectByClass:(Class)clazz;

@end

@interface NSObject (LK_NSDictionary2Object)

-(NSDictionary *)lkDictionary;

@end
