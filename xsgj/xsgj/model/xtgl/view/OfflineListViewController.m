//
//  OfflineListViewController.m
//  xsgj
//
//  Created by ilikeido on 14-8-1.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "OfflineListViewController.h"
#import "OfflineRequestCache.h"
#import <LKDBHelper.h>
#import "OffilineDetailViewController.h"

typedef  enum : NSUInteger {
    TOP = 0,
    MID = 1,
    BOT = 2,
    SINGLE = 3
} OfflineCellStyle;

@interface OfflineCell : UITableViewCell{
    UILabel *lb_name;
    UILabel *lb_time;
    UILabel *lb_state;
    UIImageView *_backView;
}
@property(nonatomic,assign) OfflineCellStyle style;
@property(nonatomic,strong) OfflineRequestCache *requestCache;


+(CGFloat)height;

@end

@implementation OfflineCell

+(CGFloat)height{
    return 44.0;
}

-(void)setStyle:(OfflineCellStyle)style{
    _style = style;
    switch (style) {
        case SINGLE:{
            _backView.image = [ShareValue tablePart];
        }
            break;
        case TOP:{
            _backView.image = [ShareValue tablePart1];
        }
            break;
        case MID:{
            _backView.image = [ShareValue tablePart2];
        }
            break;
        case BOT:{
            _backView.image = [ShareValue tablePart3];;
        }
            break;
        default:
            break;
    }
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, [OfflineCell height])];
        lb_name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 140, 22)];
        lb_time = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 130, 22)];
        lb_state = [[UILabel alloc]initWithFrame:CGRectMake(15, 22, 280, 22)];
        lb_name.font = [UIFont systemFontOfSize:15];
        lb_time.font = [UIFont systemFontOfSize:12];
        lb_state.font = [UIFont systemFontOfSize:12];
        lb_name.textColor = MCOLOR_BLUE;
        lb_state.textColor = MCOLOR_BLUE;
        lb_time.textColor = MCOLOR_BLACK;
        [self.contentView addSubview:_backView];
        [self.contentView addSubview:lb_name];
        [self.contentView addSubview:lb_time];
        [self.contentView addSubview:lb_state];
        self.backgroundView = _backView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setRequestCache:(OfflineRequestCache *)requestCache{
    _requestCache = requestCache;
    lb_name.text = _requestCache.name;
    lb_time.text = _requestCache.time;
    if (requestCache.updateCount > 0) {
        lb_state.text = @"上报失败，等待重试";
    }else{
        lb_state.text = @"等待上报";
    }
}

@end

@interface OfflineListViewController (){
    NSMutableArray *_datas;
}

@end

@implementation OfflineListViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSuccess:) name:NOTIFICATION_OFFLINESENDSUCCESS object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDatas];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)updateSuccess:(NSNotification *)notification{
    [self loadDatas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void)loadDatas{
    _datas = [OfflineRequestCache searchWithWhere:@"isUpload=0" orderBy:@"time desc" offset:0 count:1000];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [_tableView reloadData];
    });
   
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OffilineDetailViewController *vlc = [[OffilineDetailViewController alloc]init];
    vlc.cache = [_datas objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vlc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELLIDENTIFIER = @"OfflineCell";
    OfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER ];
    if (!cell) {
        cell = [[OfflineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDENTIFIER];
    }
    cell.requestCache = [_datas objectAtIndex:indexPath.row];
    if (_datas.count == 1) {
        cell.style = SINGLE;
    }else{
        if(indexPath.row == 0){
            cell.style = TOP;
        }else if(indexPath.row < _datas.count-1){
            cell.style = MID;
        }else {
            cell.style = BOT;
        }
    }
    return cell;
}

@end
