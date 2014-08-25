//
//  VisitPlansViewController.m
//  xsgj
//
//  Created by ilikeido on 14-7-14.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "VisitPlansViewController.h"
#import "NSDate+Util.h"
#import <NSDate+Helper.h>
#import "UIColor+External.h"
#import "CustomerInfo.h"
#import "VisitPlan.h"
#import "KHGLAPI.h"
#import "PlanVisitConfig.h"
#import "MBProgressHUD+Add.h"
#import <IBActionSheet.h>
#import "CustomerChooseViewController.h"
#import "BNCustomerInfo.h"
#import "NSObject+EasyCopy.h"
#import "PlanInfoViewController.h"
#import "OfflineRequestCache.h"

@interface PlanCell : UITableViewCell{
    UILabel *lb_customeName;
    UILabel *lb_linkman;
    UILabel *lb_state;
    UILabel *lb_otherstate;
    UIImageView *iv_delete;
}

@property(nonatomic,strong) CustomerInfo *customer;
@property(nonatomic,assign) BOOL deleteModel;
@property(nonatomic,assign) BOOL isSelected;

+(CGFloat)height;

@end

@implementation PlanCell

+(CGFloat)height{
    return 50;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        lb_customeName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 220, 20)];
        lb_customeName.font = [UIFont systemFontOfSize:15];
        lb_customeName.textColor = [UIColor darkTextColor];
        lb_linkman = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 250, 15)];
        lb_linkman.font = [UIFont systemFontOfSize:12];
        lb_linkman.textColor = [UIColor grayColor];
        lb_state = [[UILabel alloc]initWithFrame:CGRectMake(250, 5, 60, 20)];
        lb_state.textAlignment = UITextAlignmentRight;
        lb_state.font = [UIFont systemFontOfSize:12];
        lb_state.textColor = MCOLOR_BLUE;
        lb_otherstate = [[UILabel alloc]initWithFrame:CGRectMake(250, 30, 60, 15)];
        lb_otherstate.textAlignment = UITextAlignmentRight;
        lb_otherstate.font = [UIFont systemFontOfSize:12];
        lb_otherstate.textColor = MCOLOR_GRAY;
        iv_delete = [[UIImageView alloc]initWithFrame:CGRectMake(260, 0, 40, [PlanCell height])];
        iv_delete.image = [UIImage imageNamed:@"btn_check_off"];
        iv_delete.contentMode = UIViewContentModeCenter;
        iv_delete.hidden = YES;
        [self.contentView addSubview:lb_customeName];
        [self.contentView addSubview:lb_linkman];
        [self.contentView addSubview:lb_state];
        [self.contentView addSubview:lb_otherstate];
        [self.contentView addSubview:iv_delete];
    }
    return self;
}

-(void)setCustomer:(CustomerInfo *)customer{
    _customer = customer;
    lb_customeName.text = customer.CUST_NAME;
    lb_linkman.text = customer.ADDRESS;
    lb_state.text = [customer stateName];
     lb_otherstate.text = [customer applyStateName];
    if (customer.CHECK_STATE == 0) {
        lb_state.textColor = MCOLOR_BLUE;
    }else if (customer.CHECK_STATE == 1){
        lb_state.textColor = MCOLOR_GREEN;
    }else if (customer.CHECK_STATE == 2){
        lb_state.textColor = MCOLOR_RED;
    }else if (customer.CHECK_STATE == 3){
        lb_state.textColor = MCOLOR_BLUE;
    }
}

-(void)setIsSelected:(BOOL)isSelected{
    if (isSelected) {
        [iv_delete setImage:[UIImage imageNamed:@"btn_check_on"]];
    }else {
        [iv_delete setImage:[UIImage imageNamed:@"btn_check_off"]];
    }
}

