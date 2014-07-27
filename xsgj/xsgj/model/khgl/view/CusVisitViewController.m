//
//  CusVisitViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-16.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "CusVisitViewController.h"
#import "LKDBHelper.h"
#import "BNMobileMenu.h"
#import "BNVisitStepRecord.h"
#import "DzPhotoViewController.h"
#import "CLPhotoViewController.h"
#import "ClLivelyViewController.h"
#import "ClCostViewController.h"
#import "HdReportViewController.h"
#import "JpReportViewController.h"
#import "KcReportViewController.h"
#import "DhReportViewController.h"
#import "ThReportViewController.h"
#import "MapUtils.h"
#import "MapAddressVC.h"



@interface CusVisitViewController ()<MapAddressVCDelegate>
{
    NSArray *_aryFuncItems;
    IBActionSheet *_actionSheet;
    BOOL _isLocationSuccess;
    BOOL _isManualLocation;
    CLLocationCoordinate2D manualCoordinate;
    BNVisitCondition *_condition;
    NSString *_address;
}

@end

@implementation CusVisitViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleCommitFin) name:NOTIFICATION_COMMITDATA_FIN object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startLocationUpdate) name:NOTIFICATION_LOCATION_WILLUPDATE object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationUpdated) name:NOTIFICATION_LOCATION_UPDATED object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationUpdateError) name:NOTIFICATION_LOCATION_UPDATERROR object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationAddressUpdate) name:NOTIFICATION_ADDRESS_UPDATED object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationAddressUpdateErro) name:NOTIFICATION_ADDRESS_UPDATEERROR object:nil];
    
    // Do any additional setup after loading the view from its nib.
    if (!_vistRecord) {
        BNVistRecord *record = [BNVistRecord searchSingleWithWhere:[NSString stringWithFormat:@"CUST_ID=%d and VISIT_TYPE=0",_customerInfo.CUST_ID] orderBy:@"BEGIN_TIME desc"];
        if (record) {
            NSString *visitDate = record.BEGIN_TIME;
            if (visitDate.length > 10) {
                visitDate = [visitDate substringToIndex:10];
            }
            if ( [visitDate isEqual:[[NSDate date]stringWithFormat:@"yyyy-MM-dd"]]) {
                self.vistRecord = record;
            }else {
               _vistRecord = [[BNVistRecord alloc]init];
            }
        }else{
            _vistRecord = [[BNVistRecord alloc]init];
        }
        
    }

    
    [self initView];
    [self LoadFunctionItems];
    [self loadVisitTypeData];
}

