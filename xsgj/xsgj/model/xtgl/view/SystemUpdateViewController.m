//
//  SystemUpdateViewController.m
//  xsgj
//
//  Created by linw on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SystemUpdateViewController.h"

static const NSString *appleID = @"521989084";

@interface SystemUpdateViewController ()<UIAlertViewDelegate>
{
    double localVersion;
    double remoteVersion;
    NSString *trackViewUrl;
}
@end

@implementation SystemUpdateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightBarButtonItem];
    _labLocalVer.text  = [NSString stringWithFormat:@"%f",[self getLocalVersion]];
    _labRemoteVer.text = [NSString stringWithFormat:@"%f",[self getRemoteVersion]];
}

-(double)getLocalVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    localVersion = [currentVersion doubleValue];
    return  localVersion;
}

-(double)getRemoteVersion
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appleID]]];
    [request setHTTPMethod:@"GET"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    remoteVersion = [jsonData[@"results"][0][@"version"] floatValue];
    trackViewUrl  = jsonData[@"results"][0][@"trackViewUrl"];
    return remoteVersion;
}

#pragma mark - navBarButton

- (void)setRightBarButtonItem{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setFrame:CGRectMake(0, 2.f, 70.f, 33.f)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    
    [rightButton setTitle:@"更新" forState:UIControlStateNormal];
    
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

-(void)updateAction:(id)sender
{
    if (localVersion < remoteVersion)
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"销售管家"
                                           message:@"有新版本，是否升级?"
                                          delegate: self
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles: @"升级", nil];
        alert.tag = 1001;
        [alert show];
    }
    else
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"销售管家"
                                           message:@"暂无新版本"
                                          delegate: nil
                                 cancelButtonTitle:@"好的"
                                 otherButtonTitles: nil, nil];
        [alert show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
    }
}

@end
