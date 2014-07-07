//
//  LK_Response.h
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNMessage.h"

@interface LK_HttpBaseResponse : NSObject

@property(nonatomic,strong) BNMessage *MESSAGE;

@end

//@interface LK_BasePageRespson : NSObject
//
//@property(nonatomic,strong) NSMutableArray *data;
//
//
//@end

@interface LK_HttpBasePageResponse : LK_HttpBaseResponse

@property(nonatomic,strong) NSMutableArray *data;

@end



