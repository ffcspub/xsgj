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
#import "OfflineRequestCache.h"

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
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(submitAction:)];
}

-(void)submitAction:(id)sender
{
    if ([[self.txtAdvice text] length] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"意见反馈不能为空!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showSuccess:response.MESSAGE.MESSAGECONTENT toView:ShareAppDelegate.window];
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    fail:^(BOOL notReachable, NSString *desciption)
    {
        if (notReachable)
        {
            OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:self.title];
            [cache saveToDB];
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showSuccess:DEFAULT_OFFLINEMESSAGE toView:ShareAppDelegate.window];
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
