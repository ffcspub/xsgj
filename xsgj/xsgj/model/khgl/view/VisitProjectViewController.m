//
//  VisitProjectViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "VisitProjectViewController.h"
#import "SystemAPI.h"
#import "OAChineseToPinyin.h"
#import <NSDate+Helper.h>

@interface VisitProjectViewController ()
{
    NSMutableDictionary *_dicWeekInfo;
    NSMutableArray *_aryVisitData;
    NSMutableArray *_aryVisitRecord;
    BNVistRecord *_visitRecord;
    int pageCount;
    int currentDate;
}

@end

@implementation VisitProjectViewController

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
    
    _aryVisitRecord = [[NSMutableArray alloc] init];
    _aryVisitData = [[NSMutableArray alloc] init];
    NSDate *today = [NSDate date];
    currentDate = [today getWeekDay];
    [self loadDateInfo];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在检查数据更新...";
    [SystemAPI getServerUpdatetimeSuccess:^(unsigned  long long lastupdatetime) {
        if (lastupdatetime > [ShareValue shareInstance].lastUpdateTime.unsignedLongLongValue) {
            [SystemAPI updateConfigSuccess:^{
                [hud hide:YES];
                [self loadVisitDataWithDate:[[NSDate date] getWeekDay]];
            } fail:^(BOOL notReachable, NSString *desciption) {
                [hud hide:YES];
                [self loadVisitDataWithDate:[[NSDate date] getWeekDay]];
            }];
        }else{
            [self loadVisitDataWithDate:[[NSDate date] getWeekDay]];
            [hud hide:YES];
        }
    } fail:^(BOOL notReachable, NSString *desciption) {
        [hud hide:YES];
        [self loadVisitDataWithDate:[[NSDate date] getWeekDay]];
    }];
    //    if (pageCount > 0) {
//        [self loadVisitDataWithDate:[[NSDate date] getWeekDay]];
//    }
//    pageCount ++;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"计划拜访";
    
    NSString *strCnWeek = [[NSDate date] getCnWeek];
    NSString *strCnDate = [_dicWeekInfo objectForKey:strCnWeek];
    self.lbWeekday.text = strCnWeek;
    self.lbDate.text = strCnDate;
}

#pragma mark - Functions

- (void)loadVisitDataWithDate:(int)date
{
    [_aryVisitData removeAllObjects];
    [_aryVisitRecord removeAllObjects];
    
    NSArray *aryPlans = [BNVisitPlan searchWithWhere:[NSString stringWithFormat:@"WEEKDAY=%D",date] orderBy:@"ORDER_NO" offset:0 count:100];
    NSString *custids = @"";
    int i = 0;
    for (BNVisitPlan *plan in aryPlans) {
        if (i< (aryPlans.count-1)) {
            custids = [custids stringByAppendingFormat:@"%d,",plan.CUST_ID];
        }else{
            custids = [custids stringByAppendingFormat:@"%d",plan.CUST_ID];
        }
        i++;
    }
    NSArray *cusinfo =[BNCustomerInfo searchWithWhere:[NSString stringWithFormat:@"CUST_ID in (%@)",custids] orderBy:@"CUST_NAME_PINYIN" offset:0 count:1000];
    [_aryVisitData addObjectsFromArray:cusinfo];
    
    for(int i=0; i<_aryVisitData.count; i++)
    {
        BNCustomerInfo *customerInfo = [_aryVisitData objectAtIndex:i];
        NSArray *aryRecord = [BNVistRecord searchWithWhere:[NSString stringWithFormat:@"CUST_ID=%D and VISIT_DATE like '%@%@'",customerInfo.CUST_ID,_lbDate.text,@"%"] orderBy:@"VISIT_DATE desc" offset:0 count:100];
        [_aryVisitRecord addObject:aryRecord];
    }
    [_tvContain reloadData];
}

