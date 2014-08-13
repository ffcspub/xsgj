//
//  ThEditViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ThEditViewController.h"
#import "ThPreviewViewController.h"

@interface ThEditViewController ()<UIImagePickerControllerDelegate>

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
    
    self.title = @"退货上报";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - functions

- (IBAction)handleBtnCommitClicked:(id)sender {
    BOOL bValid = [self checkCommitDataValid];
    if(!bValid)
    {
        return;
    }
    
    self.btnCommit.enabled = NO;
    _iSendImgCount = 0;
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [self commitData];
    
}

- (IBAction)handleBtnPreviewClicked:(id)sender {
    BOOL bValid = [self checkCommitDataValid];
    if(!bValid)
    {
        return;
    }
    
    ThPreviewViewController *viewController = [[ThPreviewViewController alloc] initWithNibName:@"ThPreviewViewController" bundle:nil];
    viewController.strMenuId = self.strMenuId;
    viewController.aryData = _aryKcData;
    viewController.customerInfo = self.customerInfo;
    viewController.vistRecord = self.vistRecord;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadKcCommitData
{
    for(BNProduct *product in super.aryData)
    {
        
        NSArray *aryUnitBean = [BNUnitBean searchWithWhere:[NSString stringWithFormat:@"PROD_ID=%D",product.PROD_ID] orderBy:@"UNIT_ORDER" offset:0 count:100];
        BNUnitBean *unitBean = nil;
        if(aryUnitBean.count > 0)
        {
            unitBean = [aryUnitBean objectAtIndex:0];
        }
   
        ThCommitData *ThCommitBean = [[ThCommitData alloc] init];
        ThCommitBean.BATCH = @"";
        ThCommitBean.SPEC = product.SPEC;;
        ThCommitBean.REMARK = @"";
        ThCommitBean.PRODUCT_UNIT_NAME = unitBean.UNITNAME;
        ThCommitBean.PRODUCT_NAME = product.PROD_NAME;
        ThCommitBean.ITEM_NUM = -1;
        ThCommitBean.PRODUCT_UNIT_ID = unitBean.PRODUCT_UNIT_ID;
        ThCommitBean.PROD_ID = product.PROD_ID;
        ThCommitBean.PhotoImg = [UIImage imageNamed:@"defaultPhoto"];
        [_aryKcData addObject:ThCommitBean];
    }
}

- (BOOL)checkCommitDataValid
{
    if(_aryKcData.count < 1)
    {
        [MBProgressHUD showError:@"请添加产品" toView:self.view];
        return NO;
    }
    
    for(ThCommitData * bean in _aryKcData)
    {
        if(bean.ITEM_NUM < 0)
        {
            [MBProgressHUD showError:@"请填写数量" toView:self.view];
            return NO;
        }
        
        if(bean.PRODUCT_UNIT_NAME.length < 1)
        {
            [MBProgressHUD showError:@"请填写单位" toView:self.view];
            return NO;
        }
        
        if(bean.BATCH.length < 1)
        {
            [MBProgressHUD showError:@"请填写日期" toView:self.view];
            return NO;
        }
        
        if(bean.REMARK.length < 1)
        {
            [MBProgressHUD showError:@"请输入退货原因" toView:self.view];
            return NO;
        }
    }
    
    return YES;
}

- (void)commitData
{
//    if(_aryKcData.count > 0)
//    {
//        ThCommitData *kcCommitBean = [_aryKcData objectAtIndex:_iSendImgCount];
//        [SystemAPI uploadPhotoByFileName:self.title data:kcCommitBean.PhotoData success:^(NSString *fileId) {
//            kcCommitBean.PHOTO1 = fileId;
//            _iSendImgCount ++;
//            if(_iSendImgCount < _aryKcData.count)
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
    
    
    if(_aryKcData.count > 0)
    {
        ThCommitData *kcCommitBean = [_aryKcData objectAtIndex:_iSendImgCount];
        if(kcCommitBean.PhotoData.length > 0)
        {
            [SystemAPI uploadPhotoByFileName:self.title data:kcCommitBean.PhotoData success:^(NSString *fileId) {
                kcCommitBean.PHOTO1 = fileId;
                _iSendImgCount ++;
                if(_iSendImgCount < _aryKcData.count)
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
                    if(_iSendImgCount < _aryKcData.count)
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
                    self.btnCommit.enabled = YES;
                    return;
                }
            }];
        }
        else
        {
            _iSendImgCount ++;
            if(_iSendImgCount < _aryKcData.count)
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
    for(ThCommitData *commitBean in _aryKcData)
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
                self.btnCommit.enabled = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMMITDATA_FIN object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        });
        
     }fail:^(BOOL notReachable, NSString *desciption){
         self.btnCommit.enabled = YES;

         [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
         if(notReachable)
         {
             step.SYNC_STATE = 1;
             [step save];
             
             OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:self.title];
             cache.VISIT_NO = self.vistRecord.VISIT_NO;
             [cache saveToDB];
             [MBProgressHUD showSuccess:DEFAULT_OFFLINEMESSAGE toView:ShareAppDelegate.window];
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

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        [MBProgressHUD showError:@"无法打开照相机,请检查设备" toView:self.view];
    }
}

#pragma mark - UIImagePickerControllerDelegate

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [image imageByScaleForSize:CGSizeMake(self.view.frame.size.width * 1.5, self.view.frame.size.height * 1.5)];
        if(_thCellForPhoto)
        {
            _thCellForPhoto.ivPhoto.image = image;
            _thCellForPhoto.thCommitData.PhotoImg = image;
            
            
            NSData *data;
            if (UIImagePNGRepresentation(image) == nil)
            {
                data = UIImageJPEGRepresentation(image, 1.0);
            }
            else
            {
                data = UIImagePNGRepresentation(image);
            }
            _thCellForPhoto.thCommitData.PhotoData = data;
        }
    }
    
    [picker dismissModalViewControllerAnimated:YES];
    picker = nil;
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
        ThCommitData * bean = [_aryKcData objectAtIndex:indexPath.row];
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
    ThCommitData *ThCommitBean = [[ThCommitData alloc] init];
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
    _thCellForPhoto = cell;
    [self takePhoto];
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
