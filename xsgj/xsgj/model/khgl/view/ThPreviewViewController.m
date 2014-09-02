//
//  ThPreviewViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ThPreviewViewController.h"

@interface ThPreviewViewController ()

@end

@implementation ThPreviewViewController

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
    
    _arySourceData = [[NSMutableArray alloc] initWithArray:self.aryData];
    [self initView];
    [self adjustTableViewHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"退货预览";
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(handleNavBarRight)];
    
    [self.svSubContain setContentSize:CGSizeMake(520, 0)];
    
}

#pragma mark - functions

-(void)backAction{
    NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:_arySourceData,@"data",[NSNumber numberWithInt:0],@"prodid", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MODIFY_DATA object:dicInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleNavBarRight
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    _iSendImgCount = 0;
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [self commitData];
}

- (void)adjustTableViewHeight
{
    CGRect frame = self.tvTypeName.frame;
    frame.size.height = (_arySourceData.count + 1) * 44;
    self.tvTypeName.frame = frame;
    
    frame = self.tvDetail.frame;
    frame.size.height = (_arySourceData.count + 1) * 44;
    self.tvDetail.frame = frame;
    
    frame = self.svSubContain.frame;
    frame.size.height = (_arySourceData.count + 1) * 44;
    self.svSubContain.frame = frame;
    
    [self.svMainContain setContentSize:CGSizeMake(0, self.tvTypeName.frame.origin.y + self.tvTypeName.frame.size.height + 70)];
    
}

