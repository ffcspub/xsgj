//
//  DzPhotoViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-16.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DzPhotoViewController.h"

#define MAXPHOTONUMBER   5

@implementation ImageFileInfo

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



@interface DzPhotoViewController ()

@end

@implementation DzPhotoViewController

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
    [self initView];
    [self loadTypeData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"店招拍照";
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(handleNavBarRight)];
    [_svImgContain setContentSize:CGSizeMake(_ivPhoto5.frame.origin.x + _ivPhoto5.frame.size.width, 0)];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    if(_tfPhotoType.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写拍照类型" toView:self.view];
        return;
    }
    
    if(_tfMark.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写备注" toView:self.view];
        return;
    }
    
    _iSendImgCount = 0;
    [_aryFileId removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self commitData];
}

- (IBAction)handleBtnTypeSelectClicked:(id)sender {
    NSMutableArray *aryItems = [[NSMutableArray alloc] init];
    
    for(BNCameraType *cameraType in _aryCameraTypeData)
    {
        [aryItems addObject:cameraType.TYPE_NAME];
    }
    
    _popListView = [[LeveyPopListView alloc] initWithTitle:@"选择照片类型" options:aryItems handler:^(NSInteger anIndex) {
        NSString *strSelect = [aryItems objectAtIndex:anIndex];
        _tfPhotoType.text = strSelect;
        
        for(BNCameraType *cameraType in _aryCameraTypeData)
        {
            if([cameraType.TYPE_NAME isEqualToString:strSelect])
            {
                self.cameratypeSelect = cameraType;
                break;
            }
        }
        
    }];
    [_popListView showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view animated:NO];
}

- (IBAction)handleBtnTakePhotoClicked:(id)sender {
    [self takePhoto];
}

- (IBAction)handleTapImageView:(id)sender {
    if(_ivCurrentTap.highlighted)
    {
        _ivShowBig.image = _ivCurrentTap.image;
    }
}

- (IBAction)handleLongPressImageView:(id)sender {
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
            ImageFileInfo *imageInfo = [[ImageFileInfo alloc]initWithImage:image];
            [_aryfileDatas addObject:imageInfo];
        }
    }
}

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = NO;
        _picker.sourceType = sourceType;
        [self presentViewController:_picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)reloadScrollView
{
    for(UIView *view in _svImgContain.subviews)
    {
        if([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView = (UIImageView *)view;
            imageView.highlighted = NO;
            imageView.image = [UIImage imageNamed:@"Photo_addPhoto"];
        }
    }
    
    UIImageView *lastImageView = nil;
    for(int i=0; i<_aryImages.count; i++)
    {
        UIImageView *imageView = [self imageViewWithTag:i];
        UIImage *image = [_aryImages objectAtIndex:i];
        imageView.image = image;
        imageView.highlighted = YES;
        lastImageView = imageView;
    }
    
    float fOffset = lastImageView.frame.origin.x + 72 - _svImgContain.frame.size.width;
    if(fOffset > 0)
    {
        [_svImgContain setContentOffset:CGPointMake(fOffset, 0) animated:YES];
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
    for(UIImageView *imageView in _svImgContain.subviews)
    {
        if(imageView.tag == tag)
            return imageView;
    }
    
    return nil;
}

- (void)loadTypeData
{
    _aryCameraTypeData = [BNCameraType searchWithWhere:nil orderBy:@"ORDER_NO" offset:0 count:100];
}

- (void)commitData
{
    if(_aryfileDatas.count > 0)
    {
        ImageFileInfo *fileInfo = [_aryfileDatas objectAtIndex:_iSendImgCount];
        [SystemAPI uploadPhotoByFileName:self.title data:fileInfo.fileData success:^(NSString *fileId) {
            [_aryFileId addObject:fileId];
            _iSendImgCount ++;
            if(_iSendImgCount < _aryfileDatas.count)
            {
                [self commitData];
            }
            else
            {
                [self sendStoreCameraRequest];
            }
                
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
            return;
        }];
    }
}

- (void)sendStoreCameraRequest
{
    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='31'",self.vistRecord.VISIT_NO] orderBy:nil];
    step.SYNC_STATE = 1;
    if (!step) {
        step = [[BNVisitStepRecord alloc]init];
        step.VISIT_NO = _vistRecord.VISIT_NO;
        step.OPER_NUM =  step.OPER_NUM + 1;
        step.OPER_MENU = 31;
    }
    
    StoreCameraCommitHttpRequest *request = [[StoreCameraCommitHttpRequest alloc]init];
    // 基础用户信息
    request.SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
    request.CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
    request.DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
    request.USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
    request.USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    // 附加信息
    request.CUST_ID = self.customerInfo.CUST_ID;
    request.COMMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.OPER_MENU = @"31";
    request.TYPE_ID = self.cameratypeSelect.TYPE_ID;
    request.VISIT_NO = self.vistRecord.VISIT_NO;
    request.REMARK = self.tfMark.text;
    
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
    
    [KHGLAPI storeCameraCommitByRequest:request success:^(StoreCameraCommitHttpResponse *response){
        step.SYNC_STATE = 2;
        [step save];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMMITDATA_FIN object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
     }fail:^(BOOL notReachable, NSString *desciption){
         [step save];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD showError:desciption toView:self.view];
     }];
}

#pragma mark - UIImagePickerControllerDelegate

//当选择一张图片后进入这里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //image = [image fixOrientation];
        image = [image imageByScaleForSize:CGSizeMake(self.view.frame.size.width * 1.5, self.view.frame.size.height * 1.5)];
        [_aryImages addObject:image];
        _ivShowBig.image = image;
        
        ImageFileInfo *imageInfo = [[ImageFileInfo alloc]initWithImage:image];
        [_aryfileDatas addObject:imageInfo];
        
        [self reloadScrollView];
    }
    [_picker dismissModalViewControllerAnimated:YES];
    _picker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
    _picker = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    _ivCurrentTap = (UIImageView *)touch.view;
    return YES;
}


#pragma mark - IBActionSheetDelegate

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 10)
    {
        NSString *strSelect = [_actionSheet buttonTitleAtIndex:buttonIndex];
        if(![strSelect isEqualToString:@"取消"])
        {
            _tfPhotoType.text = strSelect;
        }
    }
    else if(actionSheet.tag == 100)
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

@end
