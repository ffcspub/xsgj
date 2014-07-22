//
//  PlanInfoViewController.m
//  xsgj
//
//  Created by ilikeido on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "PlanInfoViewController.h"

typedef  enum : NSUInteger {
    TOP = 0,
    MID = 1,
    BOT = 2,
} PlanInfoCellStyle;

@interface PlanInfoCell : UITableViewCell{
    UIImageView *_backView;
    UILabel *_lb_name;
    UILabel *_lb_value;
}

@property(nonatomic,assign) PlanInfoCellStyle style;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *value;

+(CGFloat)height;

@end

@implementation PlanInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, [PlanInfoCell height])];
        _lb_name = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, [PlanInfoCell height])];
        _lb_name.backgroundColor = [UIColor clearColor];
        _lb_name.font = [UIFont systemFontOfSize:16];
        _lb_name.textColor = [UIColor grayColor];
        _lb_value = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 200,[PlanInfoCell height])];
        _lb_name.textColor = [UIColor grayColor];
        _lb_name.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_backView];
        [self.contentView addSubview:_lb_name];
        [self.contentView addSubview:_lb_value];
    }
    return self;
}

+(CGFloat)height{
    return 44.0;
}

-(void)setStyle:(PlanInfoCellStyle)style{
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

-(void)setName:(NSString *)name{
    _name = name;
    _lb_name.text = name;
}

-(void)setValue:(NSString *)value{
    _value = value;
    _lb_value.text = value;
}

@end

@interface PlanCommentCell : UITableViewCell{
    UIImageView *backView;
    UITextView *textView;
}

@property(nonatomic,strong) NSString *content;
+(CGFloat)height;

@end

@implementation PlanCommentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        backView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, [PlanCommentCell height])];
//        backView.backgroundColor = [UIColor whiteColor];
//        backView.layer.borderColor = MCOLOR_GRAY.CGColor;
//        backView.layer.borderWidth = 1;
        UIImage *image = [UIImage imageNamed:@"table_border"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) ];
        backView.image = image;
        textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, 300, [PlanCommentCell height])];
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



@interface PlanInfoViewController ()

@end

@implementation PlanInfoViewController

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
    self.title = @"拜访规划详情";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_customerInfo.CHECK_STATE == 3) {
            return 4;
        }
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"PLANINFOCELL";
        PlanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[PlanInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        switch (indexPath.row) {
            case 0:{
                cell.name = @"客户名称";
                cell.value = _customerInfo.CUST_NAME;
                cell.style = TOP;
            }
                break;
            case 1:{
                cell.name = @"客户地址";
                cell.value = _customerInfo.ADDRESS;
                cell.style = MID;
            }
                break;
            case 2:{
                if (_customerInfo.CHECK_STATE == 3) {
                    cell.name = @"操作类型";
                    cell.value = [_customerInfo stateName];
                    cell.style = MID;
                }else{
                    cell.name = @"审批状态";
                    cell.value = [_customerInfo stateName];
                    cell.style = BOT;
                }
            }
                break;
            case 3:{
                    cell.name = @"审批状态";
                    cell.value = @"通过";
                    cell.style = BOT;
            }
                break;
   
            default:
                break;
        }
        return cell;
    }else{
        static NSString *cellIdentifier = @"PlanCommentCell";
        PlanCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[PlanCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.content = _customerInfo.CHECK_REMARK;
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [PlanInfoCell height];
    }
    return [PlanCommentCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0;
    }
    return 35.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 100, 20)];
    lable.textColor = [UIColor darkGrayColor];
    lable.text = @"审批意见";
    lable.backgroundColor = [UIColor clearColor];
    [view addSubview:lable];
    return view;
}


@end
