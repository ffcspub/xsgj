//
//  CLPhotoViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-17.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DzPhotoViewController.h"
#import "BNDisplayType.h"
#import "BNAssetType.h"

@interface CLPhotoViewController : DzPhotoViewController<UITextFieldDelegate>
{
    NSArray *_aryClTypeData;
    NSArray *_aryZcTypeData;
}


@property (weak, nonatomic) IBOutlet UIScrollView *svContain;
@property (weak, nonatomic) IBOutlet UITextField *tfClType;
@property (weak, nonatomic) IBOutlet UITextField *tfZcType;
@property (weak, nonatomic) IBOutlet UITextField *tfZcNumber;
@property (weak, nonatomic) BNDisplayType *clTypeSelect;
@property (weak, nonatomic) BNAssetType *zcTypeSelect;


- (IBAction)handleBtnClTypeClicked:(id)sender;
- (IBAction)handleBtnZcTypeClicked:(id)sender;

@end
