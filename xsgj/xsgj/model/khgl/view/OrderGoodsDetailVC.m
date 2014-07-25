//
//  OrderGoodsDetailVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "OrderGoodsDetailVC.h"
#import "OrderDetailBean.h"
#import "KHGLAPI.h"
#import "MBProgressHUD+Add.h"
#import "XCMultiSortTableView.h"

@interface OrderGoodsDetailVC () <XCMultiTableViewDataSource>
{
    XCMultiTableView *tableView;
}

@property(nonatomic, strong) NSMutableArray *arrOrderGoods;
@property(nonatomic, strong) NSMutableArray *arrHeadData;
@property(nonatomic, strong) NSMutableArray *arrLeftTableData;
@property(nonatomic, strong) NSMutableArray *arrRightTableData;

@end

@implementation OrderGoodsDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订货详情";
    
    [self setupHead];
    
    tableView = [[XCMultiTableView alloc] initWithFrame:self.view.bounds];
    tableView.boldSeperatorLineColor = HEX_RGB(0xf3f3f3);
    tableView.normalSeperatorLineColor = HEX_RGB(0xf3f3f3);
    tableView.cellTextColor = HEX_RGB(0x40525c);
    tableView.headerTextColor = HEX_RGB(0x2989e1);
    tableView.boldSeperatorLineWidth = 1.f;
    tableView.normalSeperatorLineWidth = 1.f;
    tableView.leftHeaderEnable = YES;
    tableView.datasource = self;
    [self.view addSubview:tableView];
    tableView.alpha = 0.f;
    
    // 请求数据
    [self loadOrderGoodsDetail];
}

- (void)setupHead
{
    [self.arrHeadData addObject:@"规格"];
    [self.arrHeadData addObject:@"单价"];
    [self.arrHeadData addObject:@"数量"];
    [self.arrHeadData addObject:@"单位"];
    [self.arrHeadData addObject:@"赠品名称"];
    [self.arrHeadData addObject:@"赠品数量"];
    [self.arrHeadData addObject:@"单位"];
    [self.arrHeadData addObject:@"赠品金额"];
    [self.arrHeadData addObject:@"产品金额"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadOrderGoodsDetail
{
    OrderDetailHttpRequest *request = [[OrderDetailHttpRequest alloc] init];
    request.ORDER_ID = self.orderInfoBean.ORDER_ID;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [KHGLAPI queryOrderDetailByRequest:request success:^(OrderDetailHttpResponse *response) {
        
        [self.arrOrderGoods removeAllObjects];
        [self.arrOrderGoods addObjectsFromArray:response.DATA];
        [self refreshUI];
        
        [hub removeFromSuperview];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [hub removeFromSuperview];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

/**
 *  刷新界面
 */
- (void)refreshUI
{
    // 清空数据
    [self.arrLeftTableData removeAllObjects];
    [self.arrRightTableData removeAllObjects];
    
    for (int i = 0; i < [self.arrOrderGoods count]; i++)
    {
        OrderDetailBean *bean = self.arrOrderGoods[i];
        [self.arrLeftTableData addObject:bean.PROD_NAME];
        
        /*
        // 按列顺序进行赋值
        [oneRow addObject:@"规格"];
        [oneRow addObject:@"单价"];
        [oneRow addObject:@"数量"];
        [oneRow addObject:@"单位"];
        [oneRow addObject:@"赠品名称"];
        [oneRow addObject:@"赠品数量"];
        [oneRow addObject:@"单位"];
        [oneRow addObject:@"赠品金额"];
        [oneRow addObject:@"产品金额"];
        */
        NSMutableArray *oneRow = [NSMutableArray arrayWithCapacity:5];
        [oneRow addObject:bean.SPEC];
        [oneRow addObject:[NSString stringWithFormat:@"%.2f", [bean.ITEM_PRICE floatValue]]];
        [oneRow addObject:bean.ITEM_NUM];
        [oneRow addObject:bean.UNITNAME];
        [oneRow addObject:bean.GIFT_NAME];
        [oneRow addObject:bean.GIFT_NUM];
        [oneRow addObject:bean.GIFT_UNITNAME];
        [oneRow addObject:[NSString stringWithFormat:@"%.2f", [bean.GIFT_PRICE floatValue]]];
        [oneRow addObject:[NSString stringWithFormat:@"%.2f", [bean.TOTAL_PRICE floatValue]]];
        
        [self.arrRightTableData addObject:oneRow];
    }
    
    [tableView reloadData];
    
    tableView.alpha = 0.f;
    [UIView animateWithDuration:0.2f animations:^{
        tableView.alpha = 1.f;
    }];
}

#pragma mark - 访问器

- (NSMutableArray *)arrOrderGoods
{
    if (!_arrOrderGoods) {
        _arrOrderGoods = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _arrOrderGoods;
}

- (NSMutableArray *)arrHeadData
{
    if (!_arrHeadData) {
        _arrHeadData = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _arrHeadData;
}

- (NSMutableArray *)arrLeftTableData
{
    if (!_arrLeftTableData) {
        _arrLeftTableData = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _arrLeftTableData;
}

- (NSMutableArray *)arrRightTableData
{
    if (!_arrRightTableData) {
        _arrRightTableData = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _arrRightTableData;
}

#pragma mark - XCMultiTableViewDataSource

- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView
{
    return [self.arrHeadData copy];
}

- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section
{
    return self.arrLeftTableData;
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section
{
    return self.arrRightTableData;
}

- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column
{
    if (column == 0) {
        return 100.0f;
    }
    return 100.f;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section
{
    if (section == 0) {
        return 40.0f;
    }else {
        return 40.0f;
    }
}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column
{
    return [UIColor whiteColor];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column
{
    return [UIColor whiteColor];
}

- (NSString *)titleForHeaderInTableView:(XCMultiTableView *)tableView
{
    return @"产品";
}


@end
