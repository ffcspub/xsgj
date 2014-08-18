//
//  TripDetailVC.h
//  xsgj
//
//  Created by xujunwen on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"

#define NOTIFICATION_TRIP_NEED_UPDATE @"NOTIFICATION_TRIP_NEED_UPDATE"

@class TripInfoBean;

/**
 *  出差明细
    1.点击出差查询，然后进去查看出差明细
    2.审批进入，进行审批
    二者的区别在于审批意见是否允许输入，并且多出两个审批按钮
 */

typedef NS_ENUM(NSUInteger, TripDetailShowStyle) {
    TripDetailShowStyleQuery = 0, // 查看
    TripDetailShowStyleApproval   // 审批
};

@interface TripDetailVC : HideTabViewController

@property (nonatomic, strong) TripInfoBean *tripInfo;
@property (nonatomic, assign) TripDetailShowStyle showStyle;

@end