-(void)viewDidUnload{
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_COMMITDATA_FIN object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tvFuncBg reloadData];
    [self handleBtnRefreshClicked:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"客户拜访";
    [_svContain setContentSize:CGSizeMake(_svContain.frame.size.width, _btnVisitEnd.frame.origin.y + _btnVisitEnd.frame.size.height + 10)];
    
    UIImage *image = [UIImage imageNamed:@"CommonBtn_nor"];
    image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    UIImage *imageH = [UIImage imageNamed:@"CommonBtn_press"];
    imageH = [imageH stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    UIImage *imageD = [UIImage imageNamed:@"CommonBtn_disable"];
    imageD = [imageD stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    [_btnVisitBegin setBackgroundImage:image forState:UIControlStateNormal];
    [_btnVisitBegin setBackgroundImage:imageH forState:UIControlStateHighlighted];
    [_btnVisitBegin setBackgroundImage:imageD forState:UIControlStateDisabled];
    [_btnVisitEnd setBackgroundImage:image forState:UIControlStateNormal];
    [_btnVisitEnd setBackgroundImage:imageH forState:UIControlStateHighlighted];
    [_btnVisitEnd setBackgroundImage:imageD forState:UIControlStateDisabled];
    
    if(_customerInfo)
    {
        _lbCusName.text = _customerInfo.CUST_NAME;
    }
    
    if(_vistRecord.BEGIN_TIME.length > 0)
    {
        _btnVisitBegin.enabled = NO;
        _lbVisitTime.text = _vistRecord.BEGIN_TIME;
    }
    else
    {
        _btnVisitBegin.enabled = YES;
        _lbVisitTime.text = @"";
    }
    
    if(_vistRecord.END_TIME.length > 0)
    {
        _btnVisitEnd.enabled = NO;
        _lbEndVisitTime.text = _vistRecord.END_TIME;
    }
    else
    {
        _btnVisitEnd.enabled = YES;
        _lbEndVisitTime.text = @"";
    }
}

#pragma mark - functions

-(void)backAction{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)handleBtnRefreshClicked:(id)sender {
    [_btnRefresh setEnabled:NO];
    [[MapUtils shareInstance]startLocationUpdate];
}

- (IBAction)handleBtnMapClicked:(id)sender {
    MapAddressVC *vcl = [[MapAddressVC alloc]init];
    vcl.delegate = self;
    [self.navigationController pushViewController:vcl
                                         animated:YES];
}

- (IBAction)handleBtnVisitCaseClicked:(id)sender {

    NSMutableArray *aryItems = [[NSMutableArray alloc] init];
    for(BNVisitCondition *info in _aryVisitType)
    {
        [aryItems addObject:info.CONDITION_NAME];
    }
    
    LeveyPopListView *popListView = [[LeveyPopListView alloc] initWithTitle:@"选择拜访情况" options:aryItems handler:^(NSInteger anIndex) {
        NSString *strSelect = [aryItems objectAtIndex:anIndex];
        _lbVisitType.text = strSelect;
    }];
    [popListView showInView:[UIApplication sharedApplication].delegate.window animated:NO];
}

- (IBAction)handleBtnVisitBeginClicked:(id)sender {
    NSString *strCurrentTime = [[NSDate date]stringWithFormat:@"yyyy-MM-dd HH:mm:ss" ];
    _lbVisitTime.text = strCurrentTime;
    _btnVisitBegin.enabled = NO;
    _vistRecord.VISIT_TYPE = _strVisitType.intValue;
    _vistRecord.VISIT_DATE = [[NSDate date]stringWithFormat:@"yyyy-MM-dd 00:00:00"];
    _vistRecord.VISIT_CONDITION_CODE = _condition.CONDITION_CODE;
    _vistRecord.VISIT_CONDITION_NAME = _condition.CONDITION_NAME;
    _vistRecord.BEGIN_TIME = strCurrentTime;
    _vistRecord.BEGIN_LAT = [ShareValue shareInstance].currentLocation.latitude;
    _vistRecord.BEGIN_LNG = [ShareValue shareInstance].currentLocation.longitude;
    _vistRecord.CUST_ID = _customerInfo.CUST_ID;
    _vistRecord.CUST_NAME = _customerInfo.CUST_NAME;
    _vistRecord.BEGIN_POS = [ShareValue shareInstance].address;
    _vistRecord.BEGIN_POS2 = _address;
    if (manualCoordinate.longitude > 0) {
        _vistRecord.BEGIN_LAT2 = manualCoordinate.latitude;
        _vistRecord.BEGIN_LNG2 = manualCoordinate.longitude;
    }
    _aryVisitType = [NSMutableArray arrayWithObjects: _condition,nil];
    [_vistRecord save];
    
    BNVistRecord *record = [BNVistRecord searchSingleWithWhere:[NSString stringWithFormat:@"CUST_ID=%d and VISIT_TYPE=%@",_customerInfo.CUST_ID,_strVisitType] orderBy:@"BEGIN_TIME"];
    NSLog(@"%@",record.VISIT_NO);
}

- (IBAction)handleBtnVisitEndClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self sendVisitEndRequest];
}

- (void)loadVisitTypeData
{
    if (self.vistRecord.VISIT_CONDITION_CODE) {
        _aryVisitType = [BNVisitCondition searchWithWhere:[NSString stringWithFormat:@"CONDITION_CODE=%@",self.vistRecord.VISIT_CONDITION_CODE] orderBy:@"CONDITION_NAME" offset:0 count:100];
    }else{
        _aryVisitType = [BNVisitCondition searchWithWhere:nil orderBy:@"CONDITION_NAME" offset:0 count:100];
    }
    if(_aryVisitType.count > 0)
    {
        _condition = [_aryVisitType objectAtIndex:0];
        _lbVisitType.text = _condition.CONDITION_NAME;
    }
}

