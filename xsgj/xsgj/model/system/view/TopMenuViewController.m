//
//  TopMenuViewController.m
//  xsgj
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//
#import "TopMenuViewController.h"
#import "BNMobileMenu.h"
#import <LKDBHelper.h>
#import "MenuBtn.h"
#import "NextMenuViewController.h"
#import <Reachability.h>

#define DEFINE_COLNUMER 3

@interface TopMenuViewController (){
    
    __weak IBOutlet UIView *iv_netstate;
    Reachability *_reachability;
}

@end

@implementation TopMenuViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    [self reloadScrollView];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reachabilityChanged:nil];
}

-(void)showNetStateBar{
    iv_netstate.hidden = NO;
    iv_netstate.layer.opacity = 0.0;
    CGRect rect = self.view.bounds;
    rect.size.height -= iv_netstate.frame.size.height;
    rect.origin.y += iv_netstate.frame.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        iv_netstate.layer.opacity = 1.0;
        _scrollView.frame = rect;
    }];
}

-(void)hideNetStateBar{
    CGRect rect = self.view.bounds;
    [UIView animateWithDuration:0.5 animations:^{
        iv_netstate.layer.opacity = 0.0;
        _scrollView.frame = rect;
    } completion:^(BOOL finished) {
        iv_netstate.hidden = YES;
    }];
}

-(void)reachabilityChanged: (NSNotification* )note {
    Reachability* curReach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            [self showNetStateBar];
            break;
        }
            
        case ReachableViaWWAN:
        {
            [self hideNetStateBar];
            break;
        }
        case ReachableViaWiFi:
        {
            [self hideNetStateBar];
            break;
        }
    }
}

-(void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tabbartool
- (NSString *)tabImageName
{
    if ([_menu.MENU_NAME isEqual:@"行政管理"]) {
        return @"MenuIcon_Routine_unSelected";
    }
    if ([_menu.MENU_NAME isEqual:@"客户管理"]) {
        return @"MenuIcon_UserManager_unSelected";
    }
    if ([_menu.MENU_NAME isEqual:@"其他"]) {
        return @"MenuIcon_More_unSelected";
    }
    if ([_menu.MENU_NAME isEqual:@"系统管理"]) {
        return @"MenuIcon_SysManager_unSelected";
    }
    return _menu.ICON;
}

- (NSString *)selectedTabImageName
{
	if ([_menu.MENU_NAME isEqual:@"行政管理"]) {
        return @"MenuIcon_Routine_Selected";
    }
    if ([_menu.MENU_NAME isEqual:@"客户管理"]) {
        return @"MenuIcon_UserManager_Selected";
    }
    if ([_menu.MENU_NAME isEqual:@"其他"]) {
        return @"MenuIcon_More_Selected";
    }
    if ([_menu.MENU_NAME isEqual:@"系统管理"]) {
        return @"MenuIcon_SysManager_Selected";
    }
    return _menu.ICON;
}


- (NSString *)tabTitle
{
	return _menu.MENU_NAME;
}

-(NSString *)title{
    return [self tabTitle];
}


-(void)reloadScrollView{
    NSArray *views = _scrollView.subviews;
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
    CGFloat BEGINY = 10;
    CGFloat BEGINX = 10;
    CGFloat WIDTHSPACE = (self.scrollView.frame.size.width - 20)/DEFINE_COLNUMER;
    NSArray *menus = [BNMobileMenu searchWithWhere:[NSString stringWithFormat:@"PARENT_ID=%D and STATE=1",_menu.MENU_ID] orderBy:@"ORDER_NO" offset:0 count:100];
    int i = 0;
    for (BNMobileMenu *menu in menus) {
        MenuBtn *btn = [[MenuBtn alloc]initWithFrame:CGRectMake(BEGINX, BEGINY, WIDTHSPACE, WIDTHSPACE)];
        btn.menu = menu;
        [btn addTarget:self action:@selector(menuBtnChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        BEGINX += WIDTHSPACE;
        i++;
        if (i%3 == 0) {
            BEGINY += WIDTHSPACE;
            BEGINX = 10;
        }
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, BEGINY + WIDTHSPACE);
}

-(void)menuBtnChooseAction:(id)sender{
    MenuBtn *btn = (MenuBtn *)sender;
    BNMobileMenu *tmenu = btn.menu;
    NSString *CONTROLLER_NAME = tmenu.CONTROLLER_NAME;
    if (CONTROLLER_NAME.length > 0) {
        Class class = NSClassFromString(CONTROLLER_NAME);
        if (class) {
            if ([class isSubclassOfClass:[UIViewController class]]) {
                UIViewController *vlc = [[class alloc]init];
                vlc.title = tmenu.MENU_NAME;
                [self.navigationController pushViewController:vlc animated:YES];
            }
        }
        return;
    }
    int count = [BNMobileMenu rowCountWithWhere:[NSString stringWithFormat:@"PARENT_ID=%D and STATE=1",tmenu.MENU_ID]];
    if (count > 0) {
        NextMenuViewController *vlc = [[NextMenuViewController alloc]init];
        vlc.menu = tmenu;
        [self.navigationController pushViewController:vlc animated:YES];
    }
    
}

@end
