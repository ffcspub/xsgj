//
//  ClLivelyViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-18.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ClLivelyViewController.h"

@interface ClLivelyViewController ()

@end

@implementation ClLivelyViewController

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
    
    [self initView];
    [self loadTypeData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"陈列生动化";
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(handleNavBarRight)];
    [super.svContain setContentSize:CGSizeMake(0, super.svImgContain.frame.origin.y + super.svImgContain.frame.size.height + 150)];
    [super.svImgContain setContentSize:CGSizeMake(super.ivPhoto6.frame.origin.x + super.ivPhoto6.frame.size.width, 0)];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    
}

- (IBAction)handleBtnTypeSelectClicked:(id)sender {
    _actionSheet = [[IBActionSheet alloc] initWithTitle:@"选择陈列情况"
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:nil, nil];
    _actionSheet.tag = 10;
    for(BNDisplayCase *displayType in _aryClCaseData)
    {
        [_actionSheet addButtonWithTitle:displayType.CASE_NAME];
    }
    
    [_actionSheet showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view];
}

- (void)loadTypeData
{
    _aryClCaseData = [BNDisplayCase searchWithWhere:nil orderBy:nil offset:0 count:100];
}

#pragma mark - IBActionSheetDelegate

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 10)
    {
        NSString *strSelect = [_actionSheet buttonTitleAtIndex:buttonIndex];
        if(![strSelect isEqualToString:@"取消"])
        {
            super.tfPhotoType.text = strSelect;
        }
    }
    else if(actionSheet.tag == 100)
    {
        switch (buttonIndex) {
            case 0:
                [super delPhoto];
                break;
                
            default:
                break;
        }
    }
    
}

@end