- (void)LoadFunctionItems
{
    _aryFuncItems = [BNMobileMenu searchWithWhere:[NSString stringWithFormat:@"PARENT_ID=%D and STATE=1",17] orderBy:@"ORDER_NO" offset:0 count:100];
    
    CGRect frame = _tvFuncBg.frame;
    frame.size.height = _aryFuncItems.count * 44;
    _tvFuncBg.frame = frame;
    
    frame = _ivIconOver.frame;
    frame.origin.y = _tvFuncBg.frame.origin.y + _tvFuncBg.frame.size.height;
    _ivIconOver.frame = frame;
    
    frame = _btnVisitEnd.frame;
    frame.origin.y = _ivIconOver.frame.origin.y + 8;
    _btnVisitEnd.frame = frame;
    
    frame = _lbEndVisitTime.frame;
    frame.origin.y = _btnVisitEnd.frame.origin.y + 9;
    _lbEndVisitTime.frame = frame;
    
    [_svContain setContentSize:CGSizeMake(_svContain.frame.size.width, _btnVisitEnd.frame.origin.y + _btnVisitEnd.frame.size.height + 10)];
}

- (void)sendVisitEndRequest
{
    RecordVisitHttpRequest *request = [[RecordVisitHttpRequest alloc]init];
    // 基础用户信息
    request.SESSION_ID  = [ShareValue shareInstance].userInfo.SESSION_ID;
    request.CORP_ID     = [ShareValue shareInstance].userInfo.CORP_ID;
    request.DEPT_ID     = [ShareValue shareInstance].userInfo.DEPT_ID;
    request.USER_AUTH   = [ShareValue shareInstance].userInfo.USER_AUTH;
    request.USER_ID     = [ShareValue shareInstance].userInfo.USER_ID;
    // 附加信息
    request.VISIT_DATE           = _vistRecord.VISIT_DATE;
    request.VISIT_NO             = _vistRecord.VISIT_NO;
    
    request.BEGIN_TIME      = _vistRecord.BEGIN_TIME;
    request.END_TIME        = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.CUST_ID         = _customerInfo.CUST_ID;
    // chenzftodo: 数据确认
    //request.VISIT_CONDITION_CODE = _vistRecord.VISIT_CONDITION_CODE;
    request.VISIT_TYPE      = _strVisitType;
    request.CONF_ID         = 0;
    //request.SYNC_STATE      = 2;
    request.BEGIN_LNG       = [NSNumber numberWithDouble:_vistRecord.BEGIN_LNG];
    request.BEGIN_LNG2      = [NSNumber numberWithDouble:_vistRecord.BEGIN_LNG2];
    request.BEGIN_LAT       = [NSNumber numberWithDouble:_vistRecord.BEGIN_LAT];
    request.BEGIN_LAT2      = [NSNumber numberWithDouble:_vistRecord.BEGIN_LAT2];
    request.BEGIN_POS       = _vistRecord.BEGIN_POS;
    request.BEGIN_POS2      = _vistRecord.BEGIN_POS2;
    request.END_LAT         = [NSNumber numberWithDouble:[ShareValue shareInstance].currentLocation.latitude];
    request.END_LNG         = [NSNumber numberWithDouble:[ShareValue shareInstance].currentLocation.longitude];
    request.END_POS         = [ShareValue shareInstance].address;
    if (manualCoordinate.longitude > 0) {
        request.END_LAT2 = [NSNumber numberWithDouble:manualCoordinate.latitude];
        request.END_LNG2 = [NSNumber numberWithDouble:manualCoordinate.longitude];
        request.END_POS2 = _address;
    }

    [KHGLAPI recordVisitByRequest:request success:^(RecordVisitHttpResponse *response){
        _lbEndVisitTime.text = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMMITDATA_FIN object:nil];
                [self dismissModalViewControllerAnimated:YES];
            });
        });
        
     }fail:^(BOOL notReachable, NSString *desciption){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD showError:desciption toView:self.view];
         
     }];
}

- (void)handleCommitFin
{
    // todo: 处理提交成功的通知
}

#pragma mark - MapNotification

-(void)startLocationUpdate{
    _lbCurrentLocation.text = @"正在定位...";
}

-(void)locationUpdated{
    [[MapUtils shareInstance] startGeoCodeSearch];
}

-(void)locationUpdateError{
    _lbCurrentLocation.text = @"定位失败";
    _btnRefresh.enabled = YES;
    _isLocationSuccess = NO;
}

-(void)locationAddressUpdate{
    _lbCurrentLocation.text = [ShareValue shareInstance].address;
    _btnRefresh.enabled = YES;
    _isLocationSuccess = YES;
}

