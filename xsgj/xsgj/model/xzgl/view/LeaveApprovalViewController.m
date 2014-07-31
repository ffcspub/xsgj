//
//  LeaveApprovalViewController.m
//  xsgj
//
//  Created by Geory on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "LeaveApprovalViewController.h"
#import "UIColor+External.h"
#import "XZGLAPI.h"
#import "MBProgressHUD+Add.h"
#import "LeaveInfoBean.h"
#import "SVPullToRefresh.h"
#import "ApprovalInfoViewController.h"

typedef  enum : NSUInteger {
    TOP = 0,
    MID = 1,
    BOT = 2,
    SINGLE
} LeaveApprovalCellStyle;

@interface LeaveApprovalCell : UITableViewCell{
    UIImageView *_backView;
    UIImageView *_backSelectedView;
    UIImageView *_stateView;
    UILabel *_lb_state;
    UILabel *_lb_name;
    UILabel *_lb_time;
}

@property(nonatomic,assign) LeaveApprovalCellStyle style;
@property(nonatomic,assign) int state;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *time;

+(CGFloat)height;

@end

@implementation LeaveApprovalCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, [LeaveApprovalCell height])];
        _stateView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 26, 26)];
        _lb_state = [[UILabel alloc] initWithFrame:CGRectMake(9, 33, 29, 21)];
        _lb_state.font = [UIFont systemFontOfSize:12];
        _lb_state.textAlignment = NSTextAlignmentCenter;
        _lb_name = [[UILabel alloc]initWithFrame:CGRectMake(46, 5, 210, 28)];
        _lb_name.backgroundColor = [UIColor clearColor];
        _lb_name.font = [UIFont systemFontOfSize:17];
        _lb_time = [[UILabel alloc]initWithFrame:CGRectMake(46, 31, 210,21)];
        _lb_time.textColor = HEX_RGB(0x939fa7);
        _lb_time.font = [UIFont systemFontOfSize:15];
        UIImageView *iv_next = [[UIImageView alloc] initWithFrame:CGRectMake(265, 15, 26, 26)];
        iv_next.image = [UIImage imageNamed:@"tableCtrlBtnIcon_next_nor"];
        self.backgroundView = _backView;
        self.selectedBackgroundView = _backSelectedView;
        [self.contentView addSubview:_stateView];
        [self.contentView addSubview:_lb_state];
        [self.contentView addSubview:_lb_name];
        [self.contentView addSubview:_lb_time];
        [self.contentView addSubview:iv_next];
    }
    return self;
}

+(CGFloat)height{
    return 56.0;
}

-(void)setStyle:(LeaveApprovalCellStyle)style{
    _style = style;
    switch (style) {
        case TOP:{
            _backView.image = [ShareValue tablePart1];
            _backSelectedView.image = [ShareValue tablePart1S];
        }
            break;
        case MID:{
            _backView.image = [ShareValue tablePart2];
            _backSelectedView.image = [ShareValue tablePart2S];
        }
            break;
        case BOT:{
//            _backView.image = [ShareValue tablePart3];
//            _backSelectedView.image = [ShareValue tablePart3S];
            
            UIImage *image = [UIImage imageNamed:@"table_part3"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            _backView.image = image;
            
            UIImage *imageSelect = [UIImage imageNamed:@"table_part3_s"];
            imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            _backSelectedView.image = imageSelect;
        }
            break;
        case SINGLE:{
            UIImage *image = [UIImage imageNamed:@"table_main_n"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            _backView.image = image;
            
            UIImage *imageSelect = [UIImage imageNamed:@"table_main_s"];
            imageSelect = [imageSelect resizableImageWithCapInsets:UIEdgeInsetsMake(5, 12, 5, 12)];
            _backSelectedView.image = imageSelect;
        }
            break;
        default:
            break;
    }
}

- (void)setState:(int)state
{
    _state = state;
    switch (state) {
        case 0:
            _stateView.image = [UIImage imageNamed:@"stateicon_wait"];
            _lb_state.text = @"待审";
            break;
        case 1:
            _stateView.image = [UIImage imageNamed:@"stateicon_pass"];
            _lb_state.text = @"通过";
            break;
        case 2:
            _stateView.image = [UIImage imageNamed:@"stateicon_nopass"];
            _lb_state.text = @"驳回";
            break;
        default:
            break;
    }
}

-(void)setName:(NSString *)name{
    _name = name;
    _lb_name.text = name;
}

-(void)setTime:(NSString *)time{
    _time = time;
    _lb_time.text = time;
}

@end

static int const pageSize = 10;

@interface LeaveApprovalViewController ()
{
    NSMutableArray *_leaves;
    int page;
}

@end

@implementation LeaveApprovalViewController

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
    
    _leaves = [[NSMutableArray alloc] init];
    
    __weak LeaveApprovalViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadLeaves];
    }];
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    page = 0;
    self.tableView.showsInfiniteScrolling = YES;
    [self loadLeaves];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLeaves
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    page++;
    QueryLeaveHttpRequest *request = [[QueryLeaveHttpRequest alloc] init];
    request.PAGE = page;
    request.ROWS = pageSize;
    request.LEADER = [NSString stringWithFormat:@"%d",[ShareValue shareInstance].userInfo.USER_ID];
    request.APPROVE_STATE = @"";
    
    [XZGLAPI queryLeaveByRequest:request success:^(QueryLeaveHttpResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        int resultCount = [response.LEAVEINFOBEAN count];
        if (resultCount < pageSize) {
            self.tableView.showsInfiniteScrolling = NO;
        }
        if (page == 1) {
            [_leaves removeAllObjects];
        }
        
        [self.tableView.infiniteScrollingView stopAnimating];
        [_leaves addObjectsFromArray:response.LEAVEINFOBEAN];
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView.infiniteScrollingView stopAnimating];
        self.tableView.showsInfiniteScrolling = NO;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_leaves count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"LEAVEAPPROVALCELL";
    LeaveApprovalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LeaveApprovalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    LeaveinfoBean *info = [_leaves objectAtIndex:indexPath.row];
    
    cell.name = info.TYPE_NAME;
    cell.time = info.APPLY_TIME;
    cell.state = info.APPROVE_STATE;
    
    if ([_leaves count] == 1) {
        cell.style = SINGLE;
    } else {
        if (indexPath.row == 0) {
            cell.style = TOP;
        } else if (indexPath.row == ([_leaves count] - 1)) {
            cell.style = BOT;
        } else {
            cell.style = MID;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LeaveApprovalCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ApprovalInfoViewController *vlc = [[ApprovalInfoViewController alloc] initWithNibName:@"ApprovalInfoViewController" bundle:nil];
    LeaveinfoBean *info = [_leaves objectAtIndex:indexPath.row];
    vlc.leaveInfo = info;
    
    if (info.APPROVE_STATE == 0) {
        vlc.showStyle = ApprovalInfoShowStyleApproval;
    } else {
        vlc.showStyle = ApprovalInfoShowStyleQuery;
    }
    
    [self.navigationController pushViewController:vlc animated:YES];
}

@end
