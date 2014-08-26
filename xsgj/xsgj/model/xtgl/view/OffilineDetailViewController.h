//
//  OffilineDetailViewController.h
//  xsgj
//
//  Created by mac on 14-8-26.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfflineRequestCache.h"
#import "HideTabViewController.h"

@interface OffilineDetailViewController : HideTabViewController

@property(nonatomic,strong) OfflineRequestCache *cache;

@end
