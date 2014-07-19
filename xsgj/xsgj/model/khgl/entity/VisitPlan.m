//
//  VisitPlan.m
//  xsgj
//
//  Created by ilikeido on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "VisitPlan.h"

@implementation VisitPlan

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

-(id)init{
    self = [super init];
    if (self) {
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
    }
    return self;
}

@end
