//
//  OrderBackDetailBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "OrderBackDetailBean.h"
#import <LKDBHelper.h>
#import <NSDate+Helper.h>

@implementation OrderBackDetailBean

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_OrderBackDetailBean",[ShareValue shareInstance].userInfo.USER_ID];
}

-(void)save
{
    [OrderBackDetailBean deleteWithWhere:[NSString stringWithFormat:@"ITEM_ID=%d",_ITEM_ID]];
    [self saveToDB];
}

@end
