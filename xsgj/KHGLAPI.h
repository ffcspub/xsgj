//
//  KHGLAPI.h
//  xsgj
//
//  Created by mac on 14-7-10.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHGLAPI : NSObject

+(void)allTypeInfoByRequest:(AllTypeHttpRequest *)request success:(void(^)(QueryDetailAdviceHttpResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil getHttpRequest:request apiPath:URL_querySaleTask Success:^(LK_HttpBaseResponse *response) {
        success((QueryDetailAdviceHttpResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryDetailAdviceHttpResponse class]];
}


@end
