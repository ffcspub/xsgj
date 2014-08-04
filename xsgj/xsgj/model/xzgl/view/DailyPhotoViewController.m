//
//  DailyPhotoViewController.m
//  xsgj
//
//  Created by Geory on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DailyPhotoViewController.h"
#import "MBProgressHUD+Add.h"
#import "SystemAPI.h"
#import "XZGLAPI.h"
#import "IBActionSheet.h"
#import "NSDate+Helper.h"
#import "OfflineRequestCache.h"

#define MAXPHOTONUMBER   5

@implementation ImageInfo

-(id)initWithImage:(UIImage *)image;{
    self = [super init];
    if (self) {
        if (image) {
            _name = @"file";
            _mimeType = @"image/jpg";
            _image = image;
            _fileData = UIImageJPEGRepresentation(image, 0.5);
            if (_fileData == nil)
            {
                _fileData = UIImagePNGRepresentation(image);
                _fileName = [NSString stringWithFormat:@"%f.png",[[NSDate date ]timeIntervalSinceNow]];
                _mimeType = @"image/png";
            }
            else
            {
                _fileName = [NSString stringWithFormat:@"%f.jpg",[[NSDate date ]timeIntervalSinceNow]];
            }
            self.filesize = _fileData.length;
        }
    }
    return self;
}

@end


@interface DailyPhotoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,IBActionSheetDelegate>{
    NSMutableArray *_aryfileDatas;
    NSMutableArray *_aryFileId;
    NSMutableArray *_aryImages;
    int _iSendImgCount;
    UIImageView *_ivCurrentTap;
    IBActionSheet *_delActionSheet;
    NSString *_photoId1;
    NSString *_photoId2;
    NSString *_photoId3;
    NSString *_photoId4;
    NSString *_photoId5;
}

@end

@implementation DailyPhotoViewController

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
    
    _iSendImgCount = 0;
    _aryFileId = [[NSMutableArray alloc] init];
    _aryfileDatas = [[NSMutableArray alloc] init];
    _aryImages = [[NSMutableArray alloc] init];
    _ivCurrentTap = nil;
    
    [self setup];
    
    [self setRightBarButtonItem];
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    [_iv_inputbg setImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)]];
    _lb_description.textColor = HEX_RGB(0x939fa7);
    
    UILabel *lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = CGRectMake(88, 34, 10, 20);
    [self.view addSubview:lblStart];
    
    [_iv_photobg setImage:[[UIImage imageNamed:@"Photo外框"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 20, 20)]];
    [_iv_photo setImage:[UIImage imageNamed:@"defaultPhoto"]];
    [_iv_photobgdown setImage:[UIImage imageNamed:@"Photo外框Part2"]];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(_ivPhoto5.frame), _scrollView.frame.size.height);
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

#pragma mark - private

-(void)delPhoto
{
    if(_ivCurrentTap)
    {
        [_aryImages removeObject:_ivCurrentTap.image];
        _ivCurrentTap = nil;
        
        [self reloadScrollView];
        
        [_aryfileDatas removeAllObjects];
        for(UIImage *image in _aryImages)
        {
            ImageInfo *imageInfo = [[ImageInfo alloc]initWithImage:image];
            [_aryfileDatas addObject:imageInfo];
        }
    }
}

- (void)reloadScrollView
{
    for(UIView *view in _scrollView.subviews)
    {
        if([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView = (UIImageView *)view;
            imageView.highlighted = NO;
            imageView.image = [UIImage imageNamed:@"Photo_addPhoto"];
        }
    }
    
    _iv_photo.image = [UIImage imageNamed:@"defaultPhoto"];
    _iv_photo.tag = 10;
    UIImageView *lastImageView = nil;
    for(int i=0; i<_aryImages.count; i++)
    {
        UIImageView *imageView = [self imageViewWithTag:i];
        UIImage *image = [_aryImages objectAtIndex:i];
        imageView.image = image;
        imageView.highlighted = YES;
        lastImageView = imageView;
    }
    if(lastImageView)
    {
        _iv_photo.image = lastImageView.image;
        _iv_photo.tag = lastImageView.tag;
    }
    
    
    float fOffset = lastImageView.frame.origin.x + 72 - _scrollView.frame.size.width;
    if(fOffset > 0)
    {
        [_scrollView setContentOffset:CGPointMake(fOffset, 0) animated:YES];
    }
    
    if(_aryImages.count >= MAXPHOTONUMBER)
    {
        _btnTakePhoto.enabled = NO;
    }
    else
    {
        _btnTakePhoto.enabled = YES;
    }
}

- (UIImageView *)imageViewWithTag:(int)tag
{
    for(UIImageView *imageView in _scrollView.subviews)
    {
        if(imageView.tag == tag)
            return imageView;
    }
    
    return nil;
}

- (BOOL)isValidData
{
    NSString *errorMessage = nil;
    if (_tf_description.text.length == 0) {
        errorMessage = @"请输入照片描述";
    }else if([_aryfileDatas count] == 0){
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

- (void)showCamera
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)insertUserCameraRequest
{
    InsertUserCameraHttpRequest *request = [[InsertUserCameraHttpRequest alloc] init];
    request.REMARK = _tf_description.text;
    
    if(_aryFileId.count >= 1)
    {
        request.PHOTO1 = [_aryFileId objectAtIndex:0];
    }
    
    if(_aryFileId.count >= 2)
    {
        request.PHOTO2 = [_aryFileId objectAtIndex:1];
    }
    
    if(_aryFileId.count >= 3)
    {
        request.PHOTO3 = [_aryFileId objectAtIndex:2];
    }
    
    if(_aryFileId.count >= 4)
    {
        request.PHOTO4 = [_aryFileId objectAtIndex:3];
    }
    
    if(_aryFileId.count >= 5)
    {
        request.PHOTO5 = [_aryFileId objectAtIndex:4];
    }
    
    request.COMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [XZGLAPI insertUserCameraByRequest:request success:^(InsertUserCameraHttpResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.MESSAGE.MESSAGECONTENT toView:self.view];
        
        [self performSelector:@selector(back) withObject:nil afterDelay:.5f];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:desciption toView:self.view];
        
        if (notReachable) {
            OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:@"日常拍照"];
            [cache saveToDB];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:DEFAULT_OFFLINEMESSAGE toView:self.view];
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }
    }];
}

