//
//  ClCostViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-18.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ClCostViewController.h"

@interface ClCostViewController ()

@end

@implementation ClCostViewController

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
    
    _beginTime = nil;
    _endTime = nil;
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"陈列费用";
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(handleNavBarRight)];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    
}

- (IBAction)handleBtnPickerConfirm:(id)sender {
    NSDate *selectDate = [_datePicker date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strTime = [timeFormatter stringFromDate:selectDate];
    if(!_bSetEndTime)
    {
        if(_endTime)
        {
            NSTimeInterval timeInterval = [selectDate timeIntervalSinceDate:_endTime];
            if(timeInterval > 0)
            {
                // todo: 提示
                NSLog(@"开始时间晚于结束时间");
                return;
            }
        }
        _beginTime = selectDate;
        _tfTimeBegin.text = strTime;
    }
    else
    {
        if(_beginTime)
        {
            NSTimeInterval timeInterval = [selectDate timeIntervalSinceDate:_beginTime];
            if(timeInterval < 0)
            {
                // todo: 提示
                NSLog(@"结束时间早于开始时间");
                return;
            }
        }
        _endTime = selectDate;
        _tfTimeEnd.text = strTime;
    }
    _vDatePickerView.hidden = YES;
}

- (IBAction)handleBtnPickerCancel:(id)sender {
    _vDatePickerView.hidden = YES;
}

- (IBAction)handleBtnTimeBeginClicked:(id)sender {
    NSDate *now = [NSDate date];
    [_datePicker setDate:now animated:NO];
    _vDatePickerView.hidden = NO;
    _bSetEndTime = NO;
}

- (IBAction)handleBtnTimeEndClicked:(id)sender {
    NSDate *now = [NSDate date];
    [_datePicker setDate:now animated:NO];
    _vDatePickerView.hidden = NO;
    _bSetEndTime = YES;
}

- (IBAction)handleBtnClTypeClicked:(id)sender{
    _actionSheet = [[IBActionSheet alloc] initWithTitle:@"选择陈列形式"
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:nil, nil];
    _actionSheet.tag = 10;
    for(BNDisplayShape *displayShape in _aryClShapreData)
    {
        [_actionSheet addButtonWithTitle:displayShape.SHAPE_NAME];
    }
    
    [_actionSheet showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view];
}

- (void)loadTypeData
{
    _aryClShapreData = [BNDisplayShape searchWithWhere:nil orderBy:nil offset:0 count:100];
}

#pragma mark - IBActionSheetDelegate

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 10)
    {
        NSString *strSelect = [_actionSheet buttonTitleAtIndex:buttonIndex];
        if(![strSelect isEqualToString:@"取消"])
        {
            _tfClType.text = strSelect;
        }
    }
}

@end
