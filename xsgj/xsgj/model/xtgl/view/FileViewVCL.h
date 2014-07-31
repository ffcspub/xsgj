//
//  FileViewVCL.h
//  xsgj
//
//  Created by mac on 14-7-30.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"

@interface FileViewVCL : HideTabViewController

@property(nonatomic,strong) NSURL *fileUrl;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
