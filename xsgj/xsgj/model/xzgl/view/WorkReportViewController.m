//
//  WorkReportViewController.m
//  xsgj
//
//  Created by Geory on 14-7-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "WorkReportViewController.h"
#import "UIColor+External.h"
#import "XZGLAPI.h"
#import "WorkReportTypeBean.h"
#import "MBProgressHUD+Add.h"
#import "OfflineRequestCache.h"
#import "SystemAPI.h"
#import <LKDBHelper.h>

@interface WorkReportViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSMutableArray *_types;
    WorkReportTypeBean *_selectType;
    NSData *_imageData;
    NSString *_photoId;
}

@end

@implementation WorkReportViewController

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
    
    [self setup];
    
    [self setRightBarButtonItem];
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    
    [[LKDBHelper getUsingLKDBHelper]createTableWithModelClass:[WorkReportTypeBean class ]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    [_btn_inputType setBackgroundImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateNormal];
    [_btn_inputType setBackgroundImage:[[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateHighlighted];
    [_btn_inputType setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_btn_inputType setTitleColor:HEX_RGB(0x939fa7) forState:UIControlStateNormal];
    
    UILabel *lb_type = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    lb_type.text = @"汇报类型";
    lb_type.font = [UIFont systemFontOfSize:17];
    lb_type.textColor = HEX_RGB(0x939fa7);
    lb_type.backgroundColor = [UIColor clearColor];
    [_btn_inputType addSubview:lb_type];
    
    UILabel *lblStart = [ShareValue getStarMarkPrompt];
    lblStart.frame = CGRectMake(78, 14, 10, 20);
    [_btn_inputType addSubview:lblStart];
    
    UILabel *lb_content = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    lb_content.text = @"请选择";
    lb_content.font = [UIFont systemFontOfSize:17];
    lb_content.textColor = HEX_RGB(0x000000);
    lb_content.backgroundColor = [UIColor clearColor];
    lb_content.tag = 701;
    [_btn_inputType addSubview:lb_content];
    
    UIImageView *iv_dropbox = [[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 20, 20)];
    iv_dropbox.image = [UIImage imageNamed:@"dropbox"];
    [_btn_inputType addSubview:iv_dropbox];
    
    [_iv_contentbg setImage:[[UIImage imageNamed:@"bgNo1"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 20, 20)]];
    
    [_iv_inputbg setImage:[[UIImage imageNamed:@"TextBox_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)]];
    
    [_iv_photobg setImage:[[UIImage imageNamed:@"Photo外框"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 20, 20)]];
    [_iv_photo setImage:[UIImage imageNamed:@"defaultPhoto"]];
    [_iv_photobgdown setImage:[UIImage imageNamed:@"Photo外框Part2"]];
    _lb_photo.textColor = HEX_RGB(0xb1b9bf);
    
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(_iv_photobg.frame) + 10)];
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

-(BOOL)isVailData{
    NSString *errorMessage = nil;
    if(!_selectType){
        errorMessage = @"请选择汇报类型";
    }else if (_tv_content.text.length == 0){
        errorMessage = @"请输入汇报内容";
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

- (void)workReportRequest
{
    WorkReportHttpRequest *request = [[WorkReportHttpRequest alloc] init];
    request.TYPE_ID = [NSString stringWithFormat:@"%d",_selectType.TYPE_ID];
    request.CONTENT = _tv_content.text;
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.COMMITTIME = [formatter stringFromDate:now];
    request.PHOTO1 = _photoId;
    
    [XZGLAPI workReportByRequest:request success:^(WorkReportHttpResponse *response) {
        
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showSuccess:response.MESSAGE.MESSAGECONTENT toView:ShareAppDelegate.window];
        [self performSelector:@selector(backToFront) withObject:nil afterDelay:.5f];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        if (notReachable) {
            OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:@"工作汇报"];
            [cache saveToDB];
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showSuccess:DEFAULT_OFFLINEMESSAGE toView:ShareAppDelegate.window];
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
        }
    }];
}

- (void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadPhoto
{
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    
    NSDate *now = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"IMG_%@",[formatter stringFromDate:now]];
    
    [SystemAPI uploadPhotoByFileName:fileName data:_imageData success:^(NSString *fileId) {
        _photoId = fileId;
        [self workReportRequest];
    } fail:^(BOOL notReachable, NSString *desciption,NSString *fileId) {
        _photoId = fileId;
        [self workReportRequest];
    }];
    
    
}

#pragma mark - LeveyPopListViewDelegate

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    WorkReportTypeBean *type = [_types objectAtIndex:anIndex];
    _selectType = type;
    UILabel *lb_content = (UILabel *)[_btn_inputType viewWithTag:701];
    lb_content.text = type.TYPE_NAME;
}

#pragma mark - Action

- (void)submitAction:(id)sender
{
    [_tv_content resignFirstResponder];
    if (![self isVailData]) {
        return;
    }
    [self uploadPhoto];
}

- (IBAction)selectReportTypeAction:(id)sender
{
    WorkTypeHttpRequest *request = [[WorkTypeHttpRequest alloc] init];
    
    [XZGLAPI workReportTypeByRequest:request success:^(WorkTypeHttpResponse *response) {
        _types = [[NSMutableArray alloc] init];
        [_types addObjectsFromArray:response.WORKREPORTINFOBEAN];
        NSMutableArray *options = [[NSMutableArray alloc]init];
        for (WorkReportTypeBean *type in _types) {
            [type save];
            [options addObject:[NSDictionary dictionaryWithObjectsAndKeys:type.TYPE_NAME, @"text",nil]];
        }
        LeveyPopListView *listView = [[LeveyPopListView alloc] initWithTitle:@"选择类型" options:options];
        listView.delegate = self;
        [listView showInView:self.navigationController.view animated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        if (notReachable) {
            NSArray *types = [WorkReportTypeBean searchWithWhere:nil orderBy:nil offset:0 count:90];
            _types = [[NSMutableArray alloc] init];
            [_types addObjectsFromArray:types];
            NSMutableArray *options = [[NSMutableArray alloc]init];
            for (WorkReportTypeBean *type in _types) {
                [type save];
                [options addObject:[NSDictionary dictionaryWithObjectsAndKeys:type.TYPE_NAME, @"text",nil]];
            }
            LeveyPopListView *listView = [[LeveyPopListView alloc] initWithTitle:@"选择类型" options:options];
            listView.delegate = self;
            [listView showInView:self.navigationController.view animated:YES];
        }
        
    }];
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

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == _tv_content) {
        NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger res = 200 - [new length];
        if(res >= 0)
        {
            return YES;
        }
        else
        {
            NSRange rg = {0,[text length]+res};
            if (rg.length>0) {
                NSString *s = [text substringWithRange:rg];
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            }
            return NO;
        }
    }
    
    return YES;
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
