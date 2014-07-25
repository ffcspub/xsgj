//
//  LK_HttpRequest.m
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "LK_HttpRequest.h"
@implementation LK_HttpBaseRequest{
    NSString * _requestPath;
}

-(void)setRequestPath:(NSString *)path{
    _requestPath = path;
}

-(NSString *)requestPath{
    return _requestPath;
}

@end

@implementation LK_HttpBasePageRequest

-(id)init{
    self = [super init];
    if (self) {
        _ROWS = 20;
        _PAGE = 1;
    }
    return self;
}


@end
