//
//  BNProduct.m
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNProduct.h"
#import "BNUnitBean.h"
#import "OAChineseToPinyin.h"

@implementation BNProduct

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNProduct",[ShareValue shareInstance].userInfo.USER_ID];
}


-(void)setPROD_NAME:(NSString *)PROD_NAME{
    _PROD_NAME = PROD_NAME;
    if (PROD_NAME) {
        self.PROD_NAME_PINYIN = [OAChineseToPinyin pinyinFromChiniseString:PROD_NAME];
        if (self.PROD_NAME_PINYIN.length > 0) {
            self.PROD_NAME_HEAD   = [self.PROD_NAME_PINYIN substringWithRange:NSMakeRange(0, 1)];
        }
    }
    
}


@end
