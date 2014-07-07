//
//  UserHttpResponse.h
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpResponse.h"
#import "BNUserInfo.h"

@interface UserLoginHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) BNUserInfo *USERINFO;

@end
