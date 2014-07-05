//
//  LK_Response.h
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LK_HttpBaseResponse : NSObject

@property(nonatomic,assign) NSInteger returnCode;
@property(nonatomic,assign) NSInteger errorCode;
@property(nonatomic,strong) NSString *msg;

@end

@interface LK_BasePageRespson : NSObject

@property(nonatomic,strong) NSMutableArray *list;
@property(nonatomic,assign) BOOL isLastPage;


@end

@interface LK_HttpBasePageResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSNumber *uptimestamp;
@property(nonatomic,strong) LK_BasePageRespson *result;

@end