-(void)setDeleteModel:(BOOL)deleteModel{
    if (deleteModel) {
        if (_customer.CHECK_STATE == 3 && !_customer.isOffline) {
            iv_delete.hidden = YES;
        }else{
            iv_delete.hidden = NO;
        }
        lb_otherstate.hidden = YES;
        lb_state.hidden = YES;
    }else{
        iv_delete.hidden = YES;
        lb_otherstate.hidden = NO;
        lb_state.hidden = NO;
    }
}

@end


@interface VisitPlansViewController ()<UITableViewDataSource,UITableViewDelegate,IBActionSheetDelegate,CustomerChooseDelegate>{
    NSMutableArray *_dataButtons;
    NSMutableArray *_contentTableViews;
    UIView *_lightLine;
    NSMutableArray *_dateArray;
    int _index;
    NSMutableArray *_dataArray;
    IBActionSheet *_sheet;
    NSMutableDictionary *_waitingDeleteDict;
    NSMutableArray *_selectedArray;
}

@end

@implementation VisitPlansViewController

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
    _btn_submit.hidden = YES;
    [self showRightBarButtonItemWithTitle:@"操作" target:self action:@selector(showMenus:) ];
    
    [_btn_submit configBlueStyle];
    [self loadPlanVisits];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -function

-(NSMutableArray *)getCustomerIdArray{
    NSArray *array = [_dataArray objectAtIndex:_index];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (CustomerInfo *customer in array) {
        [tempArray addObject:[NSNumber numberWithInt:customer.CUST_ID]];
    }
    return tempArray;
}

-(void)showMenus:(UIButton *)sender{
    if (_sheet) {
        [_sheet dismissAnimated:NO];
    }
   _sheet =  [[IBActionSheet alloc]initWithTitle:@"操作" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"新增" otherButtonTitles:@"删除",nil];
    _sheet.shouldCancelOnTouch = YES;
    [_sheet showInView:self.view];
}

#pragma mark -IBActionSheetDelegate
-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;{
    if (buttonIndex == 0) {
        CustomerChooseViewController *vcl = [[CustomerChooseViewController alloc]init];
        vcl.chooseDelegate = self;
        vcl.deselectedCutomerIds = [self getCustomerIdArray];
        [self.navigationController pushViewController:vcl animated:YES];
    }else if(buttonIndex == 1){
        [_waitingDeleteDict setObject:@1 forKey:[NSNumber numberWithInt:_index]];
        [self hideOrShowTool];
        UITableView *tableView = [_contentTableViews objectAtIndex:_index];
        [tableView reloadData];
    }
}

#pragma mark -initView

-(void)loadPlanVisits{
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    QueryPlanVisitConfigsHttpRequest *request = [[QueryPlanVisitConfigsHttpRequest alloc]init];
    request.PLAN_DATE = [[NSDate getNextDate:1] stringWithFormat:@"yyyy-MM-dd"];
    [KHGLAPI queryPlanVisiConfigsByRequest:request success:^(QueryPlanVisitConfigsHttpResponse *response) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        _btn_submit.hidden = NO;
        NSArray *array =  response.PLAN_VISIT_CONFIGS;
        _dateArray = [[NSMutableArray alloc]init];
        _dataArray = [[NSMutableArray alloc]init];
        _waitingDeleteDict = [[NSMutableDictionary alloc]init];
        _selectedArray = [[NSMutableArray alloc]init];
        int i = 0;
        for (PlanVisitConfig *visitConfig in array) {
            [_dateArray addObject:[NSDate dateFromString:visitConfig.PLAN_DATE withFormat:@"yyyy-MM-dd"]];
            if (!visitConfig.VISIT_PLANS) {
                [_dataArray addObject:[NSArray array]];
            }else{
               [_dataArray addObject:visitConfig.VISIT_PLANS];
            }
            [_waitingDeleteDict setObject:@0 forKey:[NSNumber numberWithInt:i]];
            [_selectedArray addObject:[NSMutableArray array]];
            i++;
        }
        [self initTab];
        [self initContent];
        [self selectPage:_index];
//        [self loadPlayVisitRecords];
    } fail:^(BOOL notReachable, NSString *desciption) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:@"网络不给力" toView:ShareAppDelegate.window];
    }];
}

