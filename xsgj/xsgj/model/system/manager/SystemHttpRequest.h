//
//  UserHttpRequest.h
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpRequest.h"

@interface UserLoginHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *CORP_CODE;
@property(nonatomic,strong) NSString *USER_NAME;
@property(nonatomic,strong) NSString *USER_PASS;
@property(nonatomic,strong) NSString *LOGINTYPE;
@property(nonatomic,strong) NSString *DEVICE_CODE;

@end
