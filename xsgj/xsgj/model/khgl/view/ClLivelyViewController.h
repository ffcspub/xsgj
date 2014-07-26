//
//  ClLivelyViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-18.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPhotoViewController.h"
#import "BNDisplayCase.h"

@interface ClLivelyViewController : CLPhotoViewController
{
    NSArray *_aryClCaseData;
}

@property (weak, nonatomic) BNDisplayCase *clCaseSelect;

@end
