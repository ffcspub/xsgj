//
//  NSDate+Util.h
//  xsgj
//
//  Created by ilikeido on 14-7-14.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)

-(NSInteger)getWeekDay;

-(NSString *)getCnWeek;

+(NSDate *)getNextDate:(int)dateCount;

@end