- (void)uploadPhoto
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ImageInfo *imageInfo = [_aryfileDatas objectAtIndex:_iSendImgCount];
    
//    [SystemAPI uploadPhotoByFileName:imageInfo.fileName data:imageInfo.fileData success:^(NSString *fileId) {
//        
//        [_aryFileId addObject:fileId];
//        _iSendImgCount ++;
//        if(_iSendImgCount < _aryfileDatas.count)
//        {
//            [self uploadPhoto];
//        }
//        else
//        {
//            [self insertUserCameraRequest];
//        }
//        
//    } fail:^(BOOL notReachable, NSString *desciption) {
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:desciption toView:self.view];
//    }];
    
    NSString *fileId = [SystemAPI uploadPhotoByFileName:imageInfo.fileName data:imageInfo.fileData success:^(NSString *fileId) {
    } fail:^(BOOL notReachable, NSString *desciption) {
    }];
    
    [_aryFileId addObject:fileId];
    _iSendImgCount ++;
    if(_iSendImgCount < _aryfileDatas.count)
    {
        [self uploadPhoto];
    }
    else
    {
        [self insertUserCameraRequest];
    }
}

#pragma mark - Action

- (IBAction)takePhotoAction:(id)sender
{
    [self performSelector:@selector(showCamera) withObject:nil afterDelay:0.3];
}

- (IBAction)handleTapImageView:(id)sender
{
    if(_ivCurrentTap.highlighted)
    {
        _iv_photo.image = _ivCurrentTap.image;
    }
}

- (IBAction)handleLongPressImageView:(id)sender
{
    UILongPressGestureRecognizer *recognizer = (UILongPressGestureRecognizer *)sender;
    if(_ivCurrentTap.highlighted && recognizer.state == UIGestureRecognizerStateEnded)
    {
        _delActionSheet = [[IBActionSheet alloc]initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:@"删除"
                                            otherButtonTitles:nil];
        _delActionSheet.tag = 100;
        [_delActionSheet showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view];
    }
}

- (IBAction)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        if(_iv_photo.tag >= 0 && _iv_photo.tag <4)
        {
            UIImageView * imageview = [self imageViewWithTag:_iv_photo.tag + 1];
            if(imageview && imageview.highlighted)
            {
                _iv_photo.image = imageview.image;
                _iv_photo.tag = imageview.tag;
            }
        }
        
    }
    else if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        if(_iv_photo.tag > 0 && _iv_photo.tag <=4)
        {
            UIImageView * imageview = [self imageViewWithTag:_iv_photo.tag - 1];
            if(imageview && imageview.highlighted)
            {
                _iv_photo.image = imageview.image;
                _iv_photo.tag = imageview.tag;
            }
        }
        
    }
}

- (void)submitAction:(id)sender
{
    if (![self isValidData]) {
        return;
    }
    
    _iSendImgCount = 0;
    [_aryFileId removeAllObjects];
    
    [self uploadPhoto];
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
    
//    _iv_photo.image = image;
    [_aryImages addObject:image];
    
    ImageInfo *imageInfo = [[ImageInfo alloc] initWithImage:image];
    [_aryfileDatas addObject:imageInfo];
    
    [self reloadScrollView];
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    _ivCurrentTap = (UIImageView *)touch.view;
    return YES;
}

#pragma mark - IBActionSheetDelegate

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 100)
    {
        switch (buttonIndex) {
            case 0:
                [self delPhoto];
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.tf_description)
    {
        if(textField.text.length < 50 || [string isEqualToString:@""])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}

@end
