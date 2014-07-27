//
//  DistributionHandleDetailVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DistributionHandleDetailVC.h"
#import <NSDate+Helper.h>
#import "UIColor+External.h"
#import "MapUtils.h"
#import "MapAddressVC.h"
#import "XZGLAPI.h"
#import "MBProgressHUD+Add.h"
#import "SystemAPI.h"
#import "SIAlertView.h"
#import "ShareValue.h"
#import "IBActionSheet.h"

@interface DistributionHandleDetailVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, IBActionSheetDelegate>
{
    NSData *_imageData;
    NSString *_photoId;
}

@property (strong, nonatomic) IBOutlet UIScrollView *svHandle;
@property (strong, nonatomic) IBOutlet UIScrollView *svHandleTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (weak, nonatomic) IBOutlet UITextView *tvRemark;
@property (weak, nonatomic) IBOutlet UITextField *tfMoney;

@end

@implementation DistributionHandleDetailVC

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
    
    self.title = @"配送处理";
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    
    UIButton *rightButton = [self defaultRightButtonWithTitle:@"提交"];
    [rightButton addTarget:self
                    action:@selector(submitAction:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    // 初始化
    self.lblResult.text = [self.arrResult firstObject];
    
    if (self.currentState == DistributionHandleStateResult) {
        self.svHandleTwo.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.svHandleTwo];
        self.svHandleTwo.showsVerticalScrollIndicator = NO;
        self.svHandleTwo.frame = self.view.bounds;
        self.svHandleTwo.contentSize = CGSizeMake(CGRectGetWidth(self.svHandle.bounds), 550.f);
    } else {
        self.svHandle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.svHandle];
        self.svHandle.showsVerticalScrollIndicator = NO;
        self.svHandle.frame = self.view.bounds;
        self.svHandle.contentSize = CGSizeMake(CGRectGetWidth(self.svHandle.bounds), 230.f);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件

- (IBAction)selectResultAction:(id)sender
{
    IBActionSheet *sheet = [[IBActionSheet alloc] initWithTitle:@"请选择处理结果"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    for (NSString *btn in self.arrResult) {
        [sheet addButtonWithTitle:btn];
    }
    [sheet showInView:self.navigationController.view];
}

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.lblResult.text = self.arrResult[buttonIndex];
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

- (IBAction)submitAction:(id)sender
{
    if (![self isValidData]) {
        return;
    }
    
    [self startUpdate];
}

/**
 *  上传图片
 */
- (void)startUpdate
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"IMG_%@",[formatter stringFromDate:now]];
    
    if (self.currentState == DistributionHandleStateResult) {
        
        [SystemAPI uploadPhotoByFileName:fileName data:_imageData success:^(NSString *fileId) {
            
            _photoId = fileId;
            [self submitDisHandleResult];
            
        } fail:^(BOOL notReachable, NSString *desciption) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    } else {
        
        [self submitDisHandleResult];
    }
}

/**
 *  提交处理结果
 */
- (void)submitDisHandleResult
{
    MobileDisUpdateStateHttpRequest *request = [[MobileDisUpdateStateHttpRequest alloc] init];
    request.DISTRIBUTION_ID = self.DISTRIBUTION_ID;
    request.REMARK = self.tvRemark.text;
    
    if ([self.lblResult.text isEqualToString:@"已接单"]) {
        request.STATE = @"2";
    } else if ([self.lblResult.text isEqualToString:@"配送中"]) {
        request.STATE = @"3";
    } else if ([self.lblResult.text isEqualToString:@"配送完成"]) {
        request.STATE = @"4";
    } else if ([self.lblResult.text isEqualToString:@"配送失败"]) {
        request.STATE = @"5";
    }
    
    if (self.currentState == DistributionHandleStateResult) {
        request.PHOTO = _photoId;
        request.MONEY = self.tfMoney.text;
    } else {
        request.PHOTO = @"";
        request.MONEY = @"";
    }
    
    [XZGLAPI mobileDisUpdateStateByRequest:request success:^(MobileDisUpdateStateHttpResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:response.MESSAGE.MESSAGECONTENT toView:self.view];
        
        [self performSelector:@selector(back) withObject:nil afterDelay:.5f];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
        
    }];
}

- (BOOL)isValidData
{
    NSString *errorMessage = nil;
    if ([self.lblResult.text length] == 0) {
        errorMessage = @"请选择处理结果";
    } else if (self.currentState == DistributionHandleStateResult) {
        if ([self.tfMoney.text length] == 0) {
            errorMessage = @"请填写收费信息";
        } else if ([self.tvRemark.text length] == 0) {
            errorMessage = @"请填写备注信息";
        } else if (!_imageData) {
            errorMessage = @"请先拍照";
        }
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

#pragma mark - UIImagePickerController Delegate

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