-(void)locationAddressUpdateErro{
    _lbCurrentLocation.text = @"定位失败";
    _btnRefresh.enabled = YES;
    _isLocationSuccess = NO;
}

#pragma mark
-(void)onAddressReturn:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate{
    _lbAdjustLocation.text = address;
    manualCoordinate = coordinate;
    _isManualLocation = YES;
    _address = address;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryFuncItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CusVisitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CUSVISITCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CusVisitCell" bundle:nil] forCellReuseIdentifier:@"CUSVISITCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"CUSVISITCELL"];
    }
    
    if(_aryFuncItems.count > 0)
    {
        BNMobileMenu *funcItem = [_aryFuncItems objectAtIndex:indexPath.row];
        cell.mobileMenu = funcItem;
        cell.lbName.text = funcItem.MENU_NAME;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='%d'",self.vistRecord.VISIT_NO,funcItem.MENU_CODE] orderBy:nil];
        if (step) {
            [cell setSyncState:step.SYNC_STATE];
        }else{
            [cell setSyncState:0];
        }
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_btnVisitBegin.enabled)
    {
        [MBProgressHUD showError:@"尚未到访登记" toView:self.view];
        return;
    }
    
    UIViewController *controller = nil;
    CusVisitCell *cell = (CusVisitCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    switch (cell.mobileMenu.MENU_ID) {
        case 40:
        case 31:
        {
            DzPhotoViewController *viewController = [[DzPhotoViewController alloc] initWithNibName:@"DzPhotoViewController" bundle:nil];
            viewController.customerInfo = self.customerInfo;
            viewController.vistRecord = self.vistRecord;
            controller = viewController;
        }
            
            break;
        case 41:
        case 32:
        {
            CLPhotoViewController *viewController = [[CLPhotoViewController alloc] initWithNibName:@"CLPhotoViewController" bundle:nil];
            viewController.customerInfo = self.customerInfo;
            viewController.vistRecord = self.vistRecord;
            controller = viewController;
        }
            break;
        case 42:
        case 33:
        {
            ClLivelyViewController *viewController = [[ClLivelyViewController alloc] initWithNibName:@"ClLivelyViewController" bundle:nil];
            viewController.customerInfo = self.customerInfo;
            viewController.vistRecord = self.vistRecord;
            controller = viewController;
        }
            break;
        case 43:
        case 34:
        {
            ClCostViewController *viewController = [[ClCostViewController alloc] initWithNibName:@"ClCostViewController" bundle:nil];
            viewController.customerInfo = self.customerInfo;
            viewController.vistRecord = self.vistRecord;
            controller = viewController;
        }
            break;
        case 44:
        case 35:
        {
            KcReportViewController *viewController = [[KcReportViewController alloc] initWithNibName:@"KcReportViewController" bundle:nil];
            viewController.customerInfo = self.customerInfo;
            viewController.vistRecord = self.vistRecord;
            controller = viewController;
        }
            break;
        case 45:
        case 36:
        {
            DhReportViewController *viewController = [[DhReportViewController alloc] initWithNibName:@"KcReportViewController" bundle:nil];
            viewController.customerInfo = self.customerInfo;
            viewController.vistRecord = self.vistRecord;
            controller = viewController;
        }
            break;
        case 46:
        case 37:
        {
            ThReportViewController *viewController = [[ThReportViewController alloc] initWithNibName:@"KcReportViewController" bundle:nil];
            viewController.customerInfo = self.customerInfo;
            viewController.vistRecord = self.vistRecord;
            controller = viewController;
        }
            
            break;
        case 47:
        case 38:
        {
            HdReportViewController *viewController = [[HdReportViewController alloc] initWithNibName:@"HdReportViewController" bundle:nil];
            viewController.customerInfo = self.customerInfo;
            viewController.vistRecord = self.vistRecord;
            controller = viewController;
        }
            
            break;
        case 48:
        case 39:
        {
            JpReportViewController *viewController = [[JpReportViewController alloc] initWithNibName:@"JpReportViewController" bundle:nil];
            viewController.customerInfo = self.customerInfo;
            viewController.vistRecord = self.vistRecord;
            controller = viewController;
        }
            break;
            
        default:
            break;
    }
    
    if(!controller)
        return;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - IBActionSheetDelegate

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *strSelect = [_actionSheet buttonTitleAtIndex:buttonIndex];
    _lbCusName.text = strSelect;
}

@end
