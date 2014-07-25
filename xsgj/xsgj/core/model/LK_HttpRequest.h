//
//  LK_HttpRequest.h
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LK_HttpBaseRequest : NSObject

-(void)setRequestPath:(NSString *)path;

-(NSString *)requestPath;

@end

@interface LK_HttpBasePageRequest : LK_HttpBaseRequest

@property(nonatomic,assign) NSInteger ROWS;
@property(nonatomic,assign) NSInteger PAGE;

@end
