//
//  MyCusDetailViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-28.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusDetailViewController.h"
#import "CustDetailBean.h"

@interface MyCusDetailViewController : CusDetailViewController

@property (weak,nonatomic) CustDetailBean *custDetailBean;

@end
