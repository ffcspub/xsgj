//
//  LeaveInfoViewController.m
//  xsgj
//
//  Created by Geory on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "LeaveInfoViewController.h"

typedef  enum : NSUInteger {
    TOP = 0,
    MID = 1,
    BOT = 2,
} LeaveInfoCellStyle;

@interface LeaveInfoCell : UITableViewCell{
    UIImageView *_backView;
    UIImageView *_backSelectedView;
    UILabel *_lb_name;
    UILabel *_lb_value;
}

@property(nonatomic,assign) LeaveInfoCellStyle style;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *value;

+(CGFloat)height;

@end

@implementation LeaveInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, [LeaveInfoCell height])];
        _backSelectedView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, [LeaveInfoCell height])];
        _lb_name = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, [LeaveInfoCell height])];
        _lb_name.backgroundColor = [UIColor clearColor];
        _lb_name.font = [UIFont systemFontOfSize:17];
        _lb_name.textColor = HEX_RGB(0x939fa7);
        _lb_value = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 200,[LeaveInfoCell height])];
        _lb_value.textColor = HEX_RGB(0x000000);
        _lb_value.font = [UIFont systemFontOfSize:17];
        self.backgroundView = _backView;
        self.selectedBackgroundView = _backSelectedView;
        [self.contentView addSubview:_lb_name];
        [self.contentView addSubview:_lb_value];
    }
    return self;
}

+(CGFloat)height{
    return 44.0;
}

-(void)setStyle:(LeaveInfoCellStyle)style{
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
            _backView.image = [ShareValue tablePart3];
            _backSelectedView.image = [ShareValue tablePart3S];
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

-(void)setValue:(NSString *)value{
    _value = value;
    _lb_value.text = value;
}

-(void)setState:(int)state
{
    switch (state) {
        case 0:
            _lb_value.textColor = HEX_RGB(0x3cadde);
            _lb_value.text = @"待审";
            break;
        case 1:
            _lb_value.textColor = HEX_RGB(0x5fdd74);
            _lb_value.text = @"通过";
            break;
        case 2:
            _lb_value.textColor = HEX_RGB(0xff9b10);
            _lb_value.text = @"驳回";
            break;
        default:
            break;
    }
}

@end

@interface LeaveCommentCell : UITableViewCell{
    UIImageView *backView;
    UITextView *textView;
}

@property(nonatomic,strong) NSString *content;
+(CGFloat)height;

@end

@implementation LeaveCommentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, [LeaveCommentCell height])];
        UIImage *image = [UIImage imageNamed:@"bgNo2"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        backView.image = image;
        textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, 290, [LeaveCommentCell height])];
        textView.textColor = HEX_RGB(0x000000);
        textView.font = [UIFont systemFontOfSize:17];
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = NO;
        textView.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:backView];
        [self.contentView addSubview:textView];
    }
    return self;
}
+(CGFloat)height{
    return 100.0;
}

-(void)setContent:(NSString *)content{
    _content = content;
    textView.text = content;
}

@end

@interface LeaveInfoViewController ()

@end

@implementation LeaveInfoViewController

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
    
    self.title = @"请假详情";
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 7;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"LEAVEINFOCELL";
        LeaveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[LeaveInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        switch (indexPath.row) {
            case 0:{
                cell.name = @"主题";
                cell.value = _leaveInfo.TITLE;
                cell.style = TOP;
            }
                break;
            case 1:{
                cell.name = @"请假天数";
                cell.value = [NSString stringWithFormat:@"%@天",_leaveInfo.LEAVE_DAYS];
                cell.style = MID;
            }
                break;
            case 2:{
                cell.name = @"起始时间";
                cell.value = _leaveInfo.BEGIN_TIME;
                cell.style = MID;
            }
                break;
            case 3:{
                cell.name = @"结束时间";
                cell.value = _leaveInfo.END_TIME;
                cell.style = MID;
            }
                break;
            case 4:{
                cell.name = @"请假类型";
                cell.value = _leaveInfo.TYPE_NAME;
                cell.style = MID;
            }
                break;
            case 5:{
                cell.name = @"审批人";
                cell.value = [ShareValue shareInstance].userInfo.LEADER_NAME;
                cell.style = MID;
            }
                break;
            case 6:{
                cell.name = @"审批状态";
                [cell setState:_leaveInfo.APPROVE_STATE];
//                switch (_leaveInfo.APPROVE_STATE) {
//                    case 0:
//                        cell.value = @"未审批";
//                        break;
//                    case 1:
//                        cell.value = @"已通过";
//                        break;
//                    case 2:
//                        cell.value = @"未通过";
//                        break;
//                    default:
//                        break;
//                }
                cell.style = BOT;
            }
            default:
                break;
        }
        return cell;
    }else{
        static NSString *cellIdentifier = @"LeaveCommentCell";
        LeaveCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[LeaveCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 1) {
            cell.content = _leaveInfo.REMARK;
        } else if (indexPath.section == 2) {
            cell.content = _leaveInfo.APPROVE_REMARK;
        }
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [LeaveInfoCell height];
    }
    return [LeaveCommentCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0;
    }
    return 35.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(5, 14, 200, 20)];
    lable.textColor = HEX_RGB(0x939fa7);
    if (section == 1) {
        lable.text = @"请假详细描述";
    } else {
        lable.text = @"审批意见";
    }
    lable.font = [UIFont systemFontOfSize:17];
    lable.backgroundColor = [UIColor clearColor];
    [view addSubview:lable];
    return view;
}

@end
