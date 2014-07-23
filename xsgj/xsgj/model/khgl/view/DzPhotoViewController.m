//
//  DzPhotoViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-16.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DzPhotoViewController.h"

#define MAXPHOTONUMBER   6

@implementation ImageFileInfo

-(id)initWithImage:(UIImage *)image;{
    self = [super init];
    if (self) {
        if (image) {
            _name = @"file";
            _mimeType = @"image/jpg";
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
    
    _totalfilesize = 0;
    _aryImages = [[NSMutableArray alloc] init];
    _ivCurrentTap = nil;
    [self initView];
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
    [_svImgContain setContentSize:CGSizeMake(_ivPhoto6.frame.origin.x + _ivPhoto6.frame.size.width, 0)];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    
}

- (IBAction)handleBtnTypeSelectClicked:(id)sender {
    // todo:根据查询数据显示照片类型
    NSArray *aryCusNames = @[@"照片类型1",@"照片类型2",@"照片类型3"];
    _actionSheet = [[IBActionSheet alloc] initWithTitle:@"选择照片类型"
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:nil, nil];
    _actionSheet.tag = 10;
    for(NSString *cusName in aryCusNames)
    {
        [_actionSheet addButtonWithTitle:cusName];
    }
    
    [_actionSheet showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view];
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

#pragma mark - UIImagePickerControllerDelegate

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
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
        _totalfilesize += imageInfo.filesize;
        
        [self reloadScrollView];
    }
    [picker dismissModalViewControllerAnimated:YES];
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