- (void)loadDateInfo
{
    
    _dicWeekInfo = [[NSMutableDictionary alloc] init];
    switch (currentDate) {
        case 2:
            [_dicWeekInfo setValue:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期一"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期二"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:2] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期三"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:3] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期四"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:4] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期五"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:5] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期六"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:6] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期日"];
            
            break;
        case 3:
            [_dicWeekInfo setValue:[[NSDate getNextDate:-1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期一"];
            [_dicWeekInfo setValue:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期二"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期三"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:2] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期四"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:3] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期五"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:4] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期六"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:5] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期日"];
            
            break;
        case 4:
            [_dicWeekInfo setValue:[[NSDate getNextDate:-2] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期一"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期二"];
            [_dicWeekInfo setValue:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期三"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期四"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:2] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期五"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:3] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期六"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:4] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期日"];
            
            break;
        case 5:
            [_dicWeekInfo setValue:[[NSDate getNextDate:-3] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期一"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-2] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期二"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期三"];
            [_dicWeekInfo setValue:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期四"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期五"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:2] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期六"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:3] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期日"];
            
            break;
        case 6:
            [_dicWeekInfo setValue:[[NSDate getNextDate:-4] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期一"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-3] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期二"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-2] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期三"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期四"];
            [_dicWeekInfo setValue:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期五"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期六"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:2] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期日"];
            
            break;
        case 7:
            [_dicWeekInfo setValue:[[NSDate getNextDate:-5] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期一"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-4] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期二"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-3] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期三"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-2] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期四"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期五"];
            [_dicWeekInfo setValue:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期六"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期日"];
            
            break;
        case 1:
            [_dicWeekInfo setValue:[[NSDate getNextDate:-6] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期一"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-5] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期二"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-4] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期三"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-3] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期四"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-2] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期五"];
            [_dicWeekInfo setValue:[[NSDate getNextDate:-1] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期六"];
            [_dicWeekInfo setValue:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forKey:@"星期日"];
            
            break;
            
        default:
            break;
    }
}

- (IBAction)handleBtnWeek:(id)sender {
    NSArray *aryItems = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    LeveyPopListView *popListView = [[LeveyPopListView alloc] initWithTitle:@"选择客户" options:aryItems handler:^(NSInteger anIndex) {
        NSString *strSelect = [aryItems objectAtIndex:anIndex];
        _lbWeekday.text = strSelect;
        _lbDate.text = [_dicWeekInfo objectForKey:strSelect];
        
        int iData = 0;
        if([strSelect isEqualToString:@"星期日"])
        {
            iData = 1;
        }
        else if([strSelect isEqualToString:@"星期一"])
        {
            iData = 2;
        }
        else if([strSelect isEqualToString:@"星期二"])
        {
            iData = 3;
        }
        else if([strSelect isEqualToString:@"星期三"])
        {
            iData = 4;
        }
        else if([strSelect isEqualToString:@"星期四"])
        {
            iData = 5;
        }
        else if([strSelect isEqualToString:@"星期五"])
        {
            iData = 6;
        }
        else if([strSelect isEqualToString:@"星期六"])
        {
            iData = 7;
        }
        currentDate = iData;
        [self loadVisitDataWithDate:iData];
        [_tvContain reloadData];
    }];
    [popListView showInView:[UIApplication sharedApplication].delegate.window animated:NO];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryVisitData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    VisitProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VISITPROJECTCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"VisitProjectCell" bundle:nil] forCellReuseIdentifier:@"VISITPROJECTCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"VISITPROJECTCELL"];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    BNCustomerInfo *customerInfo = nil;
    if(_aryVisitData.count > 0)
    {
        customerInfo = [_aryVisitData objectAtIndex:indexPath.row];
    }
    NSArray *aryRecords = [_aryVisitRecord objectAtIndex:indexPath.row];
    [cell setCellWithValue:customerInfo VistRecord:aryRecords];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BNCustomerInfo *customerInfo = [_aryVisitData objectAtIndex:indexPath.row];
    NSArray *aryRecords = [_aryVisitRecord objectAtIndex:indexPath.row];
    
    CusDetailViewController *cusDetailViewController = [[CusDetailViewController alloc] initWithNibName:@"CusDetailViewController" bundle:nil];
    cusDetailViewController.customerInfo = customerInfo;
    if( aryRecords.count > 0)
    {
        cusDetailViewController.visitRecord = [aryRecords objectAtIndex:0];
    }
    else
    {
        cusDetailViewController.visitRecord = nil;
    }
    cusDetailViewController.strDateSelect = _lbDate.text;
    
    [self.navigationController pushViewController:cusDetailViewController animated:YES];
}


@end