////明天开始的七天
//-(void)initDatas{
//    _dateArray = [[NSMutableArray alloc]init];
//    _dataArray = [[NSMutableArray alloc]init];
//    for (int i= 0; i< 7; i ++) {
//        [_dateArray addObject:[NSDate getNextDate:i]];
//        [_dataArray addObject:[NSMutableArray array]];
//    }
//}

//创建tab
-(void)initTab{
    _dataButtons = [NSMutableArray array];
    for (UIView *view in _sv_tab.subviews) {
        [view removeFromSuperview];
    }
    _sv_tab.contentSize = _sv_tab.frame.size;
    
    CGFloat topScorllViewX = 5;
    int i = 0;
    for (NSDate *date in _dateArray) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(topScorllViewX, 0, 80, _sv_tab.frame.size.height)];
        btn.tag = i;
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:[date getCnWeek] forState:UIControlStateNormal];
        topScorllViewX += 80;
        if (i < 6) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(topScorllViewX, 5, 1, _sv_tab.frame.size.height - 10)];
            [line setBackgroundColor:[UIColor lightGrayColor]];
            [_sv_tab addSubview:line];
        }
        [btn addTarget:self action:@selector(tabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sv_tab addSubview:btn];
        i++;
    }
    
    topScorllViewX += 5;
    _lightLine = [[UIView alloc]initWithFrame:CGRectMake(5, _sv_tab.frame.size.height - 3, 80, 3)];
    _lightLine.backgroundColor = HEX_RGB(0x409be4);
    [_sv_tab addSubview:_lightLine];
    _sv_tab.contentSize = CGSizeMake(topScorllViewX, _sv_tab.frame.size.height);
}

-(void)initContent{
    
    NSArray *array = _sv_content.subviews;
    for (UIView *view in array) {
        [view removeFromSuperview];
    }
    _sv_content.contentSize = _sv_content.frame.size;
    if (!_contentTableViews) {
        _contentTableViews = [NSMutableArray array];
    }else{
        [_contentTableViews removeAllObjects];
    }
    [_sv_content setPagingEnabled:YES];
    
    CGFloat contentScorllViewX = 0;
    int count  = _dataArray.count;
    for (int i=0;i<count;i++) {
        //创建Content
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(contentScorllViewX, 0, _sv_content.frame.size.width, _sv_content.frame.size.height)];
        tableView.tag = i;
        contentScorllViewX += _sv_content.frame.size.width;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor whiteColor];
        [_contentTableViews addObject:tableView];
        [_sv_content addSubview:tableView];
    }
    _sv_content.contentSize = CGSizeMake(contentScorllViewX, _sv_content.frame.size.height);
    _sv_content.delegate = self;
    [self selectPage:_index];
}


