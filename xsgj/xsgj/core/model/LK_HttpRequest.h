//
//  LK_HttpRequest.h
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LK_HttpBaseRequest : NSObject

@end

@interface LK_HttpBasePageRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *orderField;
@property(nonatomic,strong) NSString *orderDirection;//[ASC,DESC]
@property(nonatomic,assign) NSInteger numPerPage;
@property(nonatomic,assign) NSInteger pageNum;
@property(nonatomic,strong) NSNumber *updatetimestamp;
@property(nonatomic,strong) NSNumber *endtimestamp;

@end
