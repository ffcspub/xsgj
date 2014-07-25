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
    
    [self initView];
    [self LoadFunctionItems];
    [self loadVisitTypeData];
    [self handleBtnRefreshClicked:nil];
}

-(void)viewDidUnload{
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_COMMITDATA_FIN object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewDidUnload];
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
}

#pragma mark - functions

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
    [popListView showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view animated:NO];
}

- (IBAction)handleBtnVisitBeginClicked:(id)sender {
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strCurrentTime = [timeFormatter stringFromDate:[NSDate date]];
    _lbVisitTime.text = strCurrentTime;
    _btnVisitBegin.enabled = NO;
}

- (IBAction)handleBtnVisitEndClicked:(id)sender {
    if (!_isLocationSuccess)
    {
        // chenzftodo: 判断定位过
    }
    
    if (_isManualLocation) {
//        request.LNG2 = [NSNumber numberWithFloat:manualCoordinate.longitude];
//        request.LAT2 = [NSNumber numberWithFloat:manualCoordinate.latitude];
//        request.POSITION2 = _lb_manualAdjust.text;
    }
}

- (void)loadVisitTypeData
{
    _aryVisitType = [BNVisitCondition searchWithWhere:[NSString stringWithFormat:@"CONDITION_CODE=%@",self.vistRecord.VISIT_CONDITION_CODE] orderBy:nil offset:0 count:100];
    if(_aryVisitType.count > 0)
    {
        BNVisitCondition *visitCondition = [_aryVisitType objectAtIndex:0];
        _lbVisitType.text = visitCondition.CONDITION_NAME;
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
    
    [_svContain setContentSize:CGSizeMake(_svContain.frame.size.width, _btnVisitEnd.frame.origin.y + _btnVisitEnd.frame.size.height + 10)];
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
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_btnVisitBegin.enabled)
    {
        // 提示尚未到访登记
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
            controller = viewController;
        }
            break;
        case 45:
        case 36:
        {
            DhReportViewController *viewController = [[DhReportViewController alloc] initWithNibName:@"KcReportViewController" bundle:nil];
            controller = viewController;
        }
            break;
        case 46:
        case 37:
        {
            ThReportViewController *viewController = [[ThReportViewController alloc] initWithNibName:@"KcReportViewController" bundle:nil];
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
    
//    if([cell.lbName.text isEqual:@"店招拍照"])
//    {
//        DzPhotoViewController *viewController = [[DzPhotoViewController alloc] initWithNibName:@"DzPhotoViewController" bundle:nil];
//        viewController.customerInfo = self.customerInfo;
//        viewController.vistRecord = self.vistRecord;
//        controller = viewController;
//    }
//    else if([cell.lbName.text isEqual:@"陈列拍照"])
//    {
//        CLPhotoViewController *viewController = [[CLPhotoViewController alloc] initWithNibName:@"CLPhotoViewController" bundle:nil];
//        viewController.customerInfo = self.customerInfo;
//        viewController.vistRecord = self.vistRecord;
//        controller = viewController;
//    }
//    else if([cell.lbName.text isEqual:@"陈列生动化"])
//    {
//        ClLivelyViewController *viewController = [[ClLivelyViewController alloc] initWithNibName:@"ClLivelyViewController" bundle:nil];
//        viewController.customerInfo = self.customerInfo;
//        viewController.vistRecord = self.vistRecord;
//        controller = viewController;
//    }
//    else if([cell.lbName.text isEqual:@"陈列费用"])
//    {
//        ClCostViewController *viewController = [[ClCostViewController alloc] initWithNibName:@"ClCostViewController" bundle:nil];
////        viewController.customerInfo = self.customerInfo;
////        viewController.vistRecord = self.vistRecord;
//        controller = viewController;
//    }
//    else if([cell.lbName.text isEqual:@"库存上报"])
//    {
//        KcReportViewController *viewController = [[KcReportViewController alloc] initWithNibName:@"KcReportViewController" bundle:nil];
//        controller = viewController;
//    }
//    else if([cell.lbName.text isEqual:@"订货上报"])
//    {
//        DhReportViewController *viewController = [[DhReportViewController alloc] initWithNibName:@"KcReportViewController" bundle:nil];
//        controller = viewController;
//    }
//    else if([cell.lbName.text isEqual:@"退货上报"])
//    {
//        ThReportViewController *viewController = [[ThReportViewController alloc] initWithNibName:@"KcReportViewController" bundle:nil];
//        controller = viewController;
//    }
//    else if([cell.lbName.text isEqual:@"活动上报"])
//    {
//        HdReportViewController *viewController = [[HdReportViewController alloc] initWithNibName:@"HdReportViewController" bundle:nil];
//        controller = viewController;
//    }
//    else if([cell.lbName.text isEqual:@"竞品上报"])
//    {
//        JpReportViewController *viewController = [[JpReportViewController alloc] initWithNibName:@"JpReportViewController" bundle:nil];
//        controller = viewController;
//    }
    
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
