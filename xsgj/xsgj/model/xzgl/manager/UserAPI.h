//
//  UserManager.h
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface UserAPI : NSObject

+(void)loginByCorpcode:(NSString *)corpcode username:(NSString *)username password:(NSString *)password  success:(void(^)(UserInfo *userinfo))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;



@end
