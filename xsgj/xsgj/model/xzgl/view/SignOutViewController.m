//
//  SignOutViewController.m
//  xsgj
//
//  Created by Geory on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SignOutViewController.h"
#import "UIColor+External.h"
#import "MapUtils.h"
#import "MapAddressVC.h"
#import "XZGLAPI.h"
#import "MBProgressHUD+Add.h"
#import "SystemAPI.h"
#import "OfflineRequestCache.h"

@interface SignOutViewController ()<MapAddressVCDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    BOOL _isLocationSuccess;
    BOOL _isManualLocation;
    NSData *_imageData;
    CLLocationCoordinate2D manualCoordinate;
    NSString *_photoId;
}

@end

@implementation SignOutViewController

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
    [self showRightBarButtonItemWithTitle:@"确定" target:self action:@selector(submitAction:)];
    
}

- (BOOL)isValidData
{
    NSString *errorMessage = nil;
    if (!_isLocationSuccess) {
        errorMessage = @"未定位成功，请重新获取当前位置";
    }else if(!_imageData){
        errorMessage = @"请先拍照";
    }
    if (errorMessage.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signUpRequest
{
    SignUpHttpRequest *request = [[SignUpHttpRequest alloc] init];
    request.LNG = [ShareValue shareInstance].currentLocation.longitude;
    request.LAT = [ShareValue shareInstance].currentLocation.latitude;
    request.POSITION = _lb_currentLocation.text;
    request.SIGN_FLAG = @"o";
    request.PHOTO = _photoId;
    
    if (_isManualLocation) {
        request.LNG2 = [NSNumber numberWithFloat:manualCoordinate.longitude];
        request.LAT2 = [NSNumber numberWithFloat:manualCoordinate.latitude];
        request.POSITION2 = _lb_manualAdjust.text;
    }
    
    [XZGLAPI signupByRequest:request success:^(SignUpHttpReponse *response) {
        
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showSuccess:response.MESSAGE.MESSAGECONTENT toView:ShareAppDelegate.window];
        
        [self performSelector:@selector(back) withObject:nil afterDelay:.5f];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:desciption toView:self.view];
        
        if (notReachable) {
            OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:@"签退"];
            [cache saveToDB];
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showSuccess:DEFAULT_OFFLINE_MESSAGE_REPORT toView:ShareAppDelegate.window];
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
        }
    }];
}

- (void)uploadPhoto
{
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"IMG_%@",[formatter stringFromDate:now]];
    
//    [SystemAPI uploadPhotoByFileName:fileName data:_imageData success:^(NSString *fileId) {
//        
//        _photoId = fileId;
//        [self signUpRequest];
//        
//    } fail:^(BOOL notReachable, NSString *desciption) {
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:desciption toView:self.view];
//    }];
    
    [SystemAPI uploadPhotoByFileName:self.title data:_imageData success:^(NSString *fileId) {
        _photoId = fileId;
        [self signUpRequest];
    } fail:^(BOOL notReachable, NSString *desciption,NSString *fileId) {
        _photoId = fileId;
        [self signUpRequest];
    }];
    
    
}

#pragma mark - Action

- (IBAction)startLocationUpdate:(id)sender {
    [_btn_update setEnabled:NO];
    [[MapUtils shareInstance]startLocationUpdate];
}


- (void)submitAction:(id)sender
{
    if (![self isValidData]) {
        return;
    }
    
    [self uploadPhoto];
}

- (IBAction)otherAddressAction:(id)sender {
    MapAddressVC *vcl = [[MapAddressVC alloc]init];
    vcl.delegate = self;
    [self.navigationController pushViewController:vcl
                                         animated:YES];
}

- (void)showCamera
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (IBAction)takePhotoAction:(id)sender
{
    [self performSelector:@selector(showCamera) withObject:nil afterDelay:0.3];
}

#pragma mark - MapNotification

-(void)startLocationUpdate{
    _lb_currentLocation.text = @"正在定位...";
}

-(void)locationUpdated{
    _isLocationSuccess = YES;
    [[MapUtils shareInstance] startGeoCodeSearch];
}

-(void)locationUpdateError{
    if (_lb_currentLocation.text.length == 0) {
        _lb_currentLocation.text = @"定位失败";
        _isLocationSuccess = NO;
        _btn_update.enabled = YES;
    }
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
    manualCoordinate = coordinate;
    _isManualLocation = YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [self fixOrientation:image];
    image = [self scaleImage:image toScale:0.2f];
    
    _iv_photo.image = image;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    _imageData = imageData;
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
