//
//  KcReportViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KcReportViewController.h"
#import "KcSelectTreeViewController.h"
#import "KcEditViewController.h"

@interface KcReportViewController ()

@end

@implementation KcReportViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotifySelectProductFin:) name:NOTIFICATION_SELECTPRODUCT_FIN object:nil];
    // Do any additional setup after loading the view from its nib.
    
    _aryProDataTemp = [[NSMutableArray alloc] init];
    _aryTraversalRet = [[NSMutableArray alloc] init];
    _aryProductSelect = [[NSMutableArray alloc] init];
    _aryFilter = [[NSMutableArray alloc] init];
    _bSearch = NO;
    [self initView];
    [self loadTypeData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _btnSeleltAll.selected = NO;
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_SELECTPRODUCT_FIN object:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"库存上报";
    [self showRightBarButtonItemWithTitle:@"添加" target:self action:@selector(handleNavBarRight)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - functions

- (void)handleNavBarRight
{
    KcEditViewController *viewController = [[KcEditViewController alloc] initWithNibName:@"KcEditViewController" bundle:nil];
    viewController.aryData = _aryProductSelect;
    viewController.customerInfo = self.customerInfo;
    viewController.vistRecord = self.vistRecord;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)handleBtnTypeClicked:(id)sender {
    KcSelectTreeViewController *selectTreeViewController = [[KcSelectTreeViewController alloc] initWithNibName:@"SelectTreeViewController" bundle:nil];
    selectTreeViewController.data = _aryProTypeTreeData;
    [self.navigationController pushViewController:selectTreeViewController animated:YES];
}

- (IBAction)handleBtnSelectAll:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if(_bSearch)
    {
        for(BNProduct *product in _aryFilter)
        {
            [self handleSelectData:product ISAdd:button.selected];
        }
    }
    else
    {
        for(BNProduct *product in _aryProductData)
        {
            [self handleSelectData:product ISAdd:button.selected];
        }
    }
    
    [_tvProduct reloadData];
}

- (void)loadTypeData
{
    _aryProductTypeData = [BNProductType searchWithWhere:nil orderBy:@"ORDER_NO" offset:0 count:1000];
    _aryProductData = [BNProduct searchWithWhere:nil orderBy:nil offset:0 count:1000];
    _aryProTypeTreeData = [self makeProTypeTreeData];
}

- (NSArray *)makeProTypeTreeData
{
    NSMutableArray *parentTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:_aryProductTypeData];
    for(BNProductType *productType in _aryProductTypeData)
    {
        if(productType.CLASS_PID == 0)
        {
            TreeData *aryData = [[TreeData alloc] init];
            aryData.name = productType.CLASS_NAME;
            aryData.dataInfo = productType;
            [parentTree addObject:aryData];
            
            [arySourceData removeObject:productType];
        }
    }
    
    [self makeSubCusTypeTreeData:arySourceData ParentTreeData:parentTree];
    return parentTree;
}

- (void)makeSubCusTypeTreeData:(NSArray *)sourceData ParentTreeData:(NSMutableArray *)parentTree
{
    NSMutableArray *aryChildTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:sourceData];
    for(BNProductType *productType in sourceData)
    {
        for(TreeData *parentData in parentTree)
        {
            BNProductType *parentProType = (BNProductType *)parentData.dataInfo;
            if(productType.CLASS_PID == parentProType.CLASS_ID)
            {
                TreeData *aryData = [[TreeData alloc] init];
                aryData.name = productType.CLASS_NAME;
                aryData.dataInfo = productType;
                [parentData.children addObject:aryData];
                
                [aryChildTree addObject:aryData];
                [arySourceData removeObject:productType];
            }
        }
    }
    
    if(arySourceData.count > 0)
    {
        [self makeSubCusTypeTreeData:arySourceData ParentTreeData:aryChildTree];
    }
}

