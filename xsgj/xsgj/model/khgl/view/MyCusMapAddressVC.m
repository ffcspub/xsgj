//
//  MapAddressVC.m
//  xsgj
//
//  Created by ilikeido on 14-7-21.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "MyCusMapAddressVC.h"
#import "MapUtils.h"

@interface MyCusMapAddressVC ()<BMKGeoCodeSearchDelegate>{
   CLLocationCoordinate2D _coordinate;
    NSString *_address;
    BMKPointAnnotation *_annotation;
    BMKGeoCodeSearch *_search;
}

@end

@implementation MyCusMapAddressVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"客户详情";

    _mapView.delegate = self;
    self.lb_address.text = self.strAddress;
    
//    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(_coordinate, BMKCoordinateSpanMake(0.01, 0.01));
//    
//    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
//    
//    [_mapView setRegion:adjustedRegion animated:YES];
    
    _annotation = [[BMKPointAnnotation alloc]init];
    _annotation.coordinate = self.cusCoordinate;
    [_mapView addAnnotation:_annotation];
    _mapView.centerCoordinate = _annotation.coordinate;
//    _search = [[BMKGeoCodeSearch alloc]init];
//    _search.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidUnload{
    _mapView.delegate = nil;
    _search.delegate = nil;
    [_mapView removeFromSuperview];
    _search = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
	//根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
	
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
	annotationView.canShowCallout = TRUE;
    return annotationView;
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
        
    }else{
        _address = result.address;
        _lb_address.text = _address;
    }
}


-(void)sureAction{
    if (_delegate) {
        [_delegate onAddressReturn:_address coordinate:_coordinate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)locationAddressUpdate{
    _lb_address.text = [ShareValue shareInstance].address;
    _address = [ShareValue shareInstance].address;
}
@end
