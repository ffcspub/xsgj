//
//  MapAddressVC.h
//  xsgj
//
//  Created by ilikeido on 14-7-21.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKMapView.h"
#import "HideTabViewController.h"

@protocol MapAddressVCDelegate;

@interface MyCusMapAddressVC : HideTabViewController<BMKMapViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@property(nonatomic,assign) id<MapAddressVCDelegate> delegate;

@property (nonatomic, assign) CLLocationCoordinate2D cusCoordinate;
@property (nonatomic, weak) NSString *strAddress;

@end
@protocol MapAddressVCDelegate <NSObject>

-(void)onAddressReturn:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;


@end