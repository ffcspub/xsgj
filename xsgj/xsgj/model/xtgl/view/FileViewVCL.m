//
//  FileViewVCL.m
//  xsgj
//
//  Created by mac on 14-7-30.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "FileViewVCL.h"

@interface FileViewVCL ()

@end

@implementation FileViewVCL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_fileUrl) {
        [_webView loadRequest:[[NSURLRequest alloc]initWithURL:_fileUrl]];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
