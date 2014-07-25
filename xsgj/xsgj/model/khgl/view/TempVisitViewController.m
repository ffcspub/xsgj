//
//  TempVisitViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "TempVisitViewController.h"
#import "SelectTreeViewController.h"
#import "CusVisitViewController.h"
#import "InfoCollectViewController.h"


@interface TempVisitViewController ()
{
    NSArray *_aryCusTypeData;
    NSArray *_aryCusAreaData;
    NSArray *_aryCusInfoData;
    IBActionSheet *_actionSheet;
    SelectTreeType _selectType;
    BNAreaInfo *_areaInfoShow;
    BNCustomerType *_cusTypeShow;
}

@end

@implementation TempVisitViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotifySelectFin:) name:NOTIFICATION_SELECT_FIN object:nil];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    [self loadCustomerData];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_SELECT_FIN object:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"临时拜访";
    [self showRightBarButtonItemWithTitle:@"进入" target:self action:@selector(handleNavBarRight)];
    [_svContain setContentSize:CGSizeMake(_svContain.frame.size.width, _btnCusInfo.frame.origin.y + _btnCusInfo.frame.size.height + 10)];
    
    UIImage *image = [UIImage imageNamed:@"CommonBtn_nor"];
    image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    UIImage *imageH = [UIImage imageNamed:@"CommonBtn_press"];
    imageH = [imageH stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    [_btnCusInfo setBackgroundImage:image forState:UIControlStateNormal];
    [_btnCusInfo setBackgroundImage:imageH forState:UIControlStateHighlighted];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    CusVisitViewController *cusVisitViewController = [[CusVisitViewController alloc] initWithNibName:@"CusVisitViewController" bundle:nil];
    cusVisitViewController.customerInfo = self.customerInfoSelect;
    cusVisitViewController.vistRecord = self.visitRecordSelect;
    [self.navigationController pushViewController:cusVisitViewController animated:YES];
}

- (IBAction)handleBtnCusTypeClicked:(id)sender {
    _selectType = Type_CusType;
    NSArray *data = [self makeCusTypeTreeData];
    SelectTreeViewController *selectTreeViewController = [[SelectTreeViewController alloc] initWithNibName:@"SelectTreeViewController" bundle:nil];
    selectTreeViewController.data = data;
    [self.navigationController pushViewController:selectTreeViewController animated:YES];
}

- (IBAction)handleBtnCusAreaClicked:(id)sender {
    _selectType = Type_CusArea;
    NSArray *data = [self makeCusAreaTreeData];
    SelectTreeViewController *selectTreeViewController = [[SelectTreeViewController alloc] initWithNibName:@"SelectTreeViewController" bundle:nil];
    selectTreeViewController.data = data;
    [self.navigationController pushViewController:selectTreeViewController animated:YES];
}

- (IBAction)handleBtnCusTNameClicked:(id)sender {
    NSMutableArray *aryItems = [[NSMutableArray alloc] init];
    for(BNCustomerInfo *info in _aryCusInfoData)
    {
        [aryItems addObject:info.CUST_NAME];
    }
    
    LeveyPopListView *popListView = [[LeveyPopListView alloc] initWithTitle:@"选择客户" options:aryItems handler:^(NSInteger anIndex) {
        NSString *strSelect = [aryItems objectAtIndex:anIndex];
        _lbCusNameSelect.text = strSelect;
        
        for(BNCustomerInfo *info in _aryCusInfoData)
        {
            if([info.CUST_NAME isEqualToString:strSelect])
            {
                [self showCustomerInfo:info];
                break;
            }
        }
    }];
    [popListView showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view animated:NO];
}

