//
//  JpReportViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "JpReportViewController.h"

@interface JpReportViewController ()

@end

@implementation JpReportViewController

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
    self.title = @"竞品上报";
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(handleNavBarRight)];
    
    [super.svContain setContentSize:CGSizeMake(0, super.svImgContain.frame.origin.y + super.svImgContain.frame.size.height + 10)];
    [super.svImgContain setContentSize:CGSizeMake(super.ivPhoto5.frame.origin.x + super.ivPhoto5.frame.size.width, 0)];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    if(_tfBrand.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写品牌" toView:self.view];
        return;
    }
    
    if(_tfName.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写名称" toView:self.view];
        return;
    }
    
    if(_tfSpec.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写规格" toView:self.view];
        return;
    }
    
    if(_tfPromotion.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写促销方式" toView:self.view];
        return;
    }
    
    if(_tfPrice.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写销售价格" toView:self.view];
        return;
    }
    
    if(_tfCustomer.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写消费者活动" toView:self.view];
        return;
    }
    
    if(_aryfileDatas.count < 1)
    {
        [MBProgressHUD showError:@"请拍照片" toView:self.view];
        return;
    }
    
    _iSendImgCount = 0;
    [_aryFileId removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self commitData];
}

- (void)commitData
{
    if(_aryfileDatas.count > 0)
    {
        ImageFileInfo *fileInfo = [_aryfileDatas objectAtIndex:_iSendImgCount];
        [SystemAPI uploadPhotoByFileName:self.title data:fileInfo.fileData success:^(NSString *fileId) {
            [_aryFileId addObject:fileId];
            _iSendImgCount ++;
            if(_iSendImgCount < _aryfileDatas.count)
            {
                [self commitData];
            }
            else
            {
                [self sendStoreCameraRequest];
            }
            
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
            return;
        }];
    }
}

- (void)sendStoreCameraRequest
{
    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='39'",self.vistRecord.VISIT_NO] orderBy:nil];
    step.SYNC_STATE = 1;
    if (!step) {
        step = [[BNVisitStepRecord alloc]init];
        step.VISIT_NO = self.vistRecord.VISIT_NO;
        step.OPER_NUM =  step.OPER_NUM + 1;
        step.OPER_MENU = 39;
    }
    
    InsertCompeteHttpRequest *request = [[InsertCompeteHttpRequest alloc]init];
    // 基础用户信息
    request.SESSION_ID  = [ShareValue shareInstance].userInfo.SESSION_ID;
    request.CORP_ID     = [ShareValue shareInstance].userInfo.CORP_ID;
    request.DEPT_ID     = [ShareValue shareInstance].userInfo.DEPT_ID;
    request.USER_AUTH   = [ShareValue shareInstance].userInfo.USER_AUTH;
    request.USER_ID     = [ShareValue shareInstance].userInfo.USER_ID;
    // 附加信息
    request.COMMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.VISIT_NO   = self.vistRecord.VISIT_NO;
    request.ACTIVITY  = _tfCustomer.text;
    request.BRAND     = _tfBrand.text;
    request.NAME      = _tfName.text;
    request.PRICE     = _tfPrice.text;
    request.PROMOTION = _tfPromotion.text;
    request.REMARK    = self.tfMark.text;
    request.SPEC      = _tfSpec.text;
    request.CUST_ID    = self.customerInfo.CUST_ID;
    request.OPER_MENU  = @"39";

    if(_aryFileId.count >= 1)
    {
        request.PHOTO1 = [_aryFileId objectAtIndex:0];
    }
    
    if(_aryFileId.count >= 2)
    {
        request.PHOTO2 = [_aryFileId objectAtIndex:1];
    }
    
    if(_aryFileId.count >= 3)
    {
        request.PHOTO3 = [_aryFileId objectAtIndex:2];
    }
    
    if(_aryFileId.count >= 4)
    {
        request.PHOTO4 = [_aryFileId objectAtIndex:3];
    }
    
    if(_aryFileId.count >= 5)
    {
        request.PHOTO5 = [_aryFileId objectAtIndex:4];
    }
    
    [KHGLAPI insertCompeteByRequest:request success:^(InsertCompeteHttpResponse *response){
        step.SYNC_STATE = 2;
        [step save];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMMITDATA_FIN object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
        
     }fail:^(BOOL notReachable, NSString *desciption){
         [step save];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD showError:desciption toView:self.view];
         
     }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.tfPrice)
    {
        NSString *strRule = @"0123456789.\n";
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:strRule] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL bNumber = [string isEqualToString:filtered];
        if(!bNumber)
        {
            return NO;
        }
        
        if([textField.text rangeOfString:@"."].length > 0)
        {
            if([string isEqualToString:@"."])
            {
                return NO;
            }
        }
        
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        NSInteger flag=0;
        const NSInteger limited = 2;
        for (int i = futureString.length-1; i>=0; i--) {
            if ([futureString characterAtIndex:i] == '.') {
                
                if (flag > limited) {
                    return NO;
                }
                
                break;
            }
            flag++;
        }
        
        if(textField.text.length < 9 || [string isEqualToString:@""])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if (textField == self.tfMark)
    {
        if(textField.text.length < 200 || [string isEqualToString:@""])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        if(textField.text.length < 20 || [string isEqualToString:@""])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}


@end
