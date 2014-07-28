//
//  DistributionQueryVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "BaseDistributionVC.h"
#import "LK_EasySignal.h"
#import <NSDate+Helper.h>
#import "SYSTEMAPI.h"
#import "XZGLAPI.h"
#import "DistributionCell.h"
#import "SVPullToRefresh.h"
#import "MBProgressHUD+Add.h"
#import "IBActionSheet.h"
#import "DistributionDetailVC.h"
#import "DistributionHandleDetailVC.h"

static NSString * const DistributionQueryCellIdentifier = @"DistributionQueryCellIdentifier";

static int const pageSize = 10;

@interface BaseDistributionVC () <IBActionSheetDelegate>
{
    NSUInteger tempIndex; // 记录点击的cell的索引
}

@property (nonatomic, assign) NSUInteger currentPage; // 第一页开始,每页加载20，当加载返回的数量少于请求的页数认为没有数据了

@end

@implementation BaseDistributionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    
    UIButton *rightButton = [self defaultRightButtonWithTitle:@"查询"];
    [rightButton addTarget:self
                    action:@selector(queryAction:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    // 设置默认预约时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.tfTime.text = [formatter stringFromDate:date];
    self.tfTime.font = [UIFont systemFontOfSize:15];
    self.tfTime.textColor = HEX_RGB(0x000000);
    self.tfTime.backgroundColor = [UIColor clearColor];
    
    // 表格
    self.tbvQuery.backgroundColor = HEX_RGB(0xefeff4);
    self.tbvQuery.tableFooterView = [[UIView alloc] init];
    self.tbvQuery.delegate = self;
    self.tbvQuery.dataSource = self;
    self.tbvQuery.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvQuery.showsVerticalScrollIndicator = NO;
    [self.tbvQuery registerNib:[DistributionCell nib] forCellReuseIdentifier:DistributionQueryCellIdentifier];
    
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(handleLongPress:)];
    longPressReger.minimumPressDuration = 1.0;
    [self.tbvQuery addGestureRecognizer:longPressReger];
    
    // 上提加载更多
    __weak BaseDistributionVC *weakSelf = self;
    [self.tbvQuery addInfiniteScrollingWithActionHandler:^{
        // 加载下一页
        self.currentPage += 1;
        [weakSelf loadDistribution];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.currentPage = 1;
    [self loadDistribution];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDistribution
{
    GetMobileDisInfoHttpRequest *request = [[GetMobileDisInfoHttpRequest alloc] init];
    request.YY_TIME = self.tfTime.text;
    request.PAGE = self.currentPage;
    request.ROWS = pageSize;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [XZGLAPI getMobileDisInfoByRequest:request success:^(GetMobileDisInfoHttpResponse *response) {
        
        int resultCount = [response.DATAT count];
        if (resultCount < pageSize) {
            self.tbvQuery.showsInfiniteScrolling = NO;
        }
        if (self.currentPage == 1) {
            [self.arrData removeAllObjects];
        }
        
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        [self.arrData addObjectsFromArray:response.DATAT];
        [self.tbvQuery reloadData];
        
        [hub removeFromSuperview];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [self.tbvQuery.infiniteScrollingView stopAnimating];
        self.tbvQuery.showsInfiniteScrolling = NO;
        self.tbvQuery.showsInfiniteScrolling = YES;
        
        [hub removeFromSuperview];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

#pragma mark - 访问器

- (NSMutableArray *)arrData
{
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] init];
    }
    
    return _arrData;
}

#pragma mark - 事件

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    CGPoint point = [gestureRecognizer locationInView:self.tbvQuery];
    NSIndexPath *indexPath = [self.tbvQuery indexPathForRowAtPoint:point];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (indexPath) {
            
            tempIndex = indexPath.row;
            
            // 配送查询
            if (self.type == DistrubutionTypeQuery) {
                IBActionSheet *sheet = [[IBActionSheet alloc] initWithTitle:@"提示"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:@"查询详情", nil];
                sheet.shouldCancelOnTouch = YES;
                [sheet showInView:self.navigationController.view];
            } else {
                IBActionSheet *sheet = [[IBActionSheet alloc] initWithTitle:@"提示"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:@"查询详情", @"配送处理", nil];
                sheet.shouldCancelOnTouch = YES;
                [sheet showInView:self.navigationController.view];
            }
        }
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
    }
}

- (void)queryAction:(UIButton *)sender
{
    self.currentPage = 1;
    self.tbvQuery.showsInfiniteScrolling = YES;
    [self loadDistribution];
}

- (IBAction)bookTimeAction:(id)sender
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker showTitle:@"请选择预约时间" inView:self.view];
}

ON_LKSIGNAL3(UIDatePicker, COMFIRM, signal)
{
    UIDatePicker *picker =  (UIDatePicker *)signal.sender;
    NSDate *date = picker.date;
    self.tfTime.text = [date stringWithFormat:@"yyyy-MM-dd"];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 1;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.arrData count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:DistributionQueryCellIdentifier];
    
    // 配置Cell
    [cell configureForData:self.arrData[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DistributionCell cellHeight];
}

#pragma mark - IBActionSheet Delegate

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        DistributionDetailVC *vc = [[DistributionDetailVC alloc] initWithNibName:nil bundle:nil];
        vc.disBean = self.arrData[tempIndex];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (buttonIndex == 1){
        if (self.type == DistrubutionTypeHandle) {
            
            MobileInfoDisBean *bean = self.arrData[tempIndex];
            DistributionHandleDetailVC *vc;
            if ([bean.STATE intValue] == 1) {
                vc = [[DistributionHandleDetailVC alloc] initWithNibName:@"DistributionHandleDetailVC-One" bundle:nil];
                vc.currentState = DistributionHandleStateReceive; // 已下单下一步操作为接单
                vc.arrResult = @[@"已接单"];
            } else if ([bean.STATE intValue] == 2) {
                vc = [[DistributionHandleDetailVC alloc] initWithNibName:@"DistributionHandleDetailVC-One" bundle:nil];
                vc.currentState = DistributionHandleStateTransport; // 已接单下一步操作为配送中
                vc.arrResult = @[@"配送中"];
            } else if ([bean.STATE intValue] == 3) {
                vc = [[DistributionHandleDetailVC alloc] initWithNibName:@"DistributionHandleDetailVC-Two" bundle:nil];
                vc.currentState = DistributionHandleStateResult; // 配送中下一步操作为配送结果(配送成功或者配送失败)
                vc.arrResult = @[@"配送完成", @"配送失败"];
            } else {
                [MBProgressHUD showError:@"单据已处理完毕，无法再次处理!" toView:self.view];
                return;
            }
            vc.DISTRIBUTION_ID = bean.DISTRIBUTION_ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


@end
