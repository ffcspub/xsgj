//
//  LeaveInfoBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeaveInfoBean : NSObject

@property(nonatomic,strong) NSString *deptName;//部门名称
@property(nonatomic,strong) NSString *userName;//用户名称
@property(nonatomic,strong) NSString *userId;//人员标识
@property(nonatomic,strong) NSString *mobileno;//电话号码
@property(nonatomic,strong) NSString *realname;//姓名
@property(nonatomic,strong) NSString *typeName;//调休类型名称
@property(nonatomic,strong) NSString *title;//主题
@property(nonatomic,strong) NSString *remark;//调休说明
@property(nonatomic,strong) NSString *beginTime;//开始时间
@property(nonatomic,strong) NSString *endTime;//结束时间
@property(nonatomic,strong) NSString *applyTime;//申请时间
@property(nonatomic,strong) NSString *appoveUser;//审批人标识
@property(nonatomic,strong) NSString *approveState;//审批状态
@property(nonatomic,strong) NSString *approveRemark;//审批备注
@property(nonatomic,strong) NSString *approveTime;//审批时间

@end
