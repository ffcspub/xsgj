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
#import "LeveyPopListView.h"
#import "KHGLAPI.h"
#import "NSDate+Helper.h"
#import "BNCustomerInfo.h"
#import "BNCameraType.h"
#import "SystemAPI.h"
#import "MBProgressHUD+Add.h"
#import "LK_HttpRequest.h"
#import <IQKeyboardManager.h>
#import "BNVisitStepRecord.h"

#define NOTIFICATION_COMMITDATA_FIN @"NOTIFICATION_COMMITDATA_FIN"

@interface DzPhotoViewController : HideTabViewController<IBActionSheetDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    IBActionSheet *_actionSheet;
    IBActionSheet *_delActionSheet;
    UIImagePickerController *_picker;
    NSMutableArray *_aryfileDatas;
    NSMutableArray *_aryFileId;
    int _iSendImgCount;
    UIImageView *_ivCurrentTap;
    NSArray *_aryCameraTypeData;
    LeveyPopListView *_popListView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *svMainContain;
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
@property(nonatomic,strong) NSMutableArray *aryImages;
@property (weak, nonatomic) BNCustomerInfo *customerInfo;
@property (weak, nonatomic) BNVistRecord *vistRecord;
@property (weak, nonatomic) BNCameraType *cameratypeSelect;

-(void)takePhoto;
-(void)delPhoto;
- (IBAction)handleBtnTypeSelectClicked:(id)sender;
- (IBAction)handleBtnTakePhotoClicked:(id)sender;
- (IBAction)handleTapImageView:(id)sender;
- (IBAction)handleLongPressImageView:(id)sender;
-(IBAction)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;

@end

@interface ImageFileInfo : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSString *mimeType;
@property(nonatomic,assign) long long filesize;
@property(nonatomic,strong) NSData *fileData;
@property(nonatomic,strong) UIImage *image;

-(id)initWithImage:(UIImage *)image;

@end
