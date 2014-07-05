//
//  LK_HttpRequest.m
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "LK_HttpRequest.h"
#import <OpenUDID.h>

@implementation LK_HttpBaseRequest

@end

@implementation LK_HttpBasePageRequest

-(id)init{
    self = [super init];
    if (self) {
        _numPerPage = 20;
        _pageNum = 1;
    }
    return self;
}


@end
