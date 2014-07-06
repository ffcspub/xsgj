//
//  TripDetailBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripDetailBean : NSObject

@property(nonatomic,strong) NSString *deptName;//部门名称
@property(nonatomic,strong) NSString *userId;//人员标识
@property(nonatomic,strong) NSString *userName;//人员名称
@property(nonatomic,strong) NSString *mobileno;//手机号码
@property(nonatomic,strong) NSString *realname;//姓名
@property(nonatomic,strong) NSString *title;//主题
@property(nonatomic,strong) NSString *remark;//出差说明
@property(nonatomic,strong) NSString *beginTime;//出差开始时间
@property(nonatomic,strong) NSString *endTime;//出差结束时间
@property(nonatomic,strong) NSString *tripFrom;//出发地
@property(nonatomic,strong) NSString *tripTo;//目的地
@property(nonatomic,strong) NSString *applyTime;//申请时间
@property(nonatomic,strong) NSString *approveUser;//审批人
@property(nonatomic,strong) NSString *approveState;//审批状态
@property(nonatomic,strong) NSString *approveRemark;//审批说明
@property(nonatomic,strong) NSString *approveTime;//审批时间
@property(nonatomic,strong) NSString *aprroveUserName;//审批人用户名
@property(nonatomic,strong) NSString *approveMobileno;//审批人电话号码
@property(nonatomic,strong) NSString *approveRealname;//审批人姓名

@end
