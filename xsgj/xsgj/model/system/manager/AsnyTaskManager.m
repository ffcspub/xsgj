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
#import "SignConfigBean.h"
#import "TimeIntervalBean.h"
#import <LKDBHelper.h>
#import "MapUtils.h"
#import <NSDate+Helper.h>

static AsnyTaskManager *_shareValue;

@interface AsnyTaskManager(){
    NSArray *_signConfigBeans;
    int _INTERVALTIME;
    NSTimer *_taskTimer;
    
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
        LKDBHelper *helper = [LKDBHelper getUsingLKDBHelper];
        [helper createTableWithModelClass:[SignConfigBean class]];
        [helper createTableWithModelClass:[TimeIntervalBean class]];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationUpdated) name:NOTIFICATION_LOCATION_UPDATED object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)locationUpdated{
    [SystemAPI commitLocateSuccess:^{
        
    } LOC_TYPE:@"1" LNG:[ShareValue shareInstance].currentLocation.latitude LAT:[ShareValue shareInstance].currentLocation.longitude fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}

-(void)loadConfig{
    GetWorkRangeHttpRequest *request = [[GetWorkRangeHttpRequest alloc]init];
    [SystemAPI getWorkRangeByRequest:request success:^(GetWorkRangeHttpResponse *reponse) {
        [SignConfigBean deleteWithWhere:nil];
        for (SignConfigBean *bean in reponse.DATA) {
            [bean saveToDB];
        }
        _signConfigBeans = reponse.DATA;
        GetTimeIntervalHttpRequest *request1 = [[GetTimeIntervalHttpRequest alloc]init];
        [SystemAPI getTimeIntervalByRequest:request1 success:^(GetTimeIntervalHttpResponse *reponse) {
            [TimeIntervalBean deleteWithWhere:nil];
            _INTERVALTIME =  reponse.TIMEINTERVALBEAN.INTERVALTIME;
            [reponse.TIMEINTERVALBEAN saveToDB];
        } fail:^(BOOL notReachable, NSString *desciption) {
            TimeIntervalBean *bean = [TimeIntervalBean searchSingleWithWhere:nil orderBy:nil];
            if (bean) {
                _INTERVALTIME = bean.INTERVALTIME;
            }
        }];
    } fail:^(BOOL notReachable, NSString *desciption) {
        _signConfigBeans = [SignConfigBean searchWithWhere:nil orderBy:nil offset:0 count:10];
    }];
}


-(void)doTask{
    NSString *dateTime = [[NSDate date]stringWithFormat:@"HHmm"];
    int time = [dateTime integerValue];
    BOOL flag = NO;
    for (SignConfigBean *configBean in _signConfigBeans) {
        if (time >=configBean.BEGIN_TIME && time <=configBean.END_TIME) {
            flag = YES;
            break;
        }
    }
    if (!flag) {
        return;
    }
    [SystemAPI insertMobileSuccess:^{
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
    
    [[MapUtils shareInstance]startLocationUpdate];
    
}


-(void)startTask{
    if (_INTERVALTIME > 0) {
        if (_taskTimer) {
            [_taskTimer invalidate];
            _taskTimer = [NSTimer timerWithTimeInterval:60.0 * _INTERVALTIME target:self selector:@selector(doTask) userInfo:nil repeats:YES];
        }
    }
}

-(void)stopTask{
    [_taskTimer invalidate];
    _taskTimer = nil;
}

@end
