//
//  SystemUpdateViewController.m
//  系统更新
//
//  Created by linw on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SystemUpdateViewController.h"

// FXTX
static const NSString *appleID = @"906620927";

@interface SystemUpdateViewController ()<UIAlertViewDelegate>
{
    NSString* strLocalVer;
    NSString* strRemoteVer;
    NSString* trackViewUrl;
}
@end

@implementation SystemUpdateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightBarButtonItem];
    // 获取本地版本
    _labLocalVer.text  = [self getStrLocalVer];
    // 获取远程版本
    _labRemoteVer.text = [self getStrRemoteVer];
    // 版本判断
    if ([strLocalVer isEqualToString:strRemoteVer])
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        _labVerDescription.text = @"已经是最新版本";
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        _labVerDescription.text  = @"当前版本不是最新版本,请及时更新";
    }
}

-(NSString*)getStrLocalVer
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    strLocalVer = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return  strLocalVer;
}

-(NSString*)getStrRemoteVer
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appleID]]];
    [request setHTTPMethod:@"GET"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    if ([jsonData[@"resultCount"] intValue] == 0)
    {
        // 远程版本预置缺省值
        strRemoteVer       = [self getStrLocalVer];
        return strRemoteVer;
    }
    strRemoteVer = jsonData[@"results"][0][@"version"];
    trackViewUrl  = jsonData[@"results"][0][@"trackViewUrl"];
    return strRemoteVer;
}

#pragma mark - navBarButton

- (void)setRightBarButtonItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 2.f, 70.f, 33.f)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton setTitle:@"更新" forState:UIControlStateNormal];
    [rightButton setBackgroundImage:IMG_BTN_BLUE forState:UIControlStateNormal];
    [rightButton setBackgroundImage:IMG_BTN_BLUE_S forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:IMG_BTN_BLUE_D forState:UIControlStateDisabled];
    [rightButton addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

-(void)updateAction:(id)sender
{
    if (![strLocalVer isEqualToString:strRemoteVer])
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"销售管家"
                                           message:@"有新版本，是否升级?"
                                          delegate: self
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles: @"升级", nil];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
    }
}

@end
