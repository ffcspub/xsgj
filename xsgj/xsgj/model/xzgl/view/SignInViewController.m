//
//  SignInViewController.m
//  xsgj
//
//  Created by ilikeido on 14-7-14.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SignInViewController.h"
#import "UIColor+External.h"
#import "MapUtils.h"
#import "MapAddressVC.h"

@interface SignInViewController ()<MapAddressVCDelegate>{
    
}

@end

@implementation SignInViewController

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
    // Do any additional setup after loading the view from its nib.
    
    _viewContain.layer.borderColor = HEX_RGB(0xd3d3d3).CGColor;
    _viewContain.layer.borderWidth = 1.0;
    
    [self setup];
    
    [self setRightBarButtonItem];
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startLocationUpdate) name:NOTIFICATION_LOCATION_WILLUPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationUpdated) name:NOTIFICATION_LOCATION_UPDATED object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationUpdateError) name:NOTIFICATION_LOCATION_UPDATERROR object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationAddressUpdate) name:NOTIFICATION_ADDRESS_UPDATED object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationAddressUpdateErro) name:NOTIFICATION_ADDRESS_UPDATEERROR object:nil];
    
    [[MapUtils shareInstance] startLocationUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewDidUnload];
}


- (void)setup
{
    _lb_currentLocation.textColor = HEX_RGB(0x939fa7);
    _lb_manualAdjust.textColor = HEX_RGB(0x939fa7);
    [_iv_photobg setImage:[[UIImage imageNamed:@"Photo外框"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 20, 20)]];
    [_iv_photo setImage:[UIImage imageNamed:@"defaultPhoto"]];
    [_iv_photobgdown setImage:[UIImage imageNamed:@"Photo外框Part2"]];
    _lb_photo.textColor = HEX_RGB(0xb1b9bf);
    _lb_ps.textColor = HEX_RGB(0xc4c9cf);
}

#pragma mark - navBarButton

- (void)setRightBarButtonItem{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setFrame:CGRectMake(0, 2.f, 70.f, 33.f)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

#pragma mark - Action

- (IBAction)startLocationUpdate:(id)sender {
    [_btn_update setEnabled:NO];
    [[MapUtils shareInstance]startLocationUpdate];
}


- (void)submitAction:(id)sender
{
    
}

- (IBAction)otherAddressAction:(id)sender {
    MapAddressVC *vcl = [[MapAddressVC alloc]init];
    vcl.delegate = self;
    [self.navigationController pushViewController:vcl
                                         animated:YES];
}

#pragma mark - MapNotification

-(void)startLocationUpdate{
    _lb_currentLocation.text = @"正在定位...";
}

-(void)locationUpdated{
    [[MapUtils shareInstance] startGeoCodeSearch];
}

-(void)locationUpdateError{
    _lb_currentLocation.text = @"定位失败";
}

-(void)locationAddressUpdate{
    _lb_currentLocation.text = [ShareValue shareInstance].address;
    _btn_update.enabled = YES;
}

-(void)locationAddressUpdateErro{
    _lb_currentLocation.text = @"定位失败";
    _btn_update.enabled = YES;
}

#pragma mark 
-(void)onAddressReturn:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate{
    _lb_manualAdjust.text = address;
}

@end
