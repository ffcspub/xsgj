//
//  CustomerInfo.m
//  xsgj
//
//  Created by ilikeido on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "CustomerInfo.h"

@interface CustomerInfo(){
    int _applyState;
}

@end

@implementation CustomerInfo

-(NSString *)stateName{
    NSString *name = nil;
    switch (_CHECK_STATE) {
        case 0:
            name = @"待审核";
            break;
        case 1:
            name = @"已通过";
            break;
        case 2:
            name = @"已驳回";
            break;
        case 3:
            name = @"申请删除";
            break;
        default:
            break;
    }
    return name;
}

-(BOOL)needToUpdate{
    return _applyState>0;
}

-(NSString *)applyStateName{
    if (_applyState == 1) {
        return @"申请添加";
    }else if(_applyState == 2){
        return @"申请删除";
    }
    return nil;
}

-(void)setApplyState:(int)type{
    _applyState = type;
}

-(BOOL)canDelete{
    return _CHECK_STATE != 0;
}

@end
