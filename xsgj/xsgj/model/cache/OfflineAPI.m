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
#import <JSONKit.h>
#import "BNVisitStepRecord.h"
#import "LK_HttpResponse.h"
#import "LK_NSDictionary2Object.h"
#import "NSDate+Util.h"
#import <NSDate+Helper.h>

@interface OfflineAPI(){
    Reachability *_reachability;
    NSTimer *_timer;
}

@property (nonatomic, assign) BOOL isObserve; // 是否监听网络变化

@end

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

-(void)dealloc
{
    [self stopListener];
}

/***
 * 此函数用来判断是否网络连接服务器正常
 * 需要导入Reachability类
 */
- (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    switch([_reachability currentReachabilityStatus]) {
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

-(void)checkUpdate{
    Reachability* curReach = _reachability;
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"当前网络->不可用!");
            break;
        }
            
        case ReachableViaWWAN:
        {
            if ([self isExistenceNetwork]) {
                [self performSelectorInBackground:@selector(sendOfflineRequest) withObject:nil];
                //[self sendOfflineRequest];
            }
            NSLog(@"当前网络->3G");
            break;
        }
        case ReachableViaWiFi:
        {
            if ([self isExistenceNetwork]) {
                [self performSelectorInBackground:@selector(sendOfflineRequest) withObject:nil];
                //[self sendOfflineRequest];
            }
            NSLog(@"当前网络->WIFI");
            break;
        }
    }
}

-(void)reachabilityChanged: (NSNotification* )note
{
    [self checkUpdate];
}

+(AFHTTPClient *)client{
    static dispatch_once_t onceToken;
    static AFHTTPClient *_client;
    dispatch_once(&onceToken, ^{
        _client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:BASE_SERVERLURL]];
        
    });
    return _client;
}

+(AFHTTPClient *)uploadClient{
    static dispatch_once_t onceToken;
    static AFHTTPClient *_client;
    dispatch_once(&onceToken, ^{
        _client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:UPLOAD_PIC_URL]];
        LKDBHelper *helper = [LKDBHelper getUsingLKDBHelper];
        [helper createTableWithModelClass:[OfflineRequestCache class]];
    });
    return _client;
}

/**
 *  启动离线上报
 */
-(void)sendOfflineRequest
{
    NetworkStatus netStatus = [_reachability currentReachabilityStatus];
    if (netStatus == NotReachable) {
        return;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-60*2];
    NSString *time = [date stringWithFormat:@"yyyyMMddHHmmss"];
    NSArray *array = [OfflineRequestCache searchWithWhere:[NSString stringWithFormat:@"datetime<'%@'",time] orderBy:@"datetime" offset:0 count:1];
    if (array.count > 0) {
        OfflineRequestCache *cache = array.firstObject;
        AFHTTPClient *client = OfflineAPI.client;
        if (cache.isUpload) {
            client = OfflineAPI.uploadClient;
        }
        // 保证只有一个线程在发送请求
        @synchronized(self) {
            if ([self httpClient:client sendHTTPRequest:cache]) {
                NSLog(@"离线上报---->[%@] 成功!", cache.name);
                [self sendOfflineRequest];
            } else {
                NSLog(@"离线上报---->[%@] 失败!", cache.name);
                [self sendOfflineRequest];
            }
        }
        
    }
   
}

/**
 *  同步请求
 *
 *  @param client
 *  @param request 请求信息
 *
 *  @return 是否请求成功
 */
- (BOOL)httpClient:(AFHTTPClient *)client sendHTTPRequest:(OfflineRequestCache*)request
{
    NSLog(@"离线上报---->[%@] 正在请求···", request.name);
    BOOL result = NO;
    
    NSURLResponse *response = nil;
    NSError *error = nil;

    NSMutableURLRequest *urlRequest = [client requestWithMethod:@"GET"
                                                           path:request.requestJsonStr
                                                     parameters:nil];
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:&response
                                                     error:&error];
    if( error ) {
        result = NO;
    } else {
        NSDictionary * JSON = [data objectFromJSONData];
        if(JSON){
            LK_HttpBaseResponse *response = [JSON objectByClass:[LK_HttpBaseResponse class]];
            if (response.MESSAGE.MESSAGECODE.integerValue == 0) {
                if (request.VISIT_NO.length>0) {
                    [BNVisitStepRecord updateToDBWithSet:@"SYNC_STATE=2" where:[NSString stringWithFormat:@"VISIT_NO='%@'",request.VISIT_NO]];
                }
                [[LKDBHelper getUsingLKDBHelper] deleteToDB:request];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OFFLINESENDSUCCESS
                                                                    object:request];
                return YES;
            }
       }
    }
    [request fail];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_OFFLINESENDSUCCESS
                                                        object:request];
    result = NO;
    return result;
}



- (void)startListener
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:10*60 target:self selector:@selector(checkUpdate) userInfo:nil repeats:YES];
    if (!_reachability) {
        _reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];  // 测试服务器状态
    }
    [_reachability startNotifier]; //开始监听,会启动一个run loop
    
    if (!self.isObserve) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
}

-(void)stopListener
{
    [_reachability stopNotifier];
    [_timer invalidate];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.isObserve = NO;
}

@end
