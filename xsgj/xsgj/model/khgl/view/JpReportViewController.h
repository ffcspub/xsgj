//
//  JpReportViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPhotoViewController.h"

@interface JpReportViewController : CLPhotoViewController


@property (weak, nonatomic) IBOutlet UITextField *tfBrand;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfSpec;
@property (weak, nonatomic) IBOutlet UITextField *tfPromotion;
@property (weak, nonatomic) IBOutlet UITextField *tfPrice;
@property (weak, nonatomic) IBOutlet UITextField *tfCustomer;

@end
