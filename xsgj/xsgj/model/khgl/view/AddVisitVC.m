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
#import "IBActionSheet.h"
#import "SIAlertView.h"
#import "SelectTreeViewController.h"
#import "BNCustomerType.h"
#import <LKDBHelper.h>
#import "OfflineRequestCache.h"

@interface AddVisitVC () <MapAddressVCDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    BOOL _isLocationSuccess;
    BOOL _isManualLocation;
    NSData *_imageData;
    CLLocationCoordinate2D manualCoordinate;
    NSString *_photoId;
    
    BOOL _isTypeSuccess; // 临时记录客户类型是否加载成功
    int _currentCustomerTypeID; // 记录客户类型ID
}

@property (nonatomic, strong) NSMutableArray *arrType;

@property (weak, nonatomic) IBOutlet UIView *vContaintLocation; // 地图根视图
@property (weak, nonatomic) IBOutlet UIScrollView *svRoot;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;

@property (weak, nonatomic) IBOutlet UILabel *lblAutoLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;

@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfLinkMan;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfAddr;
@property (weak, nonatomic) IBOutlet UITextField *tfRemark;
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
    
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(submitAction:)];
    
    // 外边框
    self.vContaintLocation.layer.borderColor = HEX_RGB(0xd3d3d3).CGColor;
    self.vContaintLocation.layer.borderWidth = 1.0;
    self.svRoot.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 630.f);
    
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
    
    // 加载客户类型数据,现在默认同android一样，直接从本地数据库取数据，如果有必要保持同步，可以调用更新配置接口
    [self getCustomerType];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotifySelectFin:) name:NOTIFICATION_SELECT_FIN object:nil];
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

#pragma mark - Getter & Setter

- (NSMutableArray *)arrType
{
    if (!_arrType) {
        _arrType = [[NSMutableArray alloc] init];
    }
    
    return _arrType;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.tfName)
    {
        if (range.location >= 15)
        {
            return NO;
        }
    } else if (textField == self.tfLinkMan) {
        if (range.location >= 10)
        {
            return NO;
        }
    } else if (textField == self.tfPhone) {
        if (![ShareValue legalTextFieldInputWithLegalString:NumberAndCharacters checkedString:string] || range.location >= 20)
        {
            return NO;
        }
    } else if (textField == self.tfAddr) {
        if (range.location >= 25)
        {
            return NO;
        }
    } else if (textField == self.tfRemark) {
        if (range.location >= 20)
        {
            return NO;
        }
    }
    
    return YES;
    
}

#pragma mark - 事件

- (BOOL)isValidData
{
    NSString *errorMessage = nil;
    if (!_isLocationSuccess && !_isManualLocation) {
        errorMessage = @"未定位成功，请重新获取当前位置";
    } else if ([self.lblType.text isEqualToString:@"请选择类型"]) {
        errorMessage = @"请选择类型";
    } else if ([self.tfName.text length] == 0) {
        errorMessage = @"请输入客户名称";
    } else if ([self.tfLinkMan.text length] == 0) {
        errorMessage = @"请输入联系人";
    } else if ([self.tfAddr.text length] == 0) {
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

/**
 *  获取客户类型
 */
- (void)getCustomerType
{
    /*
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AllTypeHttpRequest *request = [[AllTypeHttpRequest alloc] init];
    [KHGLAPI allTypeInfoByRequest:request success:^(AllTypeHttpResponse *response) {
        
        _isTypeSuccess = YES;
        
        NSLog(@"当前返回的类型总数:%d", [response.DATA count]);
        [self.arrType removeAllObjects];
        [self.arrType addObjectsFromArray:response.DATA];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
        
    }];
    */
    
    NSArray *arrTemp = [BNCustomerType searchWithWhere:nil orderBy:@" TYPE_NAME_PINYIN ASC " offset:0 count:1000];
    _isTypeSuccess = YES;
    [self.arrType removeAllObjects];
    [self.arrType addObjectsFromArray:arrTemp];
}

- (void)uploadPhoto
{
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"IMG_%@",[formatter stringFromDate:now]];
    [SystemAPI uploadPhotoByFileName:fileName data:_imageData success:^(NSString *fileId) {
        _photoId = fileId;
        [self addVisiterAction];
    } fail:^(BOOL notReachable, NSString *desciption,NSString *fileId) {
        _photoId = fileId;
        [self addVisiterAction];
    }];
}

/**
 *  网络请求
 */
- (void)addVisiterAction
{
    AddCustomerCommitHttpRequest *request = [[AddCustomerCommitHttpRequest alloc] init];
    request.CLASS_ID = _currentCustomerTypeID;
    request.CUST_NAME = self.tfName.text;
    request.LINKMAN = self.tfLinkMan.text;
    request.TEL = self.tfPhone.text;
    request.ADDRESS = self.tfAddr.text;
    request.REMARK = self.tfRemark.text;
    request.PHOTO = _photoId;
    request.COMMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];

    // 定位信息上传，手动优先于自动定位
    if (_isLocationSuccess) {
        request.LNG = @([ShareValue shareInstance].currentLocation.longitude*1000000);
        request.LAT = @([ShareValue shareInstance].currentLocation.latitude*1000000);
    }
    if (_isManualLocation) {
        request.LNG = [NSNumber numberWithFloat:manualCoordinate.longitude*1000000];
        request.LAT = [NSNumber numberWithFloat:manualCoordinate.latitude*1000000];
    }
    request.POSITION = self.lblAutoLocation.text;

    [KHGLAPI addCustomerCommitByRequest:request success:^(AddCustomerCommitHttpResponse *response) {
        
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:response.MESSAGE.MESSAGECONTENT toView:ShareAppDelegate.window];
        
        [self performSelector:@selector(back) withObject:nil afterDelay:.5f];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        if (notReachable)
        {
            OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:@"新增客户"];
            [cache saveToDB];
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showSuccess:DEFAULT_OFFLINEMESSAGE toView:ShareAppDelegate.window];
            double delayInSeconds = .5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
        }
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