- (IBAction)handleBtnCusInfoClicked:(id)sender {
    InfoCollectViewController *viewController = [[InfoCollectViewController alloc] initWithNibName:@"InfoCollectViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)handleBtnSmsClicked:(id)sender {
}

- (IBAction)handleBtnPhoneClicked:(id)sender {
}

- (void)loadCustomerInfoWithType:(int)typeid Area:(int)areaid
{
    _aryCusInfoData = [BNCustomerInfo searchWithWhere:[NSString stringWithFormat:@"TYPE_ID=%D and AREA_ID=%D",typeid,areaid] orderBy:nil offset:0 count:100];
    if(_aryCusInfoData.count > 0)
    {
        BNCustomerInfo *customerInfo = [_aryCusInfoData objectAtIndex:0];
        _lbCusNameSelect.text = customerInfo.CUST_NAME;
        [self showCustomerInfo:customerInfo];
    }
    else
    {
        _lbCusNameSelect.text = @"";
        BNCustomerInfo *customerInfo = [[BNCustomerInfo alloc] init];
        [self showCustomerInfo:customerInfo];
    }
    
    BOOL bEnter = NO;
    if(_lbCusTypeSelect.text.length > 0 &&
       _lbCusAreaSelect.text.length > 0 &&
       _lbCusNameSelect.text.length > 0)
    {
        bEnter = YES;
    }
    // todo: test
    //self.navigationItem.rightBarButtonItem.enabled = bEnter;
}

- (void)loadCustomerData
{
    _aryCusTypeData = [BNCustomerType searchWithWhere:nil orderBy:nil offset:0 count:1000];
    if(_aryCusTypeData.count > 0)
    {
        BNCustomerType *customerType = [_aryCusTypeData objectAtIndex:0];
        _cusTypeShow = customerType;
        _lbCusTypeSelect.text = customerType.TYPE_NAME;
    }
    
    _aryCusAreaData = [BNAreaInfo searchWithWhere:nil orderBy:@"ORDER_NO" offset:0 count:1000];
    if(_aryCusAreaData.count > 0)
    {
        BNAreaInfo *areaInfo = [_aryCusAreaData objectAtIndex:0];
        _areaInfoShow = areaInfo;
        _lbCusAreaSelect.text = areaInfo.AREA_NAME;
    }
    
    if(_aryCusTypeData.count > 0 && _aryCusAreaData.count > 0)
    {
        BNCustomerType *customerType = [_aryCusTypeData objectAtIndex:0];
        BNAreaInfo *areaInfo = [_aryCusAreaData objectAtIndex:0];
        [self loadCustomerInfoWithType:customerType.TYPE_ID Area:areaInfo.AREA_ID];
    }
}

- (void)showCustomerInfo:(BNCustomerInfo *)customerInfo
{
    self.customerInfoSelect = customerInfo;
    _lbCusName.text = customerInfo.CUST_NAME;
    
    // chenzftodo: 确认客户类型哪里取得
//    NSArray *aryType = [BNCustomerType searchWithWhere:[NSString stringWithFormat:@"CUST_ID=%D",customerInfo.CUST_ID] orderBy:@"ORDER_NO" offset:0 count:100];
//    if(aryType.count > 0)
//    {
//        BNCustomerType *type = [aryType objectAtIndex:0];
//        
//    }

    _lbCusType.text = _cusTypeShow.TYPE_NAME;
    _lbContacts.text = customerInfo.LINKMAN;
    _lbMobile.text = customerInfo.TEL;
    _lbAddress.text = customerInfo.ADDRESS;
    NSArray *aryRecord = [BNVistRecord searchWithWhere:[NSString stringWithFormat:@"CUST_ID=%D",customerInfo.CUST_ID] orderBy:nil offset:0 count:100];
    if(aryRecord.count > 0)
    {
        self.visitRecordSelect = [aryRecord objectAtIndex:0];
    }
    if(self.visitRecordSelect)
    {
        _lbLastVisit.text = self.visitRecordSelect.BEGIN_TIME;
    }
}

- (NSArray *)makeCusTypeTreeData
{
    NSMutableArray *parentTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:_aryCusTypeData];
    for(BNCustomerType *customerType in _aryCusTypeData)
    {
        if(customerType.TYPE_PID == 0)
        {
            TreeData *aryData = [[TreeData alloc] init];
            aryData.name = customerType.TYPE_NAME;
            aryData.dataInfo = customerType;
            [parentTree addObject:aryData];
            
            [arySourceData removeObject:customerType];
        }
    }
    
    [self makeSubCusTypeTreeData:arySourceData ParentTreeData:parentTree];
    return parentTree;
}

