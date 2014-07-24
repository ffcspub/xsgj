//
//  FXAdviceReportVC.m
//  用户反馈
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "FXAdviceReportVC.h"
#import "XTGLAPI.h"

@interface FXAdviceReportVC ()<UITextViewDelegate>
{
}
@end

@implementation FXAdviceReportVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtAdvice.returnKeyType = UIReturnKeyDone;
    [self setRightBarButtonItem];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.txtAdvice.layer.borderWidth  = 1.0f;
    self.txtAdvice.layer.borderColor  = [[UIColor orangeColor]CGColor];
    self.txtAdvice.layer.cornerRadius = 4.0f;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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

-(void)submitAction:(id)sender
{
    NSLog(@"用户反馈提交");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
