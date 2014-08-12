//
//  OfflineRequestCache.h
//  xsgj
//
//  Created by ilikeido on 14-7-25.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpRequest.h"
#import <LKDBHelper.h>

@interface OfflineRequestCache : NSObject

@property(nonatomic,assign) int cacheId;
@property(nonatomic,strong) NSString *time;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *requestJsonStr;
@property(nonatomic,assign) int isUpload;
@property(nonatomic,strong) NSString *VISIT_NO;//拜访中使用

-(id)initWith:(LK_HttpBaseRequest *)request name:(NSString *)name;

@end