- (void)makeSubCusTypeTreeData:(NSArray *)sourceData ParentTreeData:(NSMutableArray *)parentTree
{
    NSMutableArray *aryChildTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:sourceData];
    for(BNCustomerType *customerType in sourceData)
    {
        for(TreeData *parentData in parentTree)
        {
            BNCustomerType *parentCusType = (BNCustomerType *)parentData.dataInfo;
            if(customerType.TYPE_PID == parentCusType.TYPE_ID)
            {
                TreeData *aryData = [[TreeData alloc] init];
                aryData.name = customerType.TYPE_NAME;
                aryData.dataInfo = customerType;
                [parentData.children addObject:aryData];
                
                [aryChildTree addObject:aryData];
                [arySourceData removeObject:customerType];
            }
        }
    }
    
    if(arySourceData.count > 0)
    {
        [self makeSubCusTypeTreeData:arySourceData ParentTreeData:aryChildTree];
    }
}

- (NSArray *)makeCusAreaTreeData
{
    NSMutableArray *parentTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:_aryCusAreaData];
    for(BNAreaInfo *areaInfo in _aryCusAreaData)
    {
        if(areaInfo.AREA_PID == 0)
        {
            TreeData *aryData = [[TreeData alloc] init];
            aryData.name = areaInfo.AREA_NAME;
            aryData.dataInfo = areaInfo;
            [parentTree addObject:aryData];
            
            [arySourceData removeObject:areaInfo];
        }
    }
    
    [self makeSubCusAreaTreeData:arySourceData ParentTreeData:parentTree];
    return parentTree;
}

- (void)makeSubCusAreaTreeData:(NSArray *)sourceData ParentTreeData:(NSMutableArray *)parentTree
{
    NSMutableArray *aryChildTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:sourceData];
    for(BNAreaInfo *areaInfo in sourceData)
    {
        for(TreeData *parentData in parentTree)
        {
            BNAreaInfo *parentareaInfo = (BNAreaInfo *)parentData.dataInfo;
            if(areaInfo.AREA_PID == parentareaInfo.AREA_ID)
            {
                TreeData *aryData = [[TreeData alloc] init];
                aryData.name = areaInfo.AREA_NAME;
                aryData.dataInfo = areaInfo;
                [parentData.children addObject:aryData];
                
                [aryChildTree addObject:aryData];
                [arySourceData removeObject:areaInfo];
            }
        }
    }
    
    if(arySourceData.count > 0)
    {
        [self makeSubCusAreaTreeData:arySourceData ParentTreeData:aryChildTree];
    }
}

#pragma mark - Notify

- (void)handleNotifySelectFin:(NSNotification *)note
{
    if(_selectType == Type_CusType)
    {
        BNCustomerType *cusType = [note object];
        _cusTypeShow = cusType;
        _lbCusTypeSelect.text = cusType.TYPE_NAME;
    }
    else
    {
        BNAreaInfo *areaInfo = [note object];
        _areaInfoShow = areaInfo;
        _lbCusAreaSelect.text = areaInfo.AREA_NAME;
    }
    
    [self loadCustomerInfoWithType:_cusTypeShow.TYPE_ID Area:_areaInfoShow.AREA_ID];
}

#pragma mark - IBActionSheetDelegate

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 10)
    {
        NSString *strSelect = [_actionSheet buttonTitleAtIndex:buttonIndex];
        if(![strSelect isEqualToString:@"取消"])
        {
            _lbCusNameSelect.text = strSelect;
        }
        
        for(BNCustomerInfo *info in _aryCusInfoData)
        {
            if([info.CUST_NAME isEqualToString:strSelect])
            {
                [self showCustomerInfo:info];
                break;
            }
        }
    }
}

@end
