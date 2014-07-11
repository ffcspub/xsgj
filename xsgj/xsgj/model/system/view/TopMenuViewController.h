//
//  TopMenuViewController.h
//  xsgj
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowTabViewController.h"

@class BNMobileMenu;

@interface TopMenuViewController : ShowTabViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) BNMobileMenu *menu;


@end
