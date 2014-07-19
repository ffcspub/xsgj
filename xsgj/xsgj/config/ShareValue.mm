//
//  ShareValue.m
//  jiulifang
//
//  Created by hesh on 13-11-6.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "ShareValue.h"
#import "ServerConfig.h"

#define SET_NOREMBER @"SET_NOREMBER"
#define SET_NOAUTO @"SET_NOAUTO"
#define SET_COREPCODE @"SET_COREPCODE"
#define SET_USERNAME @"SET_USERNAME"
#define SET_USERPASS @"SET_USERPASS"
#define SET_NOSHOWPASS @"SET_NOSHOWPASS"
#define SET_USERID @"SET_USERID"


static ShareValue *_shareValue;


@implementation ShareValue

//获取文件id对应的图片
+(NSString *)getFileUrlByFileId:(NSString *)fileId{
    return [IMAGE_PREFIX_URL stringByAppendingString:fileId];
}

+(ShareValue *)shareInstance;{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareValue = [[ShareValue alloc]init];
    });
    return _shareValue;
}

-(void)setNoRemberFlag:(BOOL)noRemberFlag{
    [[NSUserDefaults standardUserDefaults]setBool:noRemberFlag forKey:SET_NOREMBER];
}

-(BOOL)noRemberFlag{
   return [[NSUserDefaults standardUserDefaults]boolForKey:SET_NOREMBER];
}

-(void)setNoAutoFlag:(BOOL)noAutoFlag{
    [[NSUserDefaults standardUserDefaults]setBool:noAutoFlag forKey:SET_NOAUTO];
}

-(BOOL)noAutoFlag{
    return [[NSUserDefaults standardUserDefaults]boolForKey:SET_NOAUTO];
}

-(BOOL)noShowPwd{
    return [[NSUserDefaults standardUserDefaults]boolForKey:SET_NOSHOWPASS];
}

-(void)setNoShowPwd:(BOOL)noShowPwd{
    [[NSUserDefaults standardUserDefaults]setBool:noShowPwd forKey:SET_NOSHOWPASS];
}

-(void)setCorpCode:(NSString *)corpCode{
    [[NSUserDefaults standardUserDefaults]setObject:corpCode forKey:SET_COREPCODE];
}

-(NSString *)corpCode{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_COREPCODE];
}

-(void)setUserName:(NSString *)userName{
    [[NSUserDefaults standardUserDefaults]setObject:userName forKey:SET_USERNAME];
}

-(NSString *)userName{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_USERNAME];
}

-(void)setUserPass:(NSString *)userPass{
    [[NSUserDefaults standardUserDefaults]setObject:userPass forKey:SET_USERPASS];
}

-(NSString *)userPass{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_USERPASS];
}

-(void)setUserId:(NSNumber *)userId{
    [[NSUserDefaults standardUserDefaults]setObject:userId forKey:SET_USERID];
}

-(NSNumber *)userId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:SET_USERID];
}

-(BNUserInfo *)userInfo{
    if (_userInfo) {
        return _userInfo;
    }
    if (self.userId) {
        return [BNUserInfo loadcacheByUserId:[self.userId intValue]];
    }
    return _userInfo;
}


@end
