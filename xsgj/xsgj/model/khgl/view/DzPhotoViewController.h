//
//  DzPhotoViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-16.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "IBActionSheet.h"
#import "UIImage+External.h"
#import "LKDBHelper.h"

@interface DzPhotoViewController : HideTabViewController<IBActionSheetDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>
{
    IBActionSheet *_actionSheet;
    IBActionSheet *_delActionSheet;
    UIImagePickerController *_picker;
    NSMutableArray *_aryfileDatas;
    long long _totalfilesize;
    UIImageView *_ivCurrentTap;
}


@property (weak, nonatomic) IBOutlet UITextField *tfPhotoType;
@property (weak, nonatomic) IBOutlet UIButton *btnTypeSelect;
@property (weak, nonatomic) IBOutlet UIButton *btnTakePhoto;
@property (weak, nonatomic) IBOutlet UITextField *tfMark;
@property (weak, nonatomic) IBOutlet UIImageView *ivShowBig;
@property (weak, nonatomic) IBOutlet UIScrollView *svImgContain;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto1;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto2;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto3;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto4;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto5;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto6;
@property(nonatomic,strong) NSMutableArray *aryImages;

-(void)takePhoto;
-(void)delPhoto;
- (IBAction)handleBtnTypeSelectClicked:(id)sender;
- (IBAction)handleBtnTakePhotoClicked:(id)sender;
- (IBAction)handleTapImageView:(id)sender;
- (IBAction)handleLongPressImageView:(id)sender;

@end

@interface ImageFileInfo : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSString *mimeType;
@property(nonatomic,assign) long long filesize;
@property(nonatomic,strong) NSData *fileData;

-(id)initWithImage:(UIImage *)image;

@end
