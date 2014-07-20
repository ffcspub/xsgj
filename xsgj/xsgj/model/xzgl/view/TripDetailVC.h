//
//  TripDetailVC.h
//  xsgj
//
//  Created by xujunwen on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"
#import "BorderView.h"

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

@property (weak, nonatomic) IBOutlet UILabel *lblTheme;
@property (weak, nonatomic) IBOutlet UILabel *lblDays;
@property (weak, nonatomic) IBOutlet UILabel *lblBeginTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lblStarting;
@property (weak, nonatomic) IBOutlet UILabel *lblDestination;
@property (weak, nonatomic) IBOutlet UILabel *lblApprovalMan;
@property (weak, nonatomic) IBOutlet UILabel *lblApprovalState;
@property (weak, nonatomic) IBOutlet UILabel *lblApplyDesc;

@property (weak, nonatomic) IBOutlet UITextView *tvApprovalDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblInputFlag;

@property (nonatomic, assign) TripDetailShowStyle showStyle;

@end
