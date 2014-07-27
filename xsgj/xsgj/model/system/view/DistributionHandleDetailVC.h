//
//  DistributionHandleDetailVC.h
//  xsgj
//
//  Created by xujunwen on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"

typedef NS_OPTIONS(NSUInteger, DistributionHandleState) {
    DistributionHandleStateReceive,   // 已接单
    DistributionHandleStateTransport, // 配送中
    DistributionHandleStateResult     // 配送结果，(配送失败或者配送成功)
};

/**
 *  配送处理界面
 */
@interface DistributionHandleDetailVC : HideTabViewController

@property (nonatomic, strong) NSString *DISTRIBUTION_ID; // 配送id
@property (nonatomic, assign) DistributionHandleState currentState;
@property (nonatomic, strong) NSArray *arrResult; // 处理结果

@end
