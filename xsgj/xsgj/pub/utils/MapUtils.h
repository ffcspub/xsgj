//
//  MapUtils.h
//  xsgj
//
//  Created by ilikeido on 14-7-21.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

#define NOTIFICATION_LOCATION_WILLUPDATE @"NOTIFICATION_LOCATION_WILLUPDATE"
#define NOTIFICATION_LOCATION_UPDATED @"NOTIFICATION_LOCATION_UPDATED"
#define NOTIFICATION_LOCATION_UPDATERROR @"NOTIFICATION_LOCATION_UPDATERROR"
#define NOTIFICATION_ADDRESS_UPDATED @"NOTIFICATION_ADDRESS_UPDATED"
#define NOTIFICATION_ADDRESS_UPDATEERROR @"NOTIFICATION_ADDRESS_UPDATEERROR"

@interface MapUtils : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    BMKLocationService *_service;
    BMKGeoCodeSearch *_search;
}

+(MapUtils *)shareInstance;

-(void)startLocationUpdate;//开始定位
-(void)startGeoCodeSearch;//开始反编码

@end
