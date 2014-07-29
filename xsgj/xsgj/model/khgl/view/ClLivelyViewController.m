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
    [super.svImgContain setContentSize:CGSizeMake(super.ivPhoto5.frame.origin.x + super.ivPhoto5.frame.size.width, 0)];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    if(self.tfPhotoType.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写陈列情况" toView:self.view];
        return;
    }
    
    if(self.tfMark.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写备注" toView:self.view];
        return;
    }
    
    _iSendImgCount = 0;
    [_aryFileId removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self commitData];
}

- (IBAction)handleBtnTypeSelectClicked:(id)sender {
    NSMutableArray *aryItems = [[NSMutableArray alloc] init];
    for(BNDisplayCase *displayType in _aryClCaseData)
    {
        [aryItems addObject:displayType.CASE_NAME];
    }
    
    _popListView = [[LeveyPopListView alloc] initWithTitle:@"选择陈列情况" options:aryItems handler:^(NSInteger anIndex) {
        NSString *strSelect = [aryItems objectAtIndex:anIndex];
        self.tfPhotoType.text = strSelect;
        
        for(BNDisplayCase *displayType in _aryClCaseData)
        {
            if([displayType.CASE_NAME isEqualToString:strSelect])
            {
                self.clCaseSelect = displayType;
                break;
            }
        }
        
    }];
    [_popListView showInView:[UIApplication sharedApplication].delegate.window animated:NO];
}

- (void)loadTypeData
{
    _aryClCaseData = [BNDisplayCase searchWithWhere:nil orderBy:nil offset:0 count:100];
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
    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='33'",self.vistRecord.VISIT_NO] orderBy:nil];
    step.SYNC_STATE = 1;
    if (!step) {
        step = [[BNVisitStepRecord alloc]init];
        step.VISIT_NO = self.vistRecord.VISIT_NO;
        step.OPER_NUM =  step.OPER_NUM + 1;
        step.OPER_MENU = 33;
    }
    
    InsertDisplayVividHttpRequest *request = [[InsertDisplayVividHttpRequest alloc]init];
    // 基础用户信息
    request.SESSION_ID  = [ShareValue shareInstance].userInfo.SESSION_ID;
    request.CORP_ID     = [ShareValue shareInstance].userInfo.CORP_ID;
    request.DEPT_ID     = [ShareValue shareInstance].userInfo.DEPT_ID;
    request.USER_AUTH   = [ShareValue shareInstance].userInfo.USER_AUTH;
    request.USER_ID     = [ShareValue shareInstance].userInfo.USER_ID;
    // 附加信息
    request.CASE_ID    = self.clCaseSelect.CASE_ID;
    request.COMMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.CUST_ID    = self.customerInfo.CUST_ID;
    request.OPER_MENU  = @"33";
    request.REMARK     = self.tfMark.text;
    request.VISIT_NO   = self.vistRecord.VISIT_NO;
    
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
    
    [KHGLAPI insertDisplayVividByRequest:request success:^(InsertDisplayVividHttpResponse *response){
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.tfMark)
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
    
    return YES;
}

@end
