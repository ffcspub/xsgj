//
//  WorkReportViewController.m
//  xsgj
//
//  Created by Geory on 14-7-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "WorkReportViewController.h"
#import "UIColor+External.h"

@interface WorkReportViewController ()

@end

@implementation WorkReportViewController

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
    
    [self setRightBarButtonItem];
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    [_btn_inputType setBackgroundImage:[[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateNormal];
    [_btn_inputType setBackgroundImage:[[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)] forState:UIControlStateHighlighted];
    [_btn_inputType setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_btn_inputType setTitleColor:HEX_RGB(0x939fa7) forState:UIControlStateNormal];
    
    UILabel *lb_type = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    lb_type.text = @"汇报类型";
    lb_type.font = [UIFont boldSystemFontOfSize:18];
    lb_type.textColor = HEX_RGB(0x939fa7);
    lb_type.backgroundColor = [UIColor clearColor];
    [_btn_inputType addSubview:lb_type];
    
    UILabel *lb_content = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    lb_content.text = @"请选择";
    lb_content.font = [UIFont boldSystemFontOfSize:18];
    lb_content.textColor = HEX_RGB(0x000000);
    lb_content.backgroundColor = [UIColor clearColor];
    [_btn_inputType addSubview:lb_content];
    
    UIImageView *iv_dropbox = [[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 20, 20)];
    iv_dropbox.image = [UIImage imageNamed:@"dropbox"];
    [_btn_inputType addSubview:iv_dropbox];
    
    [_iv_contentbg setImage:[[UIImage imageNamed:@"bgNo1"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 20, 20)]];
    
    [_iv_inputbg setImage:[[UIImage imageNamed:@"TextBox_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)]];
}

#pragma mark - navBarButton

- (void)setRightBarButtonItem{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setFrame:CGRectMake(0, 2.f, 70.f, 33.f)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"CommonBtn_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 7, 15, 7)] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

#pragma mark - LeveyPopListViewDelegate

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    
}

#pragma mark - Action

- (void)submitAction:(id)sender
{
    
}

- (IBAction)selectReportTypeAction:(id)sender
{
    NSMutableArray *options = [[NSMutableArray alloc]init];
    [options addObject:@"1"];
    [options addObject:@"2"];
    [options addObject:@"3"];
    LeveyPopListView *listView = [[LeveyPopListView alloc] initWithTitle:@"选择类型" options:options];
    listView.delegate = self;
    [listView showInView:self.navigationController.view animated:YES];
}

@end
