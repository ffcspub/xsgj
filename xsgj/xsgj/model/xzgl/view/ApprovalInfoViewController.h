//
//  ApprovalInfoViewController.h
//  xsgj
//
//  Created by Geory on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"

@class LeaveinfoBean;

typedef NS_ENUM(NSUInteger, ApprovalInfoShowStyle) {
    ApprovalInfoShowStyleQuery = 0, // 查看
    ApprovalInfoShowStyleApproval   // 审批
};

@interface ApprovalInfoViewController : HideTabViewController

@property (nonatomic, strong) LeaveinfoBean *leaveInfo;

@property (nonatomic, assign) ApprovalInfoShowStyle showStyle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
