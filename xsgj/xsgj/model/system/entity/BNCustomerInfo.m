//
//  BNCustomerInfo.m
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNCustomerInfo.h"
#import "BNCustomerType.h"
#import <LKDBHelper.h>

@implementation BNCustomerInfo

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNCustomerInfo",[ShareValue shareInstance].userInfo.USER_ID];
}

-(NSString *)TYPE_NAME{
    if (_TYPE_NAME.length > 0) {
        return _TYPE_NAME;
    }else{
        if (_TYPE_ID) {
            BNCustomerType *type = [BNCustomerType searchSingleWithWhere:[NSString stringWithFormat:@"TYPE_ID=%d",_TYPE_ID] orderBy:nil];
            return type.TYPE_NAME;
        }
    }
    return nil;
}

@end
