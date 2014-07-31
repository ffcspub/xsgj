//
//  FXAdviceReportVC.m
//  用户反馈
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "FXAdviceReportVC.h"
#import "XZGLAPI.h"
#import "ShareValue.h"
#import "NSDate+Helper.h"
#import "MBProgressHUD+Add.h"

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
    // 字数限制
    NSString *textString = textView.text ;
    NSUInteger length = [textString length];
    BOOL bChange =YES;
    if (length >= 200)
    {
        bChange = NO;
    }
    if (range.length == 1)
    {
        bChange = YES;
    }
    return bChange;
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
    if ([[self.txtAdvice text] length] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"意见反馈不能为空!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AddAdviceHttpRequest *request = [[AddAdviceHttpRequest alloc]init];
    request.SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
    request.CORP_ID    = [ShareValue shareInstance].userInfo.CORP_ID;
    request.DEPT_ID    = [ShareValue shareInstance].userInfo.DEPT_ID;
    request.USER_AUTH  = [ShareValue shareInstance].userInfo.USER_AUTH;
    request.USER_ID    = [ShareValue shareInstance].userInfo.USER_ID;
    request.CONTENT    = [self.txtAdvice text];
    request.COMMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    [XZGLAPI addAdviceByRequest:request success:^(AddAdviceHttpResponse *response)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.MESSAGE.MESSAGECONTENT toView:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
        {
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
        
    }
    fail:^(BOOL notReachable, NSString *desciption)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
