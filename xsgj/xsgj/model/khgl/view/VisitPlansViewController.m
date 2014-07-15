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

@interface PlanCell : UITableViewCell{
    UILabel *lb_customeName;
    UILabel *lb_linkman;
    UILabel *lb_state;
}

@property(nonatomic,strong) VisitPlan *plan;

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
        lb_state = [[UILabel alloc]initWithFrame:CGRectMake(230, 2, 80, 20)];
        lb_state.font = [UIFont systemFontOfSize:12];
        lb_state.textColor = HEX_RGB(0x409be4);
        [self.contentView addSubview:lb_customeName];
        [self.contentView addSubview:lb_linkman];
    }
    return self;
}

-(void)setPlan:(VisitPlan *)plan{
    _plan = plan;
    lb_customeName.text = plan.CUST_NAME;
    lb_linkman.text = plan.LINKMAN;
    lb_state.text = [plan stateName];
}

@end


@interface VisitPlansViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dataButtons;
    NSMutableArray *_contentTableViews;
    UIView *_lightLine;
    NSMutableArray *_dateArray;
    int _index;
    NSMutableArray *_dataArray;
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
    [self initDatas];
    [self initTab];
    [self initContent];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -initView
//明天开始的七天
-(void)initDatas{
    _dateArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    for (int i= 0; i< 7; i ++) {
        [_dateArray addObject:[NSDate getNextDate:i]];
        [_dataArray addObject:[NSMutableArray array]];
    }
}

//创建tab
-(void)initTab{
    _dataButtons = [NSMutableArray array];
    CGFloat topScorllViewX = 10;
    int i = 0;
    for (NSDate *date in _dateArray) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(topScorllViewX, 0, 80, _sv_tab.frame.size.height)];
        btn.tag = i;
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [btn setTitle:[date getCnWeek] forState:UIControlStateNormal];
        topScorllViewX += 80;
        if (i < 6) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(topScorllViewX, 10, 1, _sv_tab.frame.size.height - 20)];
            [line setBackgroundColor:[UIColor lightGrayColor]];
            [_sv_tab addSubview:line];
        }
        [btn addTarget:self action:@selector(tabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sv_tab addSubview:btn];
        i++;
    }
    
    topScorllViewX += 10;
    _lightLine = [[UIView alloc]initWithFrame:CGRectMake(10, _sv_tab.frame.size.height - 3, 80, 3)];
    _lightLine.backgroundColor = HEX_RGB(0x409be4);
    [_sv_tab addSubview:_lightLine];
    _sv_tab.contentSize = CGSizeMake(topScorllViewX, _sv_tab.frame.size.height);
}

-(void)initContent{
    _contentTableViews = [NSMutableArray array];
    [_sv_content setPagingEnabled:YES];
    CGFloat contentScorllViewX = 0;
    int i = 0;
    for (NSDate *date in _dateArray) {
        //创建Content
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(contentScorllViewX, 0, _sv_content.frame.size.width, _sv_content.frame.size.height)];
        tableView.tag = i;
        contentScorllViewX += _sv_content.frame.size.width;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor whiteColor];
        [_sv_content addSubview:tableView];
        i++;
    }
    _sv_content.contentSize = CGSizeMake(contentScorllViewX, _sv_content.frame.size.height);
    _sv_content.delegate = self;
}



#pragma mark - Action

-(void)tabBtnClick:(UIButton *)btn{
    int tag = btn.tag;
    if (tag != _index) {
        [_sv_content scrollRectToVisible:CGRectMake(_sv_content.frame.size.width * tag, 0, _sv_content.frame.size.width, _sv_content.frame.size.height) animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = _lightLine.frame;
            rect.origin.x = 10 + 80.0*tag;
            _lightLine.frame = rect;
        }];
        _index = tag;
    }
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
            rect.origin.x = 10 + 80.0*currentPage;
            _lightLine.frame = rect;
        }];
        _index = currentPage;
    }
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
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 290, 44)];
            lable.backgroundColor = [UIColor clearColor];
            lable.textAlignment = UITextAlignmentLeft;
            lable.font = [UIFont systemFontOfSize:14];
            lable.tag = 111;
            lable.text = @"11111";
            lable.textColor = [UIColor darkTextColor];
            cell.contentView.layer.masksToBounds = YES;
//            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
//            view.backgroundColor = [UIColor darkTextColor];
//            [cell.contentView addSubview:view];
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
        cell.plan = [array objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return [PlanCell height];
    }
}



@end