- (void)commitData
{
//    if(_arySourceData.count > 0)
//    {
//        ThCommitData *kcCommitBean = [_arySourceData objectAtIndex:_iSendImgCount];
//        [SystemAPI uploadPhotoByFileName:self.title data:kcCommitBean.PhotoData success:^(NSString *fileId) {
//            kcCommitBean.PHOTO1 = fileId;
//            _iSendImgCount ++;
//            if(_iSendImgCount < _arySourceData.count)
//            {
//                [self commitData];
//            }
//            else
//            {
//                [self sendReportRequest];
//            }
//            
//        } fail:^(BOOL notReachable, NSString *desciption) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [MBProgressHUD showError:desciption toView:self.view];
//            return;
//        }];
//    }
    
    if(_arySourceData.count > 0)
    {
        ThCommitData *kcCommitBean = [_arySourceData objectAtIndex:_iSendImgCount];
        if(kcCommitBean.PhotoData.length > 0)
        {
            [SystemAPI uploadPhotoByFileName:@"退货上报" data:kcCommitBean.PhotoData success:^(NSString *fileId) {
                kcCommitBean.PHOTO1 = fileId;
                _iSendImgCount ++;
                if(_iSendImgCount < _arySourceData.count)
                {
                    [self commitData];
                }
                else
                {
                    [self sendReportRequest];
                }
                
            } fail:^(BOOL notReachable, NSString *desciption,NSString *fileId) {
                if(notReachable)
                {
                    kcCommitBean.PHOTO1 = fileId;
                    _iSendImgCount ++;
                    if(_iSendImgCount < _arySourceData.count)
                    {
                        [self commitData];
                    }
                    else
                    {
                        [self sendReportRequest];
                    }
                }
                else
                {
                    [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
                    [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    return;
                }
            }];
        }
        else
        {
            _iSendImgCount ++;
            if(_iSendImgCount < _arySourceData.count)
            {
                [self commitData];
            }
            else
            {
                [self sendReportRequest];
            }
        }
    }
}

- (void)sendReportRequest
{
//    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='37'",self.vistRecord.VISIT_NO] orderBy:nil];
//    step.SYNC_STATE = 1;
//    if (!step) {
//        step = [[BNVisitStepRecord alloc]init];
//        step.VISIT_NO = self.vistRecord.VISIT_NO;
//        step.OPER_NUM =  step.OPER_NUM + 1;
//        step.OPER_MENU = 37;
//    }
    
    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='%@'",self.vistRecord.VISIT_NO,self.strMenuId] orderBy:nil];
    step.SYNC_STATE = 1;
    if (!step) {
        step = [[BNVisitStepRecord alloc]init];
        step.VISIT_NO = self.vistRecord.VISIT_NO;
        step.OPER_NUM =  step.OPER_NUM + 1;
        step.OPER_MENU = self.strMenuId.intValue;
    }
    
    InsertOrderBackHttpRequest *request = [[InsertOrderBackHttpRequest alloc]init];
    // 基础用户信息
    request.SESSION_ID  = [ShareValue shareInstance].userInfo.SESSION_ID;
    request.CORP_ID     = [ShareValue shareInstance].userInfo.CORP_ID;
    request.DEPT_ID     = [ShareValue shareInstance].userInfo.DEPT_ID;
    request.USER_AUTH   = [ShareValue shareInstance].userInfo.USER_AUTH;
    request.USER_ID     = [ShareValue shareInstance].userInfo.USER_ID;
    // 附加信息
    request.COMMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.VISIT_NO   = self.vistRecord.VISIT_NO;
    request.CUST_ID    = self.customerInfo.CUST_ID;
    request.OPER_MENU  = self.strMenuId;
    
    NSMutableArray *aryCommit = [[NSMutableArray alloc] init];
    for(ThCommitData *commitBean in _arySourceData)
    {
        OrderBackDetailBean *thCommitBean = [[OrderBackDetailBean alloc] init];
        thCommitBean.PROD_ID = commitBean.PROD_ID;
        thCommitBean.PRODUCT_UNIT_ID = commitBean.PRODUCT_UNIT_ID;
        thCommitBean.ITEM_NUM = commitBean.ITEM_NUM;
        thCommitBean.REMARK = commitBean.REMARK;
        thCommitBean.BATCH = commitBean.BATCH;
        thCommitBean.SPEC = commitBean.SPEC;
        thCommitBean.PRODUCT_UNIT_NAME = commitBean.PRODUCT_UNIT_NAME;
        thCommitBean.PRODUCT_NAME = commitBean.PRODUCT_NAME;
        thCommitBean.PHOTO1 = commitBean.PHOTO1;
        [aryCommit addObject:thCommitBean];
    }
    request.DATA  = aryCommit;
    
    [KHGLAPI insertOrderBackByRequest:request success:^(InsertOrderBackHttpResponse *response){
        step.SYNC_STATE = 2;
        [step save];
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showSuccess:@"提交成功" toView:ShareAppDelegate.window];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.rightBarButtonItem.enabled = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMMITDATA_FIN object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        });
        
    }fail:^(BOOL notReachable, NSString *desciption){
        self.navigationItem.rightBarButtonItem.enabled = YES;

        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        if(notReachable)
        {
            step.SYNC_STATE = 1;
            [step save];
            
            OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:self.title];
            cache.VISIT_NO = self.vistRecord.VISIT_NO;
            [cache saveToDB];
            [MBProgressHUD showSuccess:DEFAULT_OFFLINE_MESSAGE_REPORT toView:ShareAppDelegate.window];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                sleep(1);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMMITDATA_FIN object:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            });
        }
        else
        {
            [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
        }
        
    }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arySourceData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tvTypeName)
    {
        PreviewNameCell *nameCell = [tableView dequeueReusableCellWithIdentifier:@"PREVIEWNAMECELL"];
        if (!nameCell) {
            [tableView registerNib:[UINib nibWithNibName:@"PreviewNameCell" bundle:nil] forCellReuseIdentifier:@"PREVIEWNAMECELL"];
            nameCell = [tableView dequeueReusableCellWithIdentifier:@"PREVIEWNAMECELL"];
        }
        
        if(_arySourceData.count > 0)
        {
            ThCommitData *commitBean = [_arySourceData objectAtIndex:indexPath.row];
            nameCell.lbName.text = commitBean.PRODUCT_NAME;
        }
        
        nameCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return nameCell;
    }
    else if(tableView == self.tvDetail)
    {
        ThPreviewDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"THPREVIEWDETAILCELL"];
        if (!detailCell) {
            [tableView registerNib:[UINib nibWithNibName:@"ThPreviewDetailCell" bundle:nil] forCellReuseIdentifier:@"THPREVIEWDETAILCELL"];
            detailCell = [tableView dequeueReusableCellWithIdentifier:@"THPREVIEWDETAILCELL"];
        }
        
        if(_arySourceData.count > 0)
        {
            ThCommitData *commitBean = [_arySourceData objectAtIndex:indexPath.row];
            [detailCell setCellValue:commitBean];
        }
        
        detailCell.delegate = self;
        detailCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return detailCell;
    }
    
    return nil;
}

#pragma mark - PreviweDetailCellDelegate

- (void)onBtnModifyClicked:(ThPreviewDetailCell *)cell
{
    NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:_arySourceData,@"data",[NSNumber numberWithInt:cell.cellCommitBean.PROD_ID],@"prodid", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MODIFY_DATA object:dicInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onBtnCancelClicked:(ThPreviewDetailCell *)cell
{
    [_arySourceData removeObject:cell.cellCommitBean];
    [self.tvTypeName reloadData];
    [self.tvDetail reloadData];
    
    [self adjustTableViewHeight];
}


@end