//
//  DhEditViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DhEditViewController.h"
#import "DhPreviewViewController.h"

@interface DhEditViewController ()

@end

@implementation DhEditViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotifySelectPartner:) name:NOTIFICATION_SELECTPARTNER_FIN object:nil];
    // Do any additional setup after loading the view from its nib.
    
    _aryDhData = [[NSMutableArray alloc] init];
    [self initView];
    [self loadOrderItemBean];
    [self loadPartnerTypeData];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_MODIFY_DATA object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_SELECTPARTNER_FIN object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"订货上报";
    
    [_btnCommit setBackgroundImage:IMG_BTN_BLUE forState:UIControlStateNormal];
    [_btnCommit setBackgroundImage:IMG_BTN_BLUE_S forState:UIControlStateHighlighted];
    [_btnPreview setBackgroundImage:IMG_BTN_BLUE forState:UIControlStateNormal];
    [_btnPreview setBackgroundImage:IMG_BTN_BLUE_S forState:UIControlStateHighlighted];
}

#pragma mark - functions

- (IBAction)handleBtnTypeClicked:(id)sender {
    DhEditSelectTreeViewController *selectTreeViewController = [[DhEditSelectTreeViewController alloc] initWithNibName:@"SelectTreeViewController" bundle:nil];
    selectTreeViewController.data = _aryPartnerTreeData;
    [self.navigationController pushViewController:selectTreeViewController animated:YES];
}

- (IBAction)handleBtnNameClicked:(id)sender {
    NSMutableArray *aryItems = [[NSMutableArray alloc] init];
    for(BNPartnerInfoBean *info in _aryPartnerInfoData)
    {
        [aryItems addObject:info.PARTNER_NAME];
    }
    
    LeveyPopListView *popListView = [[LeveyPopListView alloc] initWithTitle:@"选择合作商" options:aryItems handler:^(NSInteger anIndex) {
        NSString *strSelect = [aryItems objectAtIndex:anIndex];
        _tfName.text = strSelect;
        
        for(BNPartnerInfoBean *info in _aryPartnerInfoData)
        {
            if([info.PARTNER_NAME isEqualToString:strSelect])
            {
                _PartnerSelect = info;
            }
        }
    }];
    [popListView showInView:[UIApplication sharedApplication].delegate.window animated:NO];
}

- (IBAction)handleCommit:(id)sender {
    BOOL bValid = [self checkCommitDataValid];
    if(!bValid)
    {
        return;
    }

    _btnCommit.enabled = NO;
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [self sendReportRequest];
}