- (void)handleSelectData:(BNProduct *)product ISAdd:(BOOL)bAdd
{
    BOOL bIsExist = NO;
    for(BNProduct *tempPro in _aryProductSelect)
    {
        if(tempPro.PROD_ID == product.PROD_ID)
        {
            bIsExist = YES;
            break;
        }
    }
    
    if(bAdd)
    {
        if(!bIsExist)
        {
            [_aryProductSelect addObject:product];
        }
    }
    else
    {
        if(bIsExist)
        {
            [_aryProductSelect removeObject:product];
        }
    }
    
    if(_aryProductSelect.count > 0)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_bSearch)
    {
        return _aryFilter.count;
    }
    else
    {
        return _aryProductData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KcProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KCPRODUCTCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KcProductCell" bundle:nil] forCellReuseIdentifier:@"KCPRODUCTCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"KCPRODUCTCELL"];
    }
    
    BNProduct *product = nil;
    if(_bSearch)
    {
        if(_aryFilter.count > 0)
        {
            product = [_aryFilter objectAtIndex:indexPath.row];
        }
    }
    else
    {
        if(_aryProductData.count > 0)
        {
            product = [_aryProductData objectAtIndex:indexPath.row];
        }
    }
    
    if(product)
    {
        cell.productData = product;
        cell.lbName.text = product.PROD_NAME;
        BOOL bIsExist = NO;
        for(BNProduct *tempPro in _aryProductSelect)
        {
            if(tempPro.PROD_ID == product.PROD_ID)
            {
                bIsExist = YES;
                break;
            }
        }
        cell.btnSelect.selected = bIsExist;
    }

    cell.delegate = self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _bSearch = NO;
    [_tvProduct reloadData];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    if(_tfSearch.text.length > 0)
//    {
//        _bSearch = YES;
//        [_aryFilter removeAllObjects];
//        for(BNProduct *product in _aryProductData)
//        {
//            NSRange range = [product.PROD_NAME rangeOfString:string];
//            if(range.length > 0)
//            {
//                [_aryFilter addObject:product];
//            }
//        }
//    }
//    else
//    {
//        _bSearch = NO;
//    }
//    
//    [_tvProduct reloadData];
//    
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tfSearch resignFirstResponder];
    if(_tfSearch.text.length > 0)
    {
        _bSearch = YES;
        [_aryFilter removeAllObjects];
        for(BNProduct *product in _aryProductData)
        {
            NSRange range = [product.PROD_NAME rangeOfString:textField.text];
            if(range.length > 0)
            {
                [_aryFilter addObject:product];
            }
        }
    }
    else
    {
        _bSearch = NO;
    }
    
    [_tvProduct reloadData];
    return NO;
}

#pragma mark - KcProductCellDelegate

- (void)onBtnSelectClicked:(KcProductCell *)cell
{
    if(cell.btnSelect.selected)
    {
        [self handleSelectData:cell.productData ISAdd:YES];
    }
    else
    {
        [self handleSelectData:cell.productData ISAdd:NO];
    }
}

- (void)handleNotifySelectProductFin:(NSNotification *)note
{
    [_aryProductSelect removeAllObjects];
    
    BNProductType *productType = [note object];
    _proTypeShow = productType;
    _tfType.text = productType.CLASS_NAME;
    
    [self proTypeFilter:productType];
}

- (TreeData *)foundRootTree:(TreeData *)treeData TargetType:(BNProductType *)targetType
{
    BNProductType *typeResource = (BNProductType *)treeData.dataInfo;
    if(typeResource.CLASS_ID == targetType.CLASS_ID)
    {
        return treeData;
    }
    
    if(treeData.children.count > 0)
    {
        for(TreeData *childTreeData in treeData.children)
        {
            [self foundRootTree:childTreeData TargetType:targetType];
        }
    }
    
    return nil;
}

- (void)traversalTreeDataForTypes:(TreeData *)treeData
{
    BNProductType *proType = (BNProductType *)treeData.dataInfo;
    [_aryTraversalRet addObject:[NSNumber numberWithInt:proType.CLASS_ID]];
    
    if(treeData.children.count > 0)
    {
        for(TreeData *childTreeData in treeData.children)
        {
            [self traversalTreeDataForTypes:childTreeData];
        }
    }
    
}

- (void)proTypeFilter:(BNProductType *)targetType
{
    TreeData *resultData = nil;
    // found root tree
    for(TreeData *treeData in _aryProTypeTreeData)
    {
        resultData = [self foundRootTree:treeData TargetType:targetType];
        if(resultData)
            break;
    }
    
    // traversal tree for get class_id
    if(resultData)
    {
        [_aryTraversalRet removeAllObjects];
        [self traversalTreeDataForTypes:resultData];
    }
    
    // get product by class_id
    [_aryProDataTemp removeAllObjects];
    for(NSNumber *typeNumber in _aryTraversalRet)
    {
        NSArray *aryProduct = [BNProduct searchWithWhere:[NSString stringWithFormat:@"CLASS_ID=%D",typeNumber.intValue] orderBy:nil offset:0 count:1000];
        for(BNProduct *product in aryProduct)
        {
            [_aryProDataTemp addObject:product];
        }
    }
    
    _aryProductData = [NSArray arrayWithArray:_aryProDataTemp];
    [_tvProduct reloadData];
    
}

@end
