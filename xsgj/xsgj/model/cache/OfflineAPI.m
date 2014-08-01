//
//  OfflineAPI.m
//  xsgj
//
//  Created by ilikeido on 14-7-25.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "OfflineAPI.h"
#import <LKDBHelper.h>
#import <AFNetworking.h>
#import "OfflineRequestCache.h"
#import "ServerConfig.h"
#import <Reachability.h>

static BOOL _isSending;

@implementation OfflineAPI

+(OfflineAPI *)shareInstance{
    static dispatch_once_t onceToken;
    static OfflineAPI *_shareValue;
    dispatch_once(&onceToken, ^{
        _shareValue = [[OfflineAPI alloc]init];
    });
    return _shareValue;
}

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/***
 * 此函数用来判断是否网络连接服务器正常
 * 需要导入Reachability类
 */
- (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];  // 测试服务器状态
    
    switch([reachability currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = TRUE;
            break;
    }
    return  isExistenceNetwork;
}

-(void)reachabilityChanged: (NSNotification* )note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"Access Not Available");
            break;
        }
            
        case ReachableViaWWAN:
        {
            if ([self isExistenceNetwork]) {
                [self sendOfflineRequest];
            }
            NSLog(@"Reachable WWAN");
            break;
        }
        case ReachableViaWiFi:
        {
            if ([self isExistenceNetwork]) {
                [self sendOfflineRequest];
            }
            NSLog(@"Reachable WiFi");
            break;
        }
    }
}

+(AFHTTPClient *)client{
    static dispatch_once_t onceToken;
    static AFHTTPClient *_client;
    dispatch_once(&onceToken, ^{
        _client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:BASE_SERVERLURL]];
        LKDBHelper *helper = [LKDBHelper getUsingLKDBHelper];
        [helper createTableWithModelClass:[OfflineRequestCache class]];
    });
    return _client;
}

-(void)sendOfflineRequest{
    _isSending = YES;
    AFHTTPClient *client = OfflineAPI.client;
    NSArray *array = [OfflineRequestCache searchWithWhere:nil orderBy:nil offset:0 count:100];
    for (OfflineRequestCache *cache in array) {
        if (_isSending) {
            [client getPath:cache.requestJsonStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if(responseObject){
                    [[LKDBHelper getUsingLKDBHelper]deleteToDB:cache];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_OFFLINESENDSUCCESS object:cache];
                }else{
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    }
    _isSending = NO;
    
}

-(void)dealloc{
    [self startListener];
}

-(void)startListener{
    if (!_isSending) {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    }
}

-(void)stopListener{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