- (IBAction)handlePreview:(id)sender {
    BOOL bValid = [self checkCommitDataValid];
    if(!bValid)
    {
        return;
    }
    
    DhPreviewViewController *viewController = [[DhPreviewViewController alloc] initWithNibName:@"DhPreviewViewController" bundle:nil];
    viewController.strMenuId = self.strMenuId;
    viewController.aryData = _aryDhData;
    viewController.customerInfo = self.customerInfo;
    viewController.vistRecord = self.vistRecord;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadOrderItemBean
{
    for(BNProduct *product in _aryData)
    {
        NSArray *aryUnitBean = [BNUnitBean searchWithWhere:[NSString stringWithFormat:@"PROD_ID=%D",product.PROD_ID] orderBy:@"UNIT_ORDER" offset:0 count:100];
        BNUnitBean *unitBean = nil;
        if(aryUnitBean.count > 0)
        {
            unitBean = [aryUnitBean objectAtIndex:0];
        }
        
        OrderItemBean *bean = [[OrderItemBean alloc]init];
        bean.GIFT_NAME = @"";
        bean.UNIT_NAME = unitBean.UNITNAME;
        bean.SPEC = product.SPEC;
        bean.PROD_NAME = product.PROD_NAME;
        bean.GIFT_UNIT_NAME = @"";
        bean.TOTAL_PRICE = 0;
        bean.ITEM_PRICE = product.PRICE.doubleValue;
        bean.PRODUCT_UNIT_ID = unitBean.PRODUCT_UNIT_ID;
        bean.PROD_ID = unitBean.PROD_ID;
        bean.GIFT_TOTAL = @"";
        bean.GIFT_PRICE =@"";
        bean.ITEM_NUM = -1;
        bean.GIFT_NUM = @"";
        
        [_aryDhData addObject:bean];
    }
}

- (void)loadPartnerInfoData:(int)typeId
{
    _aryPartnerInfoData = [BNPartnerInfoBean searchWithWhere:[NSString stringWithFormat:@"TYPE_ID=%D",typeId] orderBy:nil offset:0 count:1000];
}

- (void)loadPartnerTypeData
{
    _aryPartnerTypeData = [BNPartnerType searchWithWhere:nil orderBy:@"ORDER_NO" offset:0 count:1000];
    _aryPartnerTreeData = [self makePartnerTreeData];
}

- (NSArray *)makePartnerTreeData
{
    NSMutableArray *parentTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:_aryPartnerTypeData];
    for(BNPartnerType *partnerType in _aryPartnerTypeData)
    {
        NSLog(@"%d,%d",partnerType.TYPE_PID,partnerType.TYPE_ID);
    }
    
    
    for(BNPartnerType *partnerType in _aryPartnerTypeData)
    {
        if(partnerType.TYPE_PID == 0)
        {
            TreeData *aryData = [[TreeData alloc] init];
            aryData.name = partnerType.TYPE_NAME;
            aryData.dataInfo = partnerType;
            [parentTree addObject:aryData];
            
            [arySourceData removeObject:partnerType];
        }
    }
    
    _iMakeTreeCount = 0;
    [self makeSubCusTypeTreeData:arySourceData ParentTreeData:parentTree];
    return parentTree;
}

- (void)makeSubCusTypeTreeData:(NSArray *)sourceData ParentTreeData:(NSMutableArray *)parentTree
{
    NSMutableArray *aryChildTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:sourceData];
    for(BNPartnerType *partnerType in sourceData)
    {
        for(TreeData *parentData in parentTree)
        {
            BNPartnerType *parentPartnerType = (BNPartnerType *)parentData.dataInfo;
            if(partnerType.TYPE_PID == parentPartnerType.TYPE_ID)
            {
                TreeData *aryData = [[TreeData alloc] init];
                aryData.name = partnerType.TYPE_NAME;
                aryData.dataInfo = partnerType;
                [parentData.children addObject:aryData];
                
                [aryChildTree addObject:aryData];
                [arySourceData removeObject:partnerType];
            }
        }
    }
    
    if(arySourceData.count > 0 && _iMakeTreeCount <= 6)
    {
        _iMakeTreeCount ++;
        [self makeSubCusTypeTreeData:arySourceData ParentTreeData:aryChildTree];
    }
}

- (BOOL)checkCommitDataValid
{
    if(_aryDhData.count < 1)
    {
        [MBProgressHUD showError:@"请添加产品" toView:self.view];
        return NO;
    }
    
//    if(_tfType.text.length < 1)
//    {
//        [MBProgressHUD showError:@"请填写合作商类型" toView:self.view];
//        return NO;
//    }
    
//    if(_tfName.text.length < 1)
//    {
//        [MBProgressHUD showError:@"请填写合作商名称" toView:self.view];
//        return NO;
//    }
    
    for(OrderItemBean * bean in _aryDhData)
    {
        if(bean.ITEM_PRICE < 0)
        {
            [MBProgressHUD showError:@"请填写单价" toView:self.view];
            return NO;
        }
        
        if(bean.ITEM_NUM < 0)
        {
            [MBProgressHUD showError:@"请填写数量" toView:self.view];
            return NO;
        }
        
        if(bean.UNIT_NAME.length < 1)
        {
            [MBProgressHUD showError:@"请填写单位" toView:self.view];
            return NO;
        }
    }
    
    return YES;
}

