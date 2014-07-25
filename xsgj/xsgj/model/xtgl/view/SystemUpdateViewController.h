//
//  SystemUpdateViewController.h
//  xsgj
//
//  Created by linw on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"

@interface SystemUpdateViewController : HideTabViewController

@property (weak, nonatomic) IBOutlet UILabel *labLocalVer;
@property (weak, nonatomic) IBOutlet UILabel *labRemoteVer;

@end
