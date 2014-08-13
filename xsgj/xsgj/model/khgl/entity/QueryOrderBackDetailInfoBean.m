//
//  QueryOrderBackDetailInfoBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "QueryOrderBackDetailInfoBean.h"
#import <LKDBHelper.h>
#import <NSDate+Helper.h>

@implementation QueryOrderBackDetailInfoBean

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_QueryOrderBackDetailInfoBean",[ShareValue shareInstance].userInfo.USER_ID];
}

-(void)save
{
    [QueryOrderBackDetailInfoBean deleteWithWhere:[NSString stringWithFormat:@"ITEM_ID=%d",[_ITEM_ID intValue]]];
    [self saveToDB];
}

@end