- (void)sendReportRequest
{
//    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='36'",self.vistRecord.VISIT_NO] orderBy:nil];
//    step.SYNC_STATE = 1;
//    if (!step) {
//        step = [[BNVisitStepRecord alloc]init];
//        step.VISIT_NO = self.vistRecord.VISIT_NO;
//        step.OPER_NUM =  step.OPER_NUM + 1;
//        step.OPER_MENU = 36;
//    }
    
    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='%@'",self.vistRecord.VISIT_NO,self.strMenuId] orderBy:nil];
    step.SYNC_STATE = 1;
    if (!step) {
        step = [[BNVisitStepRecord alloc]init];
        step.VISIT_NO = self.vistRecord.VISIT_NO;
        step.OPER_NUM =  step.OPER_NUM + 1;
        step.OPER_MENU = self.strMenuId.intValue;
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
    request.OPER_MENU  = self.strMenuId;
    request.DATA = _aryDhData;
    
    [KHGLAPI commitOrderByRequest:request success:^(OrderCommitHttpResponse *response){
        step.SYNC_STATE = 2;
        [step save];
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showSuccess:@"提交成功" toView:ShareAppDelegate.window];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                _btnCommit.enabled = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMMITDATA_FIN object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        });
        
     }fail:^(BOOL notReachable, NSString *desciption){
         _btnCommit.enabled = YES;

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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryDhData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectIndex.row && _selectIndex != nil)
    {
        return 284;
    }
    else
    {
        return 44;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DhEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DHEDITCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"DhEditCell" bundle:nil] forCellReuseIdentifier:@"DHEDITCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DHEDITCELL"];
    }
    
    if(_aryDhData.count > 0)
    {
        OrderItemBean *orderItemBean = [_aryDhData objectAtIndex:indexPath.row];
        cell.indexPath = indexPath;
        [cell setCellWithValue:orderItemBean];
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


- (void)handleNotifySelectPartner:(NSNotification *)note
{
    BNPartnerType *partnerType = [note object];
    _tfType.text = partnerType.TYPE_NAME;
    [self loadPartnerInfoData:partnerType.TYPE_ID];
}

- (void)handleNotifyModifyData:(NSNotification *)note
{
    NSDictionary *dicInfo = [note object];
    NSArray *sourceData = [dicInfo objectForKey:@"data"];
    NSNumber *number = [dicInfo objectForKey:@"prodid"];
    
    _selectIndex = nil;
    _aryDhData = [[NSMutableArray alloc] initWithArray:sourceData];
    _iExpandProdId = number.intValue;
    [_tvContain reloadData];
}

#pragma mark - DhEditCellDelegate

- (void)onBtnAddClicked:(DhEditCell *)cell
{
    OrderItemBean *orderItemBean = [[OrderItemBean alloc] init];
    orderItemBean.GIFT_NAME = cell.commitData.GIFT_NAME;
    orderItemBean.UNIT_NAME = cell.commitData.UNIT_NAME;
    orderItemBean.SPEC = cell.commitData.SPEC;
    orderItemBean.PROD_NAME = cell.commitData.PROD_NAME;
    orderItemBean.GIFT_UNIT_NAME = cell.commitData.GIFT_UNIT_NAME;
    orderItemBean.TOTAL_PRICE = cell.commitData.TOTAL_PRICE;
    orderItemBean.ITEM_PRICE = cell.commitData.ITEM_PRICE;
    orderItemBean.PRODUCT_UNIT_ID = cell.commitData.PRODUCT_UNIT_ID;
    orderItemBean.PROD_ID = cell.commitData.PROD_ID;
    orderItemBean.GIFT_TOTAL = cell.commitData.GIFT_TOTAL;
    orderItemBean.GIFT_PRICE =cell.commitData.GIFT_PRICE;
    orderItemBean.ITEM_NUM = cell.commitData.ITEM_NUM;
    orderItemBean.GIFT_NUM = cell.commitData.GIFT_NUM;
    [_aryDhData insertObject:orderItemBean atIndex:cell.indexPath.row + 1];
    
    [_tvContain reloadData];
}

- (void)onBtnDelClicked:(DhEditCell *)cell
{
    [_aryDhData removeObjectAtIndex:cell.indexPath.row];
    [_tvContain reloadData];
}

@end
