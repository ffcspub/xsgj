//
//  VisistRecordVO.h
//  xsgj
//
//  Created by ilikeido on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisistRecordVO : NSObject

@property(nonatomic,assign) int             VISIT_ID;//	拜访记录标识
@property(nonatomic,assign) int             CUST_ID;//	客户标识
@property(nonatomic,assign) int             USER_ID;//	用户标识
@property(nonatomic,assign) int             CORP_ID;//	企业标识
@property(nonatomic,strong) NSString *  	BEGIN_TIME	;//	起始时间
@property(nonatomic,strong) NSNumber *  	BEGIN_LAT	;//	起始纬度
@property(nonatomic,strong) NSNumber *  	BEGIN_LNG	;//	起始经度
@property(nonatomic,strong) NSString *  	BEGIN_POS	;//	起始地址
@property(nonatomic,strong) NSString *  	END_TIME	;//	结束时间
@property(nonatomic,strong) NSNumber *  	END_LAT	;//	结束纬度
@property(nonatomic,strong) NSNumber *  	END_LNG	;//	结束经度
@property(nonatomic,strong) NSString *  	END_POS	;//	结束地址
@property(nonatomic,strong) NSString *  	START_DATE	;//	起始年月日
@property(nonatomic,strong) NSString *  	END__DATE	;//	结束年月日
@property(nonatomic,strong) NSString *  	START_TIME_M	;//	起始时分
@property(nonatomic,strong) NSString *  	END_TIME_M	;//	结束时分
@property(nonatomic,strong) NSString *  	CUST_NAME	;//	客户姓名

@end
