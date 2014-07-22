//
//  MapUtils.m
//  xsgj
//
//  Created by ilikeido on 14-7-21.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "MapUtils.h"

static MapUtils * _utils;

@implementation MapUtils

+(MapUtils *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _utils = [[MapUtils alloc]init];
    });
    return _utils;
}

-(id)init{
    self = [super init];
    if (self) {
        _service = [[BMKLocationService alloc]init];
        _service.delegate = self;
        _search = [[BMKGeoCodeSearch alloc]init];
        _search.delegate = self;
    }
    return self;
}

-(void)startLocationUpdate{
    [_service startUserLocationService];
}

-(void)startGeoCodeSearch{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = [ShareValue shareInstance].currentLocation;
    BOOL flag = [_search reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOCATION_UPDATERROR object:nil];
    }

}

#pragma mark - 
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOCATION_WILLUPDATE object:nil];
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
    [_service stopUserLocationService];
    [ShareValue shareInstance].currentLocation = userLocation.location.coordinate;
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOCATION_UPDATED object:nil];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOCATION_UPDATERROR object:nil];
}


/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;
{
    if (error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADDRESS_UPDATEERROR object:nil];
    }else{
        [ShareValue shareInstance].address = result.address;
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADDRESS_UPDATED object:nil];
    }
}

@end
