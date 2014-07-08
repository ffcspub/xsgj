//
//  XZGLAPI.h
//  xsgj
//
//  Created by ilikeido on 14-7-6.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZGLAPI : NSObject

/**
 *  签到＼签退
 *
 *  @param lng      经度
 *  @param lat      纬度
 *  @param postion  位置
 *  @param lng2     纠偏经度
 *  @param lat2     纬度
 *  @param postion2 纠偏位置
 *  @param signflag 签到:i 签退:o
 *  @param photo    上传的图片
 */
+(void)signUPByLng:(float)lng lat:(float)lat postion:(NSString *)postion lng2:(NSNumber *)lng2 lat2:(NSNumber *)lat2 postion2:(NSString *)postion2 signflag:(NSString*)signflag photoid:(NSNumber *)photo;

@end
