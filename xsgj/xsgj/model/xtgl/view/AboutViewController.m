//
//  AboutViewController.m
//  xsgj
//
//  Created by Geory on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    _viewContain.layer.borderColor = HEX_RGB(0xd3d3d3).CGColor;
    _viewContain.layer.borderWidth = 1.0;
    
    _viewImage.backgroundColor = HEX_RGB(0xf9f9f9);
    
//    _lb_version.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    _lb_version.text  = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
}

@end
