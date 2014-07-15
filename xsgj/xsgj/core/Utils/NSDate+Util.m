//
//  NSDate+Util.m
//  xsgj
//
//  Created by ilikeido on 14-7-14.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)

-(NSString *)getCnWeek{
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
                       fromDate:self];
    NSString *weekString  = nil;
    NSInteger week = [comps weekday];
    switch (week) {
        case 1:
            weekString = @"星期日";
            break;
        case 2:
            weekString = @"星期一";
            break;
        case 3:
            weekString = @"星期二";
            break;
        case 4:
            weekString = @"星期三";
            break;
        case 5:
            weekString = @"星期四";
            break;
        case 6:
            weekString = @"星期五";
            break;
        case 7:
            weekString = @"星期六";
            break;
        default:
            break;
    }
    return weekString;
}

+(NSDate *)getNextDate:(int)dateCount{
    NSTimeInterval timer = 24 * 60 * 60 * dateCount;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:timer];
    return date;
}

@end
