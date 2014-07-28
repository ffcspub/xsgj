//
//  DailyPhotoViewController.h
//  xsgj
//
//  Created by Geory on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"

@interface DailyPhotoViewController : HideTabViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iv_inputbg;
@property (weak, nonatomic) IBOutlet UILabel *lb_description;
@property (weak, nonatomic) IBOutlet UITextField *tf_description;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photobg;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photo;
@property (weak, nonatomic) IBOutlet UIImageView *iv_photobgdown;
@property (weak, nonatomic) IBOutlet UIButton *btnTakePhoto;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto1;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto2;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto3;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto4;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto5;

- (IBAction)takePhotoAction:(id)sender;
- (IBAction)handleTapImageView:(id)sender;
- (IBAction)handleLongPressImageView:(id)sender;

@end

@interface ImageInfo : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSString *mimeType;
@property(nonatomic,assign) long long filesize;
@property(nonatomic,strong) NSData *fileData;
@property(nonatomic,strong) UIImage *image;

-(id)initWithImage:(UIImage *)image;

@end
