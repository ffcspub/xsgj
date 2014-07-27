//
//  DhPreviewViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DhPreviewViewController.h"

@interface DhPreviewViewController ()

@end

@implementation DhPreviewViewController

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
    self.title = @"订货预览";
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(handleNavBarRight)];
    
    [self.svSubContain setContentSize:CGSizeMake(640, 0)];
    
}

#pragma mark - functions

- (void)handleNavBarRight
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self sendReportRequest];
    
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

- (void)sendReportRequest
{
    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='36'",self.vistRecord.VISIT_NO] orderBy:nil];
    step.SYNC_STATE = 1;
    if (!step) {
        step = [[BNVisitStepRecord alloc]init];
        step.VISIT_NO = self.vistRecord.VISIT_NO;
        step.OPER_NUM =  step.OPER_NUM + 1;
        step.OPER_MENU = 36;
    }
    
    OrderCommitHttpRequest *request = [[OrderCommitHttpRequest alloc]init];
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
    request.OPER_MENU  = @"36";
    request.DATA = _arySourceData;
    
    [KHGLAPI commitOrderByRequest:request success:^(OrderCommitHttpResponse *response){
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
            OrderItemBean *commitBean = [_arySourceData objectAtIndex:indexPath.row];
            nameCell.lbName.text = commitBean.PROD_NAME;
        }
        
        nameCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return nameCell;
    }
    else if(tableView == self.tvDetail)
    {
        DhPreviweDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"DHPREVIEWDETAILCELL"];
        if (!detailCell) {
            [tableView registerNib:[UINib nibWithNibName:@"DhPreviweDetailCell" bundle:nil] forCellReuseIdentifier:@"DHPREVIEWDETAILCELL"];
            detailCell = [tableView dequeueReusableCellWithIdentifier:@"DHPREVIEWDETAILCELL"];
        }
        
        if(_arySourceData.count > 0)
        {
            OrderItemBean *commitBean = [_arySourceData objectAtIndex:indexPath.row];
            [detailCell setCellValue:commitBean];
        }
        
        detailCell.delegate = self;
        detailCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return detailCell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PreviweDetailCellDelegate

- (void)onBtnModifyClicked:(DhPreviweDetailCell *)cell
{
    NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:_arySourceData,@"data",[NSNumber numberWithInt:cell.cellCommitBean.PROD_ID],@"prodid", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MODIFY_DATA object:dicInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onBtnCancelClicked:(DhPreviweDetailCell *)cell
{
    [_arySourceData removeObject:cell.cellCommitBean];
    [self.tvTypeName reloadData];
    [self.tvDetail reloadData];
    
    [self adjustTableViewHeight];
}


@end