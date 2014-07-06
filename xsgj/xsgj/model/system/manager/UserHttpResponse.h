//
//  UserHttpResponse.h
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpResponse.h"
#import "UserInfo.h"

@interface UserLoginHttpResponse : LK_HttpBaseResponse

@property(nonatomic,strong) UserInfo *userInfo;

@end
