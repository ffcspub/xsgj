//
//  OfflineAPI.h
//  xsgj
//
//  Created by ilikeido on 14-7-25.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfflineRequestCache.h"

@interface OfflineAPI : NSObject

+(OfflineAPI *)shareInstance;

-(void)sendOfflineRequest;

-(void)startListener;//开始监听网络变化

-(void)stopListener;

-(BOOL)sendOfflineRequest:(OfflineRequestCache*)cache;

@end
