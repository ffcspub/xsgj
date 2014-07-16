//
//  CustomerInfo.m
//  xsgj
//
//  Created by ilikeido on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "CustomerInfo.h"

@implementation CustomerInfo

-(NSString *)stateName{
    NSString *name = nil;
    switch (_CHECK_STATE) {
        case 0:
            name = @"未审核";
            break;
        case 1:
            name = @"通过";
            break;
        case 2:
            name = @"未通过";
            break;
        case 3:
            name = @"申请删除";
            break;
        default:
            break;
    }
    return name;
}

@end
