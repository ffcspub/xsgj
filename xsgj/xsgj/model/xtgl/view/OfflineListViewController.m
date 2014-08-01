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

typedef  enum : NSUInteger {
    TOP = 0,
    MID = 1,
    BOT = 2,
} OfflineCellStyle;

@interface OfflineCell : UITableViewCell{
    UILabel *lb_name;
    UILabel *lb_time;
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
        lb_name = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 280, 22)];
        lb_time = [[UILabel alloc]initWithFrame:CGRectMake(10, 22, 280, 22)];
        lb_name.font = [UIFont systemFontOfSize:15];
        lb_time.font = [UIFont systemFontOfSize:12];
        lb_name.textColor = MCOLOR_BLUE;
        lb_time.textColor = MCOLOR_BLACK;
        [self addSubview:_backView];
        [self addSubview:lb_name];
        [self addSubview:lb_time];
    }
    return self;
}

-(void)setRequestCache:(OfflineRequestCache *)requestCache{
    _requestCache = requestCache;
    lb_name.text = _requestCache.name;
    lb_time.text = _requestCache.time;
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

-(void)updateSuccess:(NSNotification *)notification{
    [self loadDatas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDatas{
    _datas = [OfflineRequestCache searchWithWhere:nil orderBy:@"time desc" offset:0 count:1000];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [OfflineRequestCache rowCountWithWhere:nil];
    return count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELLIDENTIFIER = @"CELLIDENTIFIER";
    OfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    if (!cell) {
        cell = [[OfflineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDENTIFIER];
    }
    cell.requestCache = [_datas objectAtIndex:indexPath.row];
    if (_datas.count == 0) {
        cell.style = MID;
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
