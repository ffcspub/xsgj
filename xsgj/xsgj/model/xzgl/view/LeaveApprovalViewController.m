//
//  LeaveApprovalViewController.m
//  xsgj
//
//  Created by Geory on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "LeaveApprovalViewController.h"
#import "UIColor+External.h"

typedef  enum : NSUInteger {
    TOP = 0,
    MID = 1,
    BOT = 2,
} LeaveApprovalCellStyle;

@interface LeaveApprovalCell : UITableViewCell{
    UIImageView *_backView;
    UILabel *_lb_name;
    UILabel *_lb_time;
}

@property(nonatomic,assign) LeaveApprovalCellStyle style;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *time;

+(CGFloat)height;

@end

@implementation LeaveApprovalCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, [LeaveApprovalCell height])];
        _lb_name = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 180, 28)];
        _lb_name.backgroundColor = [UIColor clearColor];
        _lb_name.font = [UIFont systemFontOfSize:17];
//        _lb_name.textColor = [UIColor grayColor];
        _lb_time = [[UILabel alloc]initWithFrame:CGRectMake(20, 31, 200,21)];
        _lb_time.textColor = HEX_RGB(0x939fa7);
        _lb_time.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_backView];
        [self.contentView addSubview:_lb_name];
        [self.contentView addSubview:_lb_time];
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
            UIImage *image = [UIImage imageNamed:@"table_part1"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5,5, 5) ];
            _backView.image = image;
        }
            break;
        case MID:{
            UIImage *image = [UIImage imageNamed:@"table_part2"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) ];
            _backView.image = image;
        }
            break;
        case BOT:{
            UIImage *image = [UIImage imageNamed:@"table_part3"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) ];
            _backView.image = image;
        }
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

@interface LeaveApprovalViewController ()

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
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"LEAVEAPPROVALCELL";
    LeaveApprovalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LeaveApprovalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.name = @"客户名称";
        cell.time = @"123";
        cell.style = TOP;
    } else if (indexPath.row == 4) {
        cell.name = @"审批状态";
        cell.time = @"789";
        cell.style = BOT;
    } else {
        cell.name = @"客户地址";
        cell.time = @"456";
        cell.style = MID;
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
}

@end
