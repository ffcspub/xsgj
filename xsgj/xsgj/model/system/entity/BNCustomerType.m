//
//  BNCustomerType.m
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNCustomerType.h"
#import <LKDBHelper.h>
#import "OAChineseToPinyin.h"

@implementation BNCustomerType

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNCustomerType",[ShareValue shareInstance].userInfo.USER_ID];
}


+(void)getOwnerAndChildTypeIds:(int)typeid result:(NSMutableString *)result{
    [result appendFormat:@"%d,",typeid];
    NSArray *array = [BNCustomerType searchWithWhere:[NSString stringWithFormat:@"TYPE_PID=%d",typeid] orderBy:nil offset:0 count:20];
    for (BNCustomerType *type in array) {
        [self getOwnerAndChildTypeIds:type.TYPE_ID result:result];
    }
}

+(NSString *)getOwnerAndChildTypeIds:(int)typeid{
    NSMutableString *typeids = [NSMutableString string];
    [BNCustomerType getOwnerAndChildTypeIds:typeid result:typeids];
    return [typeids substringToIndex:typeids.length - 1];
}

-(void)getParentByArray:(NSMutableArray *)array{
    BNCustomerType *info = [BNCustomerType searchSingleWithWhere:[NSString stringWithFormat:@"TYPE_ID=%d",_TYPE_PID] orderBy:nil];
    if (info) {
        [array addObject:info];
        [info getParentByArray:array];
    }
}

-(NSMutableArray *)getFamilySequence{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:self];
    [self getParentByArray:array];
    return array;
}

-(void)setTYPE_NAME:(NSString *)TYPE_NAME{
    _TYPE_NAME = TYPE_NAME;
    if (TYPE_NAME) {
        self.TYPE_NAME_PINYIN = [OAChineseToPinyin pinyinFromChiniseString:TYPE_NAME];
        self.TYPE_NAME_HEAD   = [self.TYPE_NAME_PINYIN substringWithRange:NSMakeRange(0, 1)];
    }
}


@end
