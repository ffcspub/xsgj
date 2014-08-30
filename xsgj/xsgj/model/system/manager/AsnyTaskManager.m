//
//  AsnyTaskManager.m
//  xsgj
//
//  Created by ilikeido on 14-7-25.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "AsnyTaskManager.h"
#import "SystemAPI.h"
#import "SystemHttpRequest.h"
#import <LKDBHelper.h>
#import "MapUtils.h"
#import <NSDate+Helper.h>
#import "BNSignConfigBean.h"
#import "NSDate+Util.h"

static AsnyTaskManager *_shareValue;

@interface AsnyTaskManager(){
    NSArray *_signConfigBeans;
    int _INTERVALTIME;
    NSTimer *_taskTimer;
    NSTimer *_locationTaskTimer;
    NSDate *_lasttime;
}

@end

@implementation AsnyTaskManager

+(AsnyTaskManager *)shareInstance;{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareValue = [[AsnyTaskManager alloc]init];
    });
    return _shareValue;
}

-(id)init{
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationUpdated) name:NOTIFICATION_LOCATION_UPDATED object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)locationUpdated{
    if (![self isWantUpdate]) {
        return;
    }
    [SystemAPI commitLocateSuccess:^{
        
    } LOC_TYPE:@"1" LNG:[ShareValue shareInstance].currentLocation.longitude LAT:[ShareValue shareInstance].currentLocation.latitude fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}

-(void)loadConfig{
    int weekday = [[NSDate date] getWeekDay];
    _signConfigBeans = [BNSignConfigBean searchWithWhere:[NSString stringWithFormat:@"WEEK_DAY=%d",weekday] orderBy:nil offset:0 count:10];
    _INTERVALTIME = [ShareValue shareInstance].userInfo.STATE_UPLOAD_INTERVAL_MILLS / 1000 / 60;
}


-(BOOL) isWantUpdate{
    NSString *dateTime = [[NSDate date]stringWithFormat:@"HHmm"];
    int time = [dateTime integerValue];
    BOOL flag = NO;
    for (BNSignConfigBean *configBean in _signConfigBeans) {
        if (time >=configBean.BEGIN_TIME && time <=configBean.END_TIME) {
            flag = YES;
            break;
        }
    }
    return flag;
}

-(void)doLocationUpdateTask{
     [[MapUtils shareInstance]startLocationUpdate];
}

-(void)doTask{
    if (![self isWantUpdate]) {
        return;
    }
    [SystemAPI insertMobileSuccess:^{
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}


-(void)startTask{
    if (_taskTimer) {
        return;
    }
    if (_INTERVALTIME < 15.0) {
        _INTERVALTIME = 15.0;//默认15分钟
    }
    if (_taskTimer) {
        [_taskTimer invalidate];
        _taskTimer = nil;
    }
    if (_locationTaskTimer) {
        [_locationTaskTimer invalidate];
        _locationTaskTimer = nil;
    }
    [self doLocationUpdateTask];
    [self doTask];
    _taskTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 * _INTERVALTIME target:self selector:@selector(doTask) userInfo:nil repeats:YES];
    _locationTaskTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 * 15 target:self selector:@selector(doLocationUpdateTask) userInfo:nil repeats:YES];
    
}

-(void)stopTask{
    _lasttime = nil;
    [_taskTimer invalidate];
    _taskTimer = nil;
    [_locationTaskTimer invalidate];
    _locationTaskTimer = nil;
}

@end