-(void)loadPlayVisitRecords{
    QueryPlanVisitConfigsHttpRequest *request = [[QueryPlanVisitConfigsHttpRequest alloc]init];
    NSDate *beginDate = _dataArray.firstObject;
    request.PLAN_DATE = [beginDate stringWithFormat:@"yyyy-MM-dd"];
    [KHGLAPI queryPlanVisiConfigsByRequest:request success:^(QueryPlanVisitConfigsHttpResponse *response) {
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}

-(void)hideOrShowTool{
    NSNumber *flag = [_waitingDeleteDict objectForKey:[NSNumber numberWithInt:_index]];
    if (flag.intValue == 1) {
        [_vi_tool setHidden:NO];
    }else{
        [_vi_tool setHidden:YES];
    }
}

#pragma mark - Action

-(void)tabBtnClick:(UIButton *)btn{
    int tag = btn.tag;
    [self selectPage:tag];
}

-(void)selectPage:(int)page{
    _index = page;
    [_sv_tab scrollRectToVisible:CGRectMake(80*page, 0, _sv_tab.frame.size.width, _sv_tab.frame.size.height) animated:YES];
    [_sv_content scrollRectToVisible:CGRectMake(_sv_content.frame.size.width*page, 0, _sv_content.frame.size.width, _sv_content.frame.size.height) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _lightLine.frame;
        rect.origin.x = 5 + 80.0*page;
        _lightLine.frame = rect;
    }];
    [self hideOrShowTool];
}

-(int)nextPage{
    if (_index < [_dateArray count]-1) {
        return _index + 1;
    }
    return _index;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _sv_content) {
        CGFloat pageWidth = _sv_content.frame.size.width;
        // 根据当前的x坐标和页宽度计算出当前页数
        int currentPage = floor((_sv_content.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [UIView animateWithDuration:0.3 animations:^{
            [_sv_tab scrollRectToVisible:CGRectMake(80*currentPage, 0, _sv_tab.frame.size.width, _sv_tab.frame.size.height) animated:YES];
            CGRect rect = _lightLine.frame;
            rect.origin.x = 5 + 80.0*currentPage;
            _lightLine.frame = rect;
        }];
        _index = currentPage;
        [self hideOrShowTool];
    }
}


-(BOOL)isDeleteMode{
    NSNumber * isFlag = [_waitingDeleteDict objectForKey:[NSNumber numberWithInt:_index]];
    return isFlag.intValue == 1;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int tag = tableView.tag;
    if (section == 0) {
        return 1;
    }
    NSArray *array = [_dataArray objectAtIndex:tag];
    return array.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int tag = tableView.tag;
    if (indexPath.section == 0) {
        static NSString *DATECELL = @"DATECELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DATECELL];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DATECELL];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 290, 30)];
            lable.backgroundColor = [UIColor clearColor];
            lable.textAlignment = UITextAlignmentLeft;
            lable.font = [UIFont systemFontOfSize:17];
            lable.tag = 111;
            lable.textColor = [UIColor darkTextColor];
            cell.contentView.layer.masksToBounds = YES;
            [cell.contentView addSubview:lable];
        }
        UILabel *lable = (UILabel *)[cell.contentView viewWithTag:111];
        NSDate *date = [_dateArray objectAtIndex:tag];
        NSString *dateString = [date stringWithFormat:@"yyyy-MM-dd"];
        lable.text = dateString;
        return cell;
    }else if (indexPath.section == 1){
        NSArray *array = [_dataArray objectAtIndex:tag];
        static NSString *PLANCELL = @"PLANCELL";
        PlanCell *cell = [tableView dequeueReusableCellWithIdentifier:PLANCELL];
        if (!cell) {
            cell = [[PlanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PLANCELL];
            cell.contentView.layer.masksToBounds = YES;
        }
       
        if ([self isDeleteMode]) {
            cell.deleteModel = YES;
            NSMutableArray *array = [_selectedArray objectAtIndex:_index];
            if ([array containsObject:cell.customer]) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
        }else{
            cell.deleteModel = NO;
        }
        
        cell.customer = [array objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 30;
    }else{
        return [PlanCell height];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && [self isDeleteMode]) {
        NSMutableArray *customerArray = [_dataArray objectAtIndex:_index];
        NSMutableArray *array = [_selectedArray objectAtIndex:_index];
        CustomerInfo *customerInfo = [customerArray objectAtIndex:indexPath.row];
        if (customerInfo.CHECK_STATE == 3 && customerInfo.isOffline) {
            return;
        }
        if ([array containsObject:customerInfo]) {
            [customerInfo setCHECK_STATE:customerInfo.oldCheckState];
            [customerInfo setOfflineState:NO];
            [array removeObject:customerInfo];
        }else{
            [customerInfo setOldCheckState:customerInfo.CHECK_STATE];
            [array addObject:customerInfo];
        }
        UITableView *tableView = [_contentTableViews objectAtIndex:_index];
        [tableView reloadData];
    }else if(indexPath.section == 1 && ![self isDeleteMode]){
        PlanInfoViewController *vlc = [[PlanInfoViewController alloc]init];
        NSMutableArray *customerArray = [_dataArray objectAtIndex:_index];
        CustomerInfo *customerInfo = [customerArray objectAtIndex:indexPath.row];
        vlc.customerInfo = customerInfo;
        [self.navigationController pushViewController:vlc animated:YES];
    }
}

#pragma mark - CustomerChooseDelegate

-(void)chooseCustomer:(NSArray *)customers{
    NSMutableArray *array = [_dataArray objectAtIndex:_index];
    for (BNCustomerInfo *bnCustomerInfo in customers) {
        CustomerInfo *customerInfo = [[CustomerInfo alloc]init];
        [bnCustomerInfo easyDeepCopy:customerInfo];
        [customerInfo setOfflineState:YES];
        [array addObject:customerInfo];
    }
    UITableView *tableView = [_contentTableViews objectAtIndex:_index];
    [tableView reloadData];
}

#pragma mark - Action
- (IBAction)submitAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    UpdateVisitPlansHttpRequest *request = [[UpdateVisitPlansHttpRequest alloc]init];
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *datas = [_dataArray objectAtIndex:_index];
    for (CustomerInfo *customerInfo in datas) {
        VisitPlan *vistiPlan = [[VisitPlan alloc]init];
        vistiPlan.CUST_ID = customerInfo.CUST_ID;
        vistiPlan.CHECK_STATE = customerInfo.CHECK_STATE;
        vistiPlan.CHECK_REMARK = customerInfo.CHECK_REMARK;
        vistiPlan.CUST_NAME = customerInfo.CUST_NAME;
        [array addObject:vistiPlan];
    }
    request.VISIT_PLANS = array;
    NSDate *date = [_dateArray objectAtIndex:_index];
    request.PLAN_DATE = [date stringWithFormat:@"yyyy-MM-dd"];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSDayCalendarUnit |
                           NSWeekdayCalendarUnit) fromDate:date];
    request.WEEKDAY = [weekdayComponents weekday];
    
    [KHGLAPI updateVisitPlansByRequest:request success:^(UpdateVisitPlansHttpResponse *response) {
        NSMutableArray *datas = [_selectedArray objectAtIndex:_index];
        [datas removeAllObjects];
        NSDate *date = [_dateArray objectAtIndex:_index];
        NSString *message = [NSString stringWithFormat:@"%@拜访规划提交成功",[date stringWithFormat:@"yyyy-MM-dd"]];
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showSuccess:message toView:ShareAppDelegate.window];
        _index = [self nextPage];
        [self loadPlanVisits];
    } fail:^(BOOL notReachable, NSString *desciption) {
        if (notReachable) {
            OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:@"拜访规划"];
            [cache saveToDB];
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showSuccess:DEFAULT_OFFLINE_MESSAGE_REPORT toView:ShareAppDelegate.window];
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
        }
    }];
    
}

- (IBAction)cancelDelteAction:(id)sender {
    [_waitingDeleteDict setObject:@0 forKey:[NSNumber numberWithInt:_index]];
    UITableView *tableView = [_contentTableViews objectAtIndex:_index];
    [tableView reloadData];
    [self hideOrShowTool];
}

- (IBAction)submitDeleteAction:(id)sender {
    NSMutableArray *datas = [_selectedArray objectAtIndex:_index];
    NSMutableArray *deleArray = [NSMutableArray array];
    for (CustomerInfo *customerInfo in datas) {
        if (customerInfo.CHECK_STATE == 0 && customerInfo.isOffline) {
            [deleArray addObject:customerInfo];
            continue;
        }
        customerInfo.CHECK_STATE = 3;
        [customerInfo setOfflineState:YES];
    }
    NSMutableArray *indexDatas = [_dataArray objectAtIndex:_index];
    //先删除未提交的申请
    [indexDatas removeObjectsInArray:deleArray];
    [self cancelDelteAction:nil];
}

@end
