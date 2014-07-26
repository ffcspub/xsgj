//
//  BNAreaInfo.h
//  fxtx
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNAreaInfo : NSObject

@property (nonatomic,assign)    int AREA_ID;
@property (nonatomic,assign)    int AREA_PID;
@property (nonatomic,strong)    NSString* AREA_NAME;
@property (nonatomic,assign)    int ORDER_NO;

+(NSString *)getOwnerAndChildAreaIds:(int)areaId;

@end
