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
#define SET_PWD @"SET_PWD"


static ShareValue *_shareValue;
static UIImage *_imageTablePart;
static UIImage *_imageTablePart1;
static UIImage *_imageTablePart2;
static UIImage *_imageTablePart3;
static UIImage *_imageTablePartS;
static UIImage *_imageTablePart1S;
static UIImage *_imageTablePart2S;
static UIImage *_imageTablePart3S;


@implementation ShareValue

+(UIImage *)tablePart{
    if (!_imageTablePart) {
        _imageTablePart  = [UIImage imageNamed:@"table_part"];
        _imageTablePart = [_imageTablePart resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12,5, 12)];
    }
    return _imageTablePart;
}

+(UIImage *)tablePart1{
    if (!_imageTablePart1) {
      _imageTablePart1  = [UIImage imageNamed:@"table_part1"];
        _imageTablePart1 = [_imageTablePart1 resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12,5, 12)];
    }
    return _imageTablePart1;
}

+(UIImage *)tablePart2{
    if (!_imageTablePart2) {
        _imageTablePart2  = [UIImage imageNamed:@"table_part2"];
        _imageTablePart2 = [_imageTablePart2 resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12,5, 12)];
    }
    return _imageTablePart2;
}

+(UIImage *)tablePart3{
    if (!_imageTablePart3) {
        _imageTablePart3  = [UIImage imageNamed:@"table_part3"];
        _imageTablePart3 = [_imageTablePart3 resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12,5, 12)];
    }
    return _imageTablePart3;
}


+(UIImage *)tablePartS{
    if (!_imageTablePartS) {
        _imageTablePartS  = [UIImage imageNamed:@"table_main_s"];
        _imageTablePartS = [_imageTablePartS resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2,2, 2)];
    }
    return _imageTablePartS;
}

+(UIImage *)tablePart1S{
    if (!_imageTablePart1S) {
        _imageTablePart1S  = [UIImage imageNamed:@"table_part1_S"];
        _imageTablePart1S = [_imageTablePart1S resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12,5, 12)];
    }
    return _imageTablePart2;
}

+(UIImage *)tablePart2S{
    if (!_imageTablePart2S) {
        _imageTablePart2S  = [UIImage imageNamed:@"table_part2_S"];
        _imageTablePart2S = [_imageTablePart2S resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12,5, 12)];
    }
    return _imageTablePart2S;
}

+(UIImage *)tablePart3S{
    if (!_imageTablePart3S) {
        _imageTablePart3S  = [UIImage imageNamed:@"table_part3_S"];
        _imageTablePart3S = [_imageTablePart3S resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12,5, 12)];
    }
    return _imageTablePart3S;
}

//获取文件id对应的图片
+(NSString *)getFileUrlByFileId:(NSString *)fileId{
    return [NSString stringWithFormat:IMAGE_PREFIX_URL,[ShareValue shareInstance].userInfo.CORP_ID,fileId];
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
    if (!corpCode) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_COREPCODE];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:corpCode forKey:SET_COREPCODE];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)corpCode{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_COREPCODE];
}

-(void)setUserPwd:(NSString *)userPwd{
    if (!userPwd) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_PWD];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:userPwd forKey:SET_PWD];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)userPwd{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_PWD];
}

-(void)setUserName:(NSString *)userName{
    if (!userName) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_USERNAME];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:userName forKey:SET_USERNAME];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)userName{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_USERNAME];
}

-(void)setUserPass:(NSString *)userPass{
    if (!userPass) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_USERPASS];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:userPass forKey:SET_USERPASS];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
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

-(NSNumber *)lastUpdateTime{
    return [[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"LASTUPDATE_%D",[ShareValue shareInstance].userInfo.USER_ID]];;
}

-(void)setLastUpdateTime:(NSNumber *)lastUpdateTime{
    [[NSUserDefaults standardUserDefaults]setObject:lastUpdateTime forKey:[NSString stringWithFormat:@"LASTUPDATE_%D",[ShareValue shareInstance].userInfo.USER_ID]];
    [[NSUserDefaults standardUserDefaults]synchronize];
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


+ (UIButton *)getDefaulBorder
{
    UIButton *inputBorderView = [UIButton buttonWithType:UIButtonTypeCustom];
    [inputBorderView setBackgroundImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateNormal];
    [inputBorderView setBackgroundImage:[[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateHighlighted];
    return inputBorderView;
}

+ (UIView *)getDefaultShowBorder
{
    UIImageView *showBorderView = [[UIImageView alloc] init];
    [showBorderView setImage:[[UIImage imageNamed:@"bgNo2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 20, 20)]];
    return showBorderView;
}

+ (UIView *)getDefaultInputBorder
{
    UIImageView *showBorderView = [[UIImageView alloc] init];
    [showBorderView setImage:[[UIImage imageNamed:@"bgNo1"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 20, 20)]];
    return showBorderView;
}

+ (UILabel *)getDefaultInputTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:FONT_SIZE_INPUT_TITLE];
    label.textColor = COLOR_INPUT_TITLE;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (UITextField *)getDefaultTextField
{
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectZero];
    textfield.font = [UIFont boldSystemFontOfSize:FONT_SIZE_INPUT_CONTENT];
    textfield.textColor = COLOR_INPUT_CONTENT;
    textfield.borderStyle = UITextBorderStyleNone;
    textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textfield;
}

+ (UILabel *)getDefaultContent
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = COLOR_INPUT_CONTENT;
    label.font = [UIFont systemFontOfSize:FONT_SIZE_INPUT_CONTENT];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (UILabel *)getDefaultDetailContent
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = COLOR_DETAIL_CONTENT;
    label.font = [UIFont systemFontOfSize:FONT_SIZE_DETAIL_CONTENT];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (UILabel *)getStarMarkPrompt
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"*";
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:17];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

+ (BOOL)legalTextFieldInputWithLegalString:(NSString *)legalString checkedString:(NSString *)checkedString
{
    NSCharacterSet *cst = [[NSCharacterSet characterSetWithCharactersInString:legalString] invertedSet];
    NSString *filted = [[checkedString componentsSeparatedByCharactersInSet:cst] componentsJoinedByString:@""];
    BOOL basicTest = [checkedString isEqualToString:filted];
    if (!basicTest)
    {
        return NO;
    }
    return YES;
}

@end
