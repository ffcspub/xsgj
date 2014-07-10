//
//  TopMenuViewController.m
//  xsgj
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//
#import "NextMenuViewController.h"
#import "BNMobileMenu.h"
#import <LKDBHelper.h>
#import "MenuBtn.h"

#define DEFINE_COLNUMER 3

@interface NextMenuViewController (){
    
}

@end

@implementation NextMenuViewController

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
    [self reloadScrollView];
    // Do any additional setup after loading the view from its nib.
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
}

-(void)menuBtnChooseAction:(id)sender{
    MenuBtn *btn = (MenuBtn *)sender;
    BNMobileMenu *tmenu = btn.menu;
    int count = [BNMobileMenu rowCountWithWhere:[NSString stringWithFormat:@"PARENT_ID=%D and STATE=1",tmenu.MENU_ID]];
    if (count > 0) {
        NextMenuViewController *vlc = [[NextMenuViewController alloc]init];
        vlc.menu = tmenu;
        [self.navigationController pushViewController:vlc animated:YES];
    }
    
}

@end
