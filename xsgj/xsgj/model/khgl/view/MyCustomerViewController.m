//
//  MyCustomerViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-28.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "MyCustomerViewController.h"
#import "MyCusDetailViewController.h"

@interface MyCustomerViewController ()
{
    NSArray *_aryCusTypeData;
    NSArray *_aryCusTypeTreeData;
    NSArray *_aryCusInfoData;
    int _iTypeSelect;
}

@end

@implementation MyCustomerViewController

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
    
    _iTypeSelect = -1;
    [self initView];
    [self loadCustomerData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_SELECT_FIN object:nil];
}

- (void)initView
{
    self.title = @"我的客户";
    [self showRightBarButtonItemWithTitle:@"查询" target:self action:@selector(handleNavBarRight)];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    [_tfSearch resignFirstResponder];
    
    if(_tfSearch.text.length < 1)
    {
        [MBProgressHUD showError:@"请输入搜索内容" toView:self.view];
        return;
    }
    
    [self queryCustomerInfoWithType:_iTypeSelect Name:_tfSearch.text];
}


- (IBAction)handleBtnSelectType:(id)sender {
    MyCusSelectTreeViewController *selectTreeViewController = [[MyCusSelectTreeViewController alloc] initWithNibName:@"MyCusSelectTreeViewController" bundle:nil];
    selectTreeViewController.data = _aryCusTypeTreeData;
    [self.navigationController pushViewController:selectTreeViewController animated:YES];
    
}

- (void)queryCustomerInfoWithType:(int)type Name:(NSString *)name
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CustomerDetailHttpRequest *request = [[CustomerDetailHttpRequest alloc]init];
    // 基础用户信息
    request.SESSION_ID  = [ShareValue shareInstance].userInfo.SESSION_ID;
    request.CORP_ID     = [ShareValue shareInstance].userInfo.CORP_ID;
    request.DEPT_ID     = [ShareValue shareInstance].userInfo.DEPT_ID;
    request.USER_AUTH   = [ShareValue shareInstance].userInfo.USER_AUTH;
    request.USER_ID     = [ShareValue shareInstance].userInfo.USER_ID;
    // 附加信息
    //request.CUST_ID   = self.vistRecord.VISIT_NO;
    if(type > 0)
    {
        request.TYPE_ID    = [NSNumber numberWithInt:type];
    }
    
    if(name.length > 0)
    {
        request.CUST_NAME  = name;
    }
    
    [KHGLAPI customerDetailByRequest:request success:^(CustomerDetailHttpResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _aryCusInfoData = response.DATA;
        [_tvContain reloadData];
        if(_aryCusInfoData.count < 1)
        {
            [MBProgressHUD showError:@"查询结果为空" toView:self.view];
        }

    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
        
    }];
}

//- (void)loadCustomerInfoWithType:(int)typeid Area:(int)areaid
//{
//    NSString *typeids = [BNCustomerType getOwnerAndChildTypeIds:typeid];
//    NSString *areaids = [BNAreaInfo getOwnerAndChildAreaIds:areaid];
//    
//    NSString *strSql = @"";
//    if (typeid >= 0 && areaid >= 0) {
//        strSql = [NSString stringWithFormat:@"TYPE_ID in (%@) and AREA_ID in (%@)",typeids,areaids];
//        
//    }else if (typeid >= 0 && areaid < 0){
//        strSql = [NSString stringWithFormat:@"TYPE_ID in (%@)",typeids];
//        
//    }else if (typeid < 0 && areaid >= 0){
//        strSql = [NSString stringWithFormat:@"AREA_ID in (%@)",areaids];
//        
//    }
//    
//    _aryCusInfoData = [BNCustomerInfo searchWithWhere:strSql orderBy:@"ORDER_NO,CUST_NAME" offset:0 count:100];
//}

- (void)loadCustomerData
{
    _aryCusTypeData = [BNCustomerType searchWithWhere:nil orderBy:@"TYPE_NAME_PINYIN" offset:0 count:1000];
    if(_aryCusTypeData.count > 0)
    {
        _aryCusTypeTreeData = [self makeCusTypeTreeData];
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

- (void)handleNotifySelectFin:(NSNotification *)note
{
    BNCustomerType *cusType = [note object];
    _iTypeSelect = cusType.TYPE_ID;
    [self queryCustomerInfoWithType:cusType.TYPE_ID Name:@""];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryCusInfoData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCUSCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MyCusCell" bundle:nil] forCellReuseIdentifier:@"MYCUSCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MYCUSCELL"];
    }
    
    if(_aryCusInfoData.count > 0)
    {
        CustDetailBean *customerInfo = [_aryCusInfoData objectAtIndex:indexPath.row];
        [cell setCellWithValue:customerInfo];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CustDetailBean *custDetailBean = [_aryCusInfoData objectAtIndex:indexPath.row];

    MyCusDetailViewController *cusDetailViewController = [[MyCusDetailViewController alloc] initWithNibName:@"CusDetailViewController" bundle:nil];
    cusDetailViewController.custDetailBean = custDetailBean;

    [self.navigationController pushViewController:cusDetailViewController animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tfSearch resignFirstResponder];
    
    if(textField.text.length < 1)
    {
        [MBProgressHUD showError:@"请输入搜索内容" toView:self.view];
        return NO;
    }
    
    [_tfSearch resignFirstResponder];
    
    [self queryCustomerInfoWithType:_iTypeSelect Name:textField.text];
    return NO;
}

@end
