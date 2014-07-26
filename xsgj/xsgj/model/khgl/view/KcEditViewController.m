//
//  KcEditViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KcEditViewController.h"
#import "KcPreviewViewController.h"

@interface KcEditViewController ()

@end

@implementation KcEditViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotifyModifyData:) name:NOTIFICATION_MODIFY_DATA object:nil];
    // Do any additional setup after loading the view from its nib.
    
    _iExpandProdId = 0;
    _selectIndex = nil;
    _aryKcData = [[NSMutableArray alloc] init];
    [self initView];
    [self loadStockCommitBean];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_MODIFY_DATA object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"库存编辑";
    [_btnCommit setBackgroundImage:IMG_BTN_BLUE forState:UIControlStateNormal];
    [_btnCommit setBackgroundImage:IMG_BTN_BLUE_S forState:UIControlStateHighlighted];
    [_btnPreview setBackgroundImage:IMG_BTN_BLUE forState:UIControlStateNormal];
    [_btnPreview setBackgroundImage:IMG_BTN_BLUE_S forState:UIControlStateHighlighted];
}

#pragma mark - functions

- (IBAction)handleBtnCommitClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self sendReportRequest];
    
}

- (IBAction)handleBtnPreviewClicked:(id)sender {
    KcPreviewViewController *viewController = [[KcPreviewViewController alloc] initWithNibName:@"KcPreviewViewController" bundle:nil];
    viewController.aryData = _aryKcData;
    viewController.customerInfo = self.customerInfo;
    viewController.vistRecord = self.vistRecord;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadStockCommitBean
{
    for(BNProduct *product in _aryData)
    {
        
        NSArray *aryUnitBean = [BNUnitBean searchWithWhere:[NSString stringWithFormat:@"PROD_ID=%D",product.PROD_ID] orderBy:@"UNIT_ORDER" offset:0 count:100];
        BNUnitBean *unitBean = nil;
        if(aryUnitBean.count > 0)
        {
            unitBean = [aryUnitBean objectAtIndex:0];
        }
        
        StockCommitBean *kcCommitBean = [[StockCommitBean alloc] init];
        kcCommitBean.PROD_ID = product.PROD_ID;
        kcCommitBean.STOCK_NUM = 0;
        kcCommitBean.STOCK_NO = @"";
        kcCommitBean.PRODUCT_UNIT_ID = unitBean.PRODUCT_UNIT_ID;
        kcCommitBean.SPEC = product.SPEC;
        kcCommitBean.PROD_NAME = product.PROD_NAME;
        kcCommitBean.PRODUCT_UNIT_NAME = unitBean.UNITNAME;
        
        [_aryKcData addObject:kcCommitBean];
    }
}

// chenzftodo: 提交照片
//- (void)commitData
//{
//    if(_aryfileDatas.count > 0)
//    {
//        ImageFileInfo *fileInfo = [_aryfileDatas objectAtIndex:_iSendImgCount];
//        [SystemAPI uploadPhotoByFileName:self.title data:fileInfo.fileData success:^(NSString *fileId) {
//            [_aryFileId addObject:fileId];
//            _iSendImgCount ++;
//            if(_iSendImgCount < _aryfileDatas.count)
//            {
//                [self commitData];
//            }
//            else
//            {
//                [self sendStoreCameraRequest];
//            }
//            
//        } fail:^(BOOL notReachable, NSString *desciption) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [MBProgressHUD showError:desciption toView:self.view];
//            return;
//        }];
//    }
//}

- (void)sendReportRequest
{
    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='35'",self.vistRecord.VISIT_NO] orderBy:nil];
    step.SYNC_STATE = 1;
    if (!step) {
        step = [[BNVisitStepRecord alloc]init];
        step.VISIT_NO = self.vistRecord.VISIT_NO;
        step.OPER_NUM =  step.OPER_NUM + 1;
        step.OPER_MENU = 35;
    }
    
    StockCommitHttpRequest *request = [[StockCommitHttpRequest alloc]init];
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
    request.OPER_MENU  = @"35";
    // StockCommitBean
    request.DATA = _aryKcData ;
    
    [KHGLAPI commitStockByRequest:request success:^(StockCommitHttpResponse *response){
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
    return _aryKcData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectIndex.row && _selectIndex != nil)
    {
        return 174;
    }
    else
    {
       return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KcEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KCEDITCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KcEditCell" bundle:nil] forCellReuseIdentifier:@"KCEDITCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"KCEDITCELL"];
    }

    if(_aryKcData.count > 0)
    {
        StockCommitBean * bean = [_aryKcData objectAtIndex:indexPath.row];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_selectIndex)
    {
        _selectIndex = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_selectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        BOOL selectTheSameRow = indexPath.row == _selectIndex.row? YES:NO;
        if (!selectTheSameRow)
        {
            NSIndexPath *tempIndexPath = [_selectIndex copy];
            _selectIndex = nil;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tempIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            _selectIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_selectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            _selectIndex = nil;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

#pragma mark - KcEditCellDelegate

- (void)onBtnAddClicked:(KcEditCell *)cell
{

    StockCommitBean *kcCommitBean = [[StockCommitBean alloc] init];
    kcCommitBean.PROD_ID = cell.commitData.PROD_ID;
    kcCommitBean.STOCK_NUM = cell.commitData.STOCK_NUM;
    kcCommitBean.STOCK_NO = cell.commitData.STOCK_NO;
    kcCommitBean.PRODUCT_UNIT_ID = cell.commitData.PRODUCT_UNIT_ID;
    kcCommitBean.SPEC = cell.commitData.SPEC;
    kcCommitBean.PROD_NAME = cell.commitData.PROD_NAME;
    kcCommitBean.PRODUCT_UNIT_NAME = cell.commitData.PRODUCT_UNIT_NAME;
    [_aryKcData insertObject:kcCommitBean atIndex:cell.indexPath.row + 1];
    
    [_tvContain reloadData];
}

- (void)onBtnDelClicked:(KcEditCell *)cell
{
    [_aryKcData removeObjectAtIndex:cell.indexPath.row];
    [_tvContain reloadData];
}

- (void)onBtnPhotoClicked:(KcEditCell *)cell
{
    //[super takePhoto];
}

- (void)onBtnDateClicked:(KcEditCell *)cell
{
    _cellForDate = cell;
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker showTitle:@"请选择" inView:self.view];
}

ON_LKSIGNAL3(UIDatePicker, COMFIRM, signal){
    UIDatePicker *picker =  (UIDatePicker *)signal.sender;
    NSDate *selectDate = picker.date;
    if(_cellForDate)
    {
        _cellForDate.lbDate.text = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        _cellForDate.commitData.STOCK_NO = [selectDate stringWithFormat:@"yyyy-MM-dd"];
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
    [_tvContain reloadData];
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
