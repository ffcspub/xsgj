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
    // Do any additional setup after loading the view from its nib.
    
    _aryDhData = [[NSMutableArray alloc] init];
    [self initView];
    [self loadOrderItemBean];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"订货编辑";
    
    [_btnCommit setBackgroundImage:IMG_BTN_BLUE forState:UIControlStateNormal];
    [_btnCommit setBackgroundImage:IMG_BTN_BLUE_S forState:UIControlStateHighlighted];
    [_btnPreview setBackgroundImage:IMG_BTN_BLUE forState:UIControlStateNormal];
    [_btnPreview setBackgroundImage:IMG_BTN_BLUE_S forState:UIControlStateHighlighted];
}

#pragma mark - functions

- (IBAction)handleBtnTypeClicked:(id)sender {
}

- (IBAction)handleBtnNameClicked:(id)sender {
}

- (IBAction)handleCommit:(id)sender {
}

- (IBAction)handlePreview:(id)sender {
    DhPreviewViewController *viewController = [[DhPreviewViewController alloc] initWithNibName:@"DhPreviewViewController" bundle:nil];
    viewController.aryData = _aryDhData;
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
            OrderItemBean *bean = [[OrderItemBean alloc]init];
            bean.GIFT_NAME = @"";
            bean.UNIT_NAME = unitBean.UNITNAME;
            bean.SPEC = product.SPEC;
            bean.PROD_NAME = product.PROD_NAME;
            bean.GIFT_UNIT_NAME = @"";
            
            bean.TOTAL_PRICE = 0;
            bean.ITEM_PRICE = unitBean.PROD_PRICE;
            bean.PRODUCT_UNIT_ID = unitBean.PRODUCT_UNIT_ID;
            bean.PROD_ID = unitBean.PROD_ID;
            bean.GIFT_TOTAL = 0;
            bean.GIFT_PRICE =0;
            bean.ITEM_NUM = 0;
            bean.GIFT_NUM = 0;
            
            [_aryDhData addObject:bean];
        }
    }
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
        return 224;
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

#pragma mark - DhEditCellDelegate

- (void)onBtnDelClicked:(DhEditCell *)cell
{
    // todo: 删除数据源
    [_tvContain insertRowsAtIndexPaths:[NSMutableArray arrayWithObject:cell.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
