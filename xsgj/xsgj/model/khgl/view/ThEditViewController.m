//
//  ThEditViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ThEditViewController.h"
#import "ThPreviewViewController.h"

@interface ThEditViewController ()

@end

@implementation ThEditViewController

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
    
    self.title = @"退货编辑";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - functions

- (IBAction)handleBtnCommitClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self sendReportRequest];
    
}

- (IBAction)handleBtnPreviewClicked:(id)sender {
    ThPreviewViewController *viewController = [[ThPreviewViewController alloc] initWithNibName:@"ThPreviewViewController" bundle:nil];
    viewController.aryData = _aryKcData;
    viewController.customerInfo = self.customerInfo;
    viewController.vistRecord = self.vistRecord;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadStockCommitBean
{
    for(BNProduct *product in super.aryData)
    {
        
        NSArray *aryUnitBean = [BNUnitBean searchWithWhere:[NSString stringWithFormat:@"PROD_ID=%D",product.PROD_ID] orderBy:@"UNIT_ORDER" offset:0 count:100];
        BNUnitBean *unitBean = nil;
        if(aryUnitBean.count > 0)
        {
            unitBean = [aryUnitBean objectAtIndex:0];
        }
   
        OrderBackDetailBean *ThCommitBean = [[OrderBackDetailBean alloc] init];
        ThCommitBean.BATCH = @"";
        ThCommitBean.SPEC = product.SPEC;;
        ThCommitBean.REMARK = @"";
        ThCommitBean.PRODUCT_UNIT_NAME = unitBean.UNITNAME;
        ThCommitBean.PRODUCT_NAME = product.PROD_NAME;
        ThCommitBean.ITEM_NUM = 0;
        ThCommitBean.PRODUCT_UNIT_ID = unitBean.PRODUCT_UNIT_ID;
        ThCommitBean.PROD_ID = product.PROD_ID;
        [_aryKcData addObject:ThCommitBean];
    }
}

- (void)sendReportRequest
{
    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='37'",self.vistRecord.VISIT_NO] orderBy:nil];
    step.SYNC_STATE = 1;
    if (!step) {
        step = [[BNVisitStepRecord alloc]init];
        step.VISIT_NO = self.vistRecord.VISIT_NO;
        step.OPER_NUM =  step.OPER_NUM + 1;
        step.OPER_MENU = 37;
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
    request.OPER_MENU  = @"37";
    request.DATA  = _aryKcData;
    
    [KHGLAPI insertOrderBackByRequest:request success:^(InsertOrderBackHttpResponse *response){
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectIndex.row && _selectIndex != nil)
    {
        return 204;
    }
    else
    {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ThEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"THEDITCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ThEditCell" bundle:nil] forCellReuseIdentifier:@"THEDITCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"THEDITCELL"];
    }
    
    if(_aryKcData.count > 0)
    {
        OrderBackDetailBean * bean = [_aryKcData objectAtIndex:indexPath.row];
        cell.indexPath = indexPath;
        [cell setCellWithValue:bean];
    }
    
    if (indexPath.row == _selectIndex.row && _selectIndex != nil)
    {
        cell.vDetail.hidden = NO;
    }
    else
    {
        cell.vDetail.hidden = YES;
    }
    
    cell.delegate = self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - KcEditCellDelegate

- (void)onBtnAddClicked:(ThEditCell *)cell
{
    OrderBackDetailBean *ThCommitBean = [[OrderBackDetailBean alloc] init];
    ThCommitBean.BATCH = cell.thCommitData.BATCH;
    ThCommitBean.SPEC = cell.thCommitData.SPEC;;
    ThCommitBean.REMARK = cell.thCommitData.REMARK;
    ThCommitBean.PRODUCT_UNIT_NAME = cell.thCommitData.PRODUCT_UNIT_NAME;
    ThCommitBean.PRODUCT_NAME = cell.thCommitData.PRODUCT_NAME;
    ThCommitBean.ITEM_NUM = cell.thCommitData.ITEM_NUM;
    ThCommitBean.PRODUCT_UNIT_ID = cell.thCommitData.PRODUCT_UNIT_ID;
    ThCommitBean.PROD_ID = cell.thCommitData.PROD_ID;
    [_aryKcData insertObject:ThCommitBean atIndex:cell.indexPath.row + 1];
    
    [self.tvContain reloadData];
}

- (void)onBtnDelClicked:(ThEditCell *)cell
{
    [_aryKcData removeObjectAtIndex:cell.indexPath.row];
    [self.tvContain reloadData];
}

- (void)onBtnPhotoClicked:(ThEditCell *)cell
{
    //[super takePhoto];
}

- (void)onBtnDateClicked:(ThEditCell *)cell
{
    _thCellForDate = cell;
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker showTitle:@"请选择" inView:self.view];
}

ON_LKSIGNAL3(UIDatePicker, COMFIRM, signal){
    UIDatePicker *picker =  (UIDatePicker *)signal.sender;
    NSDate *selectDate = picker.date;
    if(_thCellForDate)
    {
        _thCellForDate.lbDate.text = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        _thCellForDate.thCommitData.BATCH = [selectDate stringWithFormat:@"yyyy-MM-dd"];
    }
}

- (void)handleNotifyModifyData:(NSNotification *)note
{
    NSDictionary *dicInfo = [note object];
    NSArray *sourceData = [dicInfo objectForKey:@"data"];
    NSNumber *number = [dicInfo objectForKey:@"prodid"];
    
    _selectIndex = nil;
    _aryKcData = [[NSMutableArray alloc] initWithArray:sourceData];
    _iExpandProdId = number.intValue;
    [self.tvContain reloadData];
}

#pragma mark - UIImagePickerControllerDelegate

////当选择一张图片后进入这里
//-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    //当选择的类型是图片
//    if ([type isEqualToString:@"public.image"])
//    {
//        //先把图片转成NSData
//        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        image = [image imageByScaleForSize:CGSizeMake(self.view.frame.size.width * 1.5, self.view.frame.size.height * 1.5)];
//        // todo: 显示，数据处理
//        
//        ImageFileInfo *imageInfo = [[ImageFileInfo alloc]initWithImage:image];
//        [_aryfileDatas addObject:imageInfo];
//        
//    }
//    [picker dismissModalViewControllerAnimated:YES];
//    _picker = nil;
//}

@end
