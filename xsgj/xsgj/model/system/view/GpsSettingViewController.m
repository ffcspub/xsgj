//
//  GpsSettingViewController.m
//  xsgj
//
//  Created by 崔艺凡 on 14-8-18.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "GpsSettingViewController.h"

@interface GpsSettingViewController ()

@end

@implementation GpsSettingViewController

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
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 370, 80, 30)];
    label1.text = @"无法定位";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor blackColor];
    label1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(80, 400, 160, 80)];
    label2.text = @"请在iPhone '设置-隐私-定位服务' 中允许蜂行天下使用定位服务";
    label2.lineBreakMode = UILineBreakModeCharacterWrap;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor blackColor];
    label2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
