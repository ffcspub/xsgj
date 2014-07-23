//
//  HdReportViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HdReportViewController.h"

@interface HdReportViewController ()

@end

@implementation HdReportViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"活动上报";
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(handleNavBarRight)];
    
    self.txHdDescription.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txHdDescription.layer.borderWidth = 1;
    self.txHdDescription.layer.cornerRadius = 5;
    
    [super.svContain setContentSize:CGSizeMake(0, super.svImgContain.frame.origin.y + super.svImgContain.frame.size.height + 200)];
    [super.svImgContain setContentSize:CGSizeMake(super.ivPhoto6.frame.origin.x + super.ivPhoto6.frame.size.width, 0)];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length==0){
        if ([text isEqualToString:@""]) {
            self.lbPlaceholder.hidden=NO;
        }else{
            self.lbPlaceholder.hidden=YES;
        }
    }else{
        if (textView.text.length==1){
            if ([text isEqualToString:@""]) {
                self.lbPlaceholder.hidden=NO;
            }else{
                self.lbPlaceholder.hidden=YES;
            }
        }else{
            self.lbPlaceholder.hidden=YES;
        }
    }

    return YES;
}

@end
