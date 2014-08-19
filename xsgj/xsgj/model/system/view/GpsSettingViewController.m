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
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    [self uiConfig];

    
    
    
    
}

- (void)uiConfig {
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    myView.backgroundColor = HEX_RGB(0x409BE4);
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 70, 35)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    
    [btn setBackgroundImage:IMG_BTN_BLUE forState:UIControlStateNormal];
    [btn setBackgroundImage:IMG_BTN_BLUE_S forState:UIControlStateHighlighted];
    [btn setBackgroundImage:IMG_BTN_BLUE_D forState:UIControlStateDisabled];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:btn];
    [self.view addSubview:myView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 80, 40)];
    titleLabel.text = @"定位设置";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [myView addSubview:titleLabel];
    [self.view addSubview:myView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 270, 80, 30)];
    label1.text = @"无法定位";
    label1.font = [UIFont systemFontOfSize:17];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(80, 300, 160, 80)];
    label2.text = @"请在iPhone'设置-隐私-定位服务'中允许蜂行天下使用定位服务";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:13];
    label2.numberOfLines = 0;
    label2.lineBreakMode = NSLineBreakByCharWrapping;
    label2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label2];

    
    
}

- (void)backToMain {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