- (IBAction)chooseCustomerType:(id)sender
{
    if (!_isTypeSuccess) {
        [self getCustomerType];
        return;
    }
    
    if ([self.arrType count] > 0) {
        
        //TODO: 进去类型选择界面
        NSArray *data = [self makeCusTypeTreeData];
        SelectTreeViewController *selectTreeViewController = [[SelectTreeViewController alloc] initWithNibName:@"SelectTreeViewController" bundle:nil];
        selectTreeViewController.data = data;
        [self.navigationController pushViewController:selectTreeViewController animated:YES];
        
    } else {
        SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"当前无客户类型选择"
                                              cancelButtonTitle:nil
                                                  cancelHandler:nil
                                         destructiveButtonTitle:@"确定"
                                             destructiveHandler:^(SIAlertView *alertView) {}];
        [alert show];
    }
}

- (NSArray *)makeCusTypeTreeData
{
    NSMutableArray *parentTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:self.arrType];
    for(BNCustomerType *customerType in self.arrType)
    {
        if(customerType.TYPE_PID == 0)
        {
            TreeData *aryData = [[TreeData alloc] init];
            aryData.name = customerType.TYPE_NAME;
            aryData.dataInfo = customerType;
            [parentTree addObject:aryData];
            
            [arySourceData removeObject:customerType];
        }
    }
    
    [self makeSubCusTypeTreeData:arySourceData ParentTreeData:parentTree];
    return parentTree;
}

- (void)makeSubCusTypeTreeData:(NSArray *)sourceData ParentTreeData:(NSMutableArray *)parentTree
{
    NSMutableArray *aryChildTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:sourceData];
    for(BNCustomerType *customerType in sourceData)
    {
        for(TreeData *parentData in parentTree)
        {
            BNCustomerType *parentCusType = (BNCustomerType *)parentData.dataInfo;
            if(customerType.TYPE_PID == parentCusType.TYPE_ID)
            {
                TreeData *aryData = [[TreeData alloc] init];
                aryData.name = customerType.TYPE_NAME;
                aryData.dataInfo = customerType;
                [parentData.children addObject:aryData];
                
                [aryChildTree addObject:aryData];
                [arySourceData removeObject:customerType];
            }
        }
    }
    
    if(arySourceData.count > 0)
    {
        [self makeSubCusTypeTreeData:arySourceData ParentTreeData:aryChildTree];
    }
}

- (void)handleNotifySelectFin:(NSNotification *)note
{
    BNCustomerType *cusType = [note object];
    self.lblType.text = cusType.TYPE_NAME;
    _currentCustomerTypeID = cusType.TYPE_ID;
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
    if ([address length] > 0) {
        self.lblAutoLocation.text = address;
        manualCoordinate = coordinate;
        _isManualLocation = YES;
    }
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
    
    self.ivPhoto.image = image;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    _imageData = imageData;
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
