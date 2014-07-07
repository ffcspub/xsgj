//
//  LK_API.m
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "LK_API.h"
#import <AFNetworking.h>
#import <JSONKit.h>
#import "LK_NSDictionary2Object.h"
#import "ServerConfig.h"

#define TIMEOUT_DEFAULT 30

@interface LK_APIUtil (p)
+(AFHTTPClient *)client;
@end

@implementation LK_APIUtil(p)

+(AFHTTPClient *)client{
    static dispatch_once_t onceToken;
    static AFHTTPClient *_client;
    dispatch_once(&onceToken, ^{
        _client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:BASE_SERVERLURL]];
    });
    return _client;
}

@end

@implementation LK_APIUtil

+(void)postHttpRequest:(LK_HttpBaseRequest *)request apiPath:(NSString *)path Success:(void (^)(LK_HttpBaseResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass{
    if (!responseClass) {
        responseClass = [LK_HttpBaseResponse class];
    }
    NSDictionary *mdict = request.lkDictionary;
    NSMutableDictionary *tdict = [NSMutableDictionary dictionary];
    for (NSString *key in mdict.allKeys) {
        NSObject *object = [mdict objectForKey:key];
        [tdict setObject:object forKey:[key uppercaseString]];
    }
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[tdict JSONString],@"data", nil];
    
//    path = [NSString stringWithFormat:@"%@%@",BASE_SERVERLURL,path];
    AFHTTPClient *client = LK_APIUtil.client;
//    NSMutableURLRequest *urlRequest = [client requestWithMethod:@"POST" path:path parameters:dict];
//    urlRequest.timeoutInterval = 10;j
//    
//    AFJSONRequestOperation *operation =
//    [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSString *responseString = JSON;
//        NSLog(@"%@",responseString);
//        NSDictionary *dict = [responseString objectFromJSONString];
//        if (dict) {
//            NSObject *object = [dict objectByClass:responseClass];
//            sucess((LK_HttpBaseResponse*)object);
//        }else{
//            fail(@"服务器异常");
//        }
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        fail(@"服务器异常");
//    }];
//    [operation start];
   
//    client.parameterEncoding = AFJSONParameterEncoding;
    [client postPath:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",responseString);
            NSDictionary *dict = [responseString objectFromJSONString];
            if (dict) {
                NSObject *object = [dict objectByClass:responseClass];
                sucess((LK_HttpBaseResponse*)object);
            }else{
                fail(NO,@"网络不给力");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable,@"网络不给力");
    }];
}

+(void)getHttpRequest:(LK_HttpBaseRequest *)request apiPath:(NSString *)path Success:(void (^)(LK_HttpBaseResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass{
    if (!responseClass) {
        responseClass = [LK_HttpBaseResponse class];
    }
    AFHTTPClient *client = LK_APIUtil.client;
    [client getPath:path parameters:request.lkDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [responseString objectFromJSONString];
            if (dict) {
                NSObject *object = [dict objectByClass:responseClass];
                sucess((LK_HttpBaseResponse*)object);
            }else{
                fail(client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable,@"服务器异常");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable,error.localizedDescription);
    }];
}

+(void)cancelAllHttpRequestByApiPath:(NSString *)path;{
    [LK_APIUtil.client cancelAllHTTPOperationsWithMethod:@"POST" path:path];
    [LK_APIUtil.client cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}


+(void)uploadFile:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType ProgressBlock:(void(^)(NSInteger bytesWritten, long long totalBytesWritten))progressblock successBlock:(void(^)(NSString *filepath))success errorBlock:(void(^)(BOOL NotReachable))errorBlock;{
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:FILE_SERVERURL]];
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"post" path:@"uploadPhoto.shtml" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
    }];
    request.timeoutInterval = 20;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progressblock(bytesWritten,totalBytesWritten);
    }];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            success(responseString);
        }else{
           errorBlock(client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
    }];
    
}

@end
