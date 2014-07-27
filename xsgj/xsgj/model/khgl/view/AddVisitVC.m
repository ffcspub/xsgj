//
//  AddVisitVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "AddVisitVC.h"
#import <NSDate+Helper.h>
#import "UIColor+External.h"
#import "MapUtils.h"
#import "MapAddressVC.h"
#import "KHGLAPI.h"
#import "MBProgressHUD+Add.h"
#import "SystemAPI.h"
#import "SIAlertView.h"
#import "ShareValue.h"

@interface AddVisitVC () <MapAddressVCDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL _isLocationSuccess;
    BOOL _isManualLocation;
    NSData *_imageData;
    CLLocationCoordinate2D manualCoordinate;
    NSString *_photoId;
}

@property (weak, nonatomic) IBOutlet UIView *vContaintLocation; // 地图根视图
@property (weak, nonatomic) IBOutlet UIScrollView *svRoot;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;

@property (weak, nonatomic) IBOutlet UILabel *lblAutoLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblManualLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;

@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfLinkMan;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextView *tvAddr;
@property (weak, nonatomic) IBOutlet UITextView *tfRemark;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;

@end

@implementation AddVisitVC

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
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    self.svRoot.backgroundColor = HEX_RGB(0xefeff4);
    
    // 导航按钮
    UIButton *rightButton = [self defaultRightButtonWithTitle:@"提交"];
    [rightButton addTarget:self
                    action:@selector(submitAction:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    // 外边框
    self.vContaintLocation.layer.borderColor = HEX_RGB(0xd3d3d3).CGColor;
    self.vContaintLocation.layer.borderWidth = 1.0;
    self.svRoot.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 800.f);
    
    // 拍照按钮
    [self.btnPhoto setImage:[UIImage imageNamed:@"btnPhoto_nor"] forState:UIControlStateNormal];
    [self.btnPhoto setImage:[UIImage imageNamed:@"btnPhoto_press"] forState:UIControlStateSelected];
    [self.btnPhoto setImage:[UIImage imageNamed:@"btnPhoto_disable"] forState:UIControlStateDisabled];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startLocationUpdate) name:NOTIFICATION_LOCATION_WILLUPDATE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationUpdated) name:NOTIFICATION_LOCATION_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationUpdateError) name:NOTIFICATION_LOCATION_UPDATERROR object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationAddressUpdate) name:NOTIFICATION_ADDRESS_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationAddressUpdateErro) name:NOTIFICATION_ADDRESS_UPDATEERROR object:nil];
    
    [[MapUtils shareInstance] startLocationUpdate];
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - 事件

- (BOOL)isValidData
{
    NSString *errorMessage = nil;
    if (!_isLocationSuccess) {
        errorMessage = @"未定位成功，请重新获取当前位置";
    } else if ([self.lblType.text isEqualToString:@"请选择类型"]) {
        errorMessage = @"请选择类型";
    } else if ([self.tfName.text length] == 0) {
        errorMessage = @"请输入客户名称";
    } else if ([self.tfLinkMan.text length] == 0) {
        errorMessage = @"请输入联系人";
    } else if ([self.tvAddr.text length] == 0) {
        errorMessage = @"请输入联系地址";
    } else if (!_imageData){
        errorMessage = @"请先拍照";
    }
    
    if (errorMessage.length > 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadPhoto
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"IMG_%@",[formatter stringFromDate:now]];
    
    [SystemAPI uploadPhotoByFileName:fileName data:_imageData success:^(NSString *fileId) {
        
        _photoId = fileId;
        [self addVisiterAction];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

/**
 *  网络请求
 */
- (void)addVisiterAction
{
    AddCustomerCommitHttpRequest *request = [[AddCustomerCommitHttpRequest alloc] init];
    request.CLASS_ID = 1;
    request.CUST_NAME = @"客户姓名";
    request.LINKMAN = @"联系人";
    request.TEL = @"联系电话";
    request.ADDRESS = @"联系地址";
    request.REMARK = self.tfRemark.text;
    request.PHOTO = _photoId;
    request.COMMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // chenzftodo: 数据确认
    request.LNG = @([ShareValue shareInstance].currentLocation.longitude);
    request.LAT = @([ShareValue shareInstance].currentLocation.latitude);
    request.POSITION = self.lblAutoLocation.text;
    
    [KHGLAPI addCustomerCommitByRequest:request success:^(AddCustomerCommitHttpResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:response.MESSAGE.MESSAGECONTENT toView:self.view];
        
        [self performSelector:@selector(back) withObject:nil afterDelay:.5f];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
        
    }];
}

- (IBAction)submitAction:(id)sender
{
    if (![self isValidData]) {
        return;
    }
    
    [self uploadPhoto];
}

- (IBAction)startLocationUpdate:(id)sender
{
    [self.btnRefresh setEnabled:NO];
    [[MapUtils shareInstance]startLocationUpdate];
}

- (IBAction)otherAddressAction:(id)sender
{
    MapAddressVC *vcl = [[MapAddressVC alloc]init];
    vcl.delegate = self;
    [self.navigationController pushViewController:vcl animated:YES];
}

- (void)showCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法启用相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)takePhotoAction:(id)sender
{
    [self performSelector:@selector(showCamera) withObject:nil afterDelay:0.3];
}

#pragma mark - MapNotification

-(void)startLocationUpdate{
    self.lblAutoLocation.text = @"正在定位...";
}

-(void)locationUpdated{
    [[MapUtils shareInstance] startGeoCodeSearch];
}

-(void)locationUpdateError{
    self.lblAutoLocation.text = @"定位失败";
    _isLocationSuccess = NO;
}

-(void)locationAddressUpdate{
    self.lblAutoLocation.text = [ShareValue shareInstance].address;
    self.btnRefresh.enabled = YES;
    _isLocationSuccess = YES;
}

-(void)locationAddressUpdateErro{
    self.lblAutoLocation.text = @"定位失败";
    self.btnRefresh.enabled = YES;
    _isLocationSuccess = NO;
}

#pragma mark
-(void)onAddressReturn:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"解析的地址为:%@", address);
    
    self.lblManualLocation.text = address;
    manualCoordinate = coordinate;
    _isManualLocation = YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (UIImage *)fixOrientation:(UIImage *)aImage
{
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
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    _imageData = imageData;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        self.ivPhoto.image = image;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
