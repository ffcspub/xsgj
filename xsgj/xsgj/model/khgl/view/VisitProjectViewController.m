//
//  VisitProjectViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "VisitProjectViewController.h"

@interface VisitProjectViewController ()

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
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"计划拜访";
}

#pragma mark - Functions

- (void)getDateInfo
{
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSInteger week;
    NSString *strWeek = @"";
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:now];
    year = [comps year];
    month = [comps month];
    day = [comps day];
    week = [comps weekday];
    
    switch (week) {
        case 1:
            strWeek = @"星期天";
            break;
        case 2:
            strWeek = @"星期一";
            break;
        case 3:
            strWeek = @"星期二";
            break;
        case 4:
            strWeek = @"星期三";
            break;
        case 5:
            strWeek = @"星期四";
            break;
        case 6:
            strWeek = @"星期五";
            break;
        case 7:
            strWeek = @"星期六";
            break;
            
        default:
            break;
    }
}

//-(void)loadVisitPorject{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    QueryPlanVisitConfigsHttpRequest *request = [[QueryPlanVisitConfigsHttpRequest alloc]init];
//    request.PLAN_DATE = [[NSDate getNextDate:1] stringWithFormat:@"yyyy-MM-dd"];
//    [KHGLAPI queryPlanVisiConfigsByRequest:request success:^(QueryPlanVisitConfigsHttpResponse *response) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        NSArray *array =  response.PLAN_VISIT_CONFIGS;
//        _dateArray = [[NSMutableArray alloc]init];
//        _dataArray = [[NSMutableArray alloc]init];
//        _waitingDeleteDict = [[NSMutableDictionary alloc]init];
//        _selectedArray = [[NSMutableArray alloc]init];
//        int i = 0;
//        for (PlanVisitConfig *visitConfig in array) {
//            [_dateArray addObject:[NSDate dateFromString:visitConfig.PLAN_DATE withFormat:@"yyyy-MM-dd"]];
//            if (!visitConfig.VISIT_PLANS) {
//                [_dataArray addObject:[NSArray array]];
//            }else{
//                [_dataArray addObject:visitConfig.VISIT_PLANS];
//            }
//            [_waitingDeleteDict setObject:@0 forKey:[NSNumber numberWithInt:i]];
//            [_selectedArray addObject:[NSMutableArray array]];
//            i++;
//        }
//        [self initTab];
//        [self initContent];
//        [self selectPage:_index];
//        //        [self loadPlayVisitRecords];
//    } fail:^(BOOL notReachable, NSString *desciption) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:@"网络不给力" toView:self.view];
//    }];
//}

- (IBAction)handleBtnWeek:(id)sender {
}
@end
