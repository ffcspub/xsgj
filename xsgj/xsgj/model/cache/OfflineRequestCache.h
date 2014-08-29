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
@property(nonatomic,strong) NSString *datetime;//上次上传时间
@property(nonatomic,assign) int sigleUpdateCount;//单次上传次数(失败次数)
@property(nonatomic,assign) int updateCount;//上传次数(失败次数)
@property(nonatomic,assign) int netstate;//上传时的网络状态  0：无网络  1:有网络
@property(nonatomic,strong) NSString *errorDescript;//错误提示

-(id)initWith:(LK_HttpBaseRequest *)request name:(NSString *)name;

-(void)fail:(int)netstate;

@end
