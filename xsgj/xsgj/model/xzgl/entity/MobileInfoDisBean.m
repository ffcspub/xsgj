//
//  MobileInfoDisBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-25.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "MobileInfoDisBean.h"

@implementation MobileInfoDisBean

- (void)setSTATE:(NSString *)STATE
{
    _STATE = STATE;
    
    // STATE状态有7种，1已下单2已接单3配送中4配送完成5配送失败6作废7归档
    switch ([STATE intValue]) {
        case 1:
            self.STATE_NAME = @"已下单";
            break;
        case 2:
            self.STATE_NAME = @"已接单";
            break;
        case 3:
            self.STATE_NAME = @"配送中";
            break;
        case 4:
            self.STATE_NAME = @"配送完成";
            break;
        case 5:
            self.STATE_NAME = @"配送失败";
            break;
        case 6:
            self.STATE_NAME = @"作废";
            break;
        case 7:
            self.STATE_NAME = @"归档";
            break;
        default:
            self.STATE_NAME = @"未知";
            break;
    }
}

@end
