//
//  VistRecord.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VistRecord : NSObject

@property(nonatomic,strong) NSString *visitId;//拜访记录id
@property(nonatomic,strong) NSString *custId;//客户id
@property(nonatomic,strong) NSString *userId;//用户id
@property(nonatomic,strong) NSString *beginTime;//到店时间
@property(nonatomic,strong) NSString *beginLat;//到店纬度
@property(nonatomic,strong) NSString *beginLng;//到店经度
@property(nonatomic,strong) NSString *beginPos;//到店地址位置
@property(nonatomic,strong) NSString *beginLat2;//到店纠偏纬度
@property(nonatomic,strong) NSString *beginLng2;//到店纠偏经度
@property(nonatomic,strong) NSString *beginPost2;//到店纠偏地理位置
@property(nonatomic,strong) NSString *endTime;//离店时间
@property(nonatomic,strong) NSString *endLat;//离店纬度
@property(nonatomic,strong) NSString *endLng;//离店经度
@property(nonatomic,strong) NSString *endPos;//离店地理位置
@property(nonatomic,strong) NSString *endLat2;//离店纠偏纬度
@property(nonatomic,strong) NSString *endLng2;//离店纠偏经度
@property(nonatomic,strong) NSString *endPos2;//离店纠偏地理位置
@property(nonatomic,strong) NSString *visitNo;//拜访uuid
@property(nonatomic,strong) NSString *visitType;//拜访类型 0:临时拜访  1计划拜访
@property(nonatomic,strong) NSString *visiDate;//实际拜访日期，格式:yyyy-MM-dd
@property(nonatomic,strong) NSString *visitConditionCode;//拜访情况编号

@end
