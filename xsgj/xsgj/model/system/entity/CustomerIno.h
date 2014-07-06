//
//  CustomerIno.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerIno : NSObject

@property(nonatomic,strong) NSString *custId;//客户id
@property(nonatomic,strong) NSString *custName;//客户名
@property(nonatomic,strong) NSString *typeId;//类型id
@property(nonatomic,strong) NSString *areaId;//区域id
@property(nonatomic,strong) NSString *linkman;//联系人
@property(nonatomic,strong) NSString *tel;//联系电话
@property(nonatomic,strong) NSString *lat;//纬度
@property(nonatomic,strong) NSString *lan;//经度
@property(nonatomic,strong) NSString *address;//地址
@property(nonatomic,strong) NSString *photo;//照片id
@property(nonatomic,strong) NSString *remark;//备注
@property(nonatomic,strong) NSString *orderNo;//排序编号

@end
