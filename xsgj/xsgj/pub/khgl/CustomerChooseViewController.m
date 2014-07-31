//
//  CustomerChooseViewController.m
//  xsgj
//
//  Created by mac on 14-7-16.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "CustomerChooseViewController.h"
#import "BNCustomerInfo.h"
#import "BNCustomerType.h"
#import "BNAreaInfo.h"
#import <LKDBHelper.h>
#import "OAChineseToPinyin.h"
#import "KHGLAPI.h"
#import "KHGLHttpRequest.h"
#import "KHGLHttpResponse.h"
#import <MBProgressHUD.h>
#import "UIColor+External.h"

@protocol SelectInfoCellDelegate;

@interface SelectInfoCell : UITableViewCell{
    UIButton *btn_last;
    UIScrollView *sv_tab;
    UIButton *btn_sure;
    UIView *line1;
    UIView *line2;
}

@property(nonatomic,strong) NSObject *currentObject;
@property(nonatomic,assign) id<SelectInfoCellDelegate> delegate;

+(CGFloat)height;

@end

@protocol SelectInfoCellDelegate <NSObject>

-(void)lastAction:(SelectInfoCell *)cell selecteId:(int)selecteId;
-(void)sureAction:(SelectInfoCell *)cell;

@end

@implementation SelectInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        btn_last = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 44)];
        [btn_last addTarget:self action:@selector(lastChooseAction) forControlEvents:UIControlEventTouchUpInside];
        [btn_last setImage:[UIImage imageNamed:@"action_bar_back"] forState:UIControlStateNormal];
        sv_tab = [[UIScrollView alloc]initWithFrame:CGRectMake(57, 0, 260, 44)];
        line1 = [[UIView alloc]initWithFrame:CGRectMake(56, 0, 1, 44)];
        line1.backgroundColor = HEX_RGB(0xe7e7e7);
        line2 = [[UIView alloc]initWithFrame:CGRectMake(260, 0, 1, 44)];
        line2.backgroundColor = HEX_RGB(0xe7e7e7);
        btn_sure = [[UIButton alloc]initWithFrame:CGRectMake(260, 0, 60, 44)];
        [btn_sure setImage:[UIImage imageNamed:@"icon_done"] forState:UIControlStateNormal];
        [btn_sure addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn_last];
        [self.contentView addSubview:line1];
        [self.contentView addSubview:sv_tab];
        [self.contentView addSubview:line2];
        [self.contentView addSubview:btn_sure];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)selectObject:(UIButton *)btn{
    if (_delegate) {
        if (btn.tag > -1) {
            [_delegate lastAction:self selecteId:btn.tag];
        }
        
    }
}


-(void)setCurrentObject:(NSObject *)currentObject{
    _currentObject = currentObject;
    for (UIView *view in sv_tab.subviews) {
        [view removeFromSuperview];
    }
    sv_tab.contentSize = sv_tab.frame.size;
    if ([currentObject isKindOfClass:[BNAreaInfo class]]) {
        int beginX = 5;
        BNAreaInfo *area = (BNAreaInfo *)currentObject;
        NSArray *array = [area getFamilySequence];
        NSEnumerator *enumerator =  array.reverseObjectEnumerator;
        BNAreaInfo *info;
        NSMutableArray *reverseArray = [NSMutableArray array];
        while ((info = enumerator.nextObject)) {
            [reverseArray addObject:info];
        }
        int i = 0;
        for (BNAreaInfo *info in reverseArray) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(beginX, 0, 70, 44)];
            [btn setTitleColor:MCOLOR_BLACK forState:UIControlStateNormal];
            [btn setTitle:info.AREA_NAME forState:UIControlStateNormal];
            BNAreaInfo *nextArea;
            if (i < reverseArray.count - 1) {
                nextArea = [reverseArray objectAtIndex:i+1];
                btn.tag = nextArea.AREA_ID;
            }else{
                btn.tag = -1;
            }
            
            [sv_tab addSubview:btn];
            [btn addTarget:self action:@selector(selectObject:) forControlEvents:UIControlEventTouchUpInside];
            beginX += 70;
//            if (i < array.count-1) {
                UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"file_path_icon"]];
                imageView.frame = CGRectMake(beginX, 0, 20, 44);
                [sv_tab addSubview:imageView];
                beginX += 20;
//            }
            i++;
        }
        CGSize size = sv_tab.frame.size;
        size.width = beginX + 5;
        sv_tab.contentSize = size;
    }else if([currentObject isKindOfClass:[BNCustomerType class]]){
        int beginX = 5;
        BNCustomerType *type = (BNCustomerType *)currentObject;
        NSArray *array = [type getFamilySequence];
        NSEnumerator *enumerator =  array.reverseObjectEnumerator;
        BNAreaInfo *info;
        NSMutableArray *reverseArray = [NSMutableArray array];
        while ((info = enumerator.nextObject)) {
            [reverseArray addObject:info];
        }
        int i = 0;
        for (BNCustomerType *info in reverseArray) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(beginX, 0, 70, 44)];
            [btn setTitleColor:MCOLOR_BLACK forState:UIControlStateNormal];
            [btn setTitle:info.TYPE_NAME forState:UIControlStateNormal];
            BNCustomerType *nextType;
            if (i < reverseArray.count - 1) {
                nextType = [reverseArray objectAtIndex:i+1];
                btn.tag = nextType.TYPE_ID;
            }else{
                btn.tag = -1;
            }
            
            [sv_tab addSubview:btn];
            [btn addTarget:self action:@selector(selectObject:) forControlEvents:UIControlEventTouchUpInside];
            beginX += 70;
            //            if (i < array.count-1) {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"file_path_icon"]];
            imageView.frame = CGRectMake(beginX, 0, 20, 44);
            [sv_tab addSubview:imageView];
            beginX += 20;
            //            }
            i++;
        }
        CGSize size = sv_tab.frame.size;
        size.width = beginX + 5;
        sv_tab.contentSize = size;
    }
}



#pragma mark - Action

-(void)lastChooseAction{
    if (_delegate) {
        if ([_currentObject isKindOfClass:[BNAreaInfo class]]) {
            BNAreaInfo *area = (BNAreaInfo *)_currentObject;
            [_delegate lastAction:self selecteId:area.AREA_ID];
        }else if([_currentObject isKindOfClass:[BNCustomerType class]]){
            BNCustomerType *type = (BNCustomerType *)_currentObject;
            [_delegate lastAction:self selecteId:type.TYPE_ID];
        }
    }
}

-(void)sureAction{
    if (_delegate) {
        [_delegate sureAction:self];
    }
}

+(CGFloat)height{
    return 44.0;
}

@end

@protocol TypeSelectCellDelegate;

@interface TypeSelectCell : UITableViewCell{
    UIButton *btn_select;
    UILabel *lb_name;
    UIImageView *iv_next;
    UIView *line;
}

@property(nonatomic,strong) BNCustomerType *type;
@property(nonatomic,assign) BOOL hasNext;
@property(nonatomic,assign) BOOL isSelected;

@property(nonatomic,assign) id<TypeSelectCellDelegate> delegate;

+(CGFloat)height;

@end

@protocol TypeSelectCellDelegate <NSObject>

@required
-(void)selectedTypeSelectCell:(TypeSelectCell *)cell;

@end

@implementation TypeSelectCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        btn_select = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 43)];
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateHighlighted];
        [btn_select addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn_select];
        lb_name = [[UILabel alloc]initWithFrame:CGRectMake(56, 0, 200, 44)];
        lb_name.font = [UIFont systemFontOfSize:17];
        lb_name.backgroundColor = [UIColor clearColor];
        lb_name.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:lb_name];
        iv_next = [[UIImageView alloc]initWithFrame:CGRectMake(280, 0, 30, 44)];
        iv_next.contentMode = UIViewContentModeCenter;
        iv_next.image = [UIImage imageNamed:@"tableCtrlBtnIcon_next_nor"];
        iv_next.hidden = YES;
        [self.contentView addSubview:iv_next];
        line = [[UIView alloc]initWithFrame:CGRectMake(0, [TypeSelectCell height] - 1, self.frame.size.width, 1)];
        line.backgroundColor = HEX_RGB(0xe7e7e7);
        [self.contentView addSubview:line];
    }
    return self;
}

-(void)selectAction{
    if (_delegate) {
        [_delegate selectedTypeSelectCell:self];
    }
}

-(void)setHasNext:(BOOL)hasNext{
    _hasNext = hasNext;
    if (_hasNext) {
        iv_next.hidden = NO;
    }else{
        iv_next.hidden = YES;
    }
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (!_isSelected) {
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateHighlighted];
    }else{
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateHighlighted];
    }
}

-(void)setType:(BNCustomerType *)type{
    _type = type;
    lb_name.text = type.TYPE_NAME;
}

+(CGFloat)height{
    return 44.0;
}


@end


@protocol AreaSelectCellDelegate;

@interface AreaSelectCell : UITableViewCell{
    UIButton *btn_select;
    UILabel *lb_name;
    UIImageView *iv_next;
    UIView *line;
}

@property(nonatomic,strong) BNAreaInfo *area;
@property(nonatomic,assign) BOOL hasNext;
@property(nonatomic,assign) BOOL isSelected;

+(CGFloat)height;

@property(nonatomic,assign) id<AreaSelectCellDelegate> delegate;

@end

@protocol AreaSelectCellDelegate <NSObject>

@required
-(void)selectedAreaSelectCell:(AreaSelectCell *)cell;

@end


@implementation AreaSelectCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        btn_select = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 43)];
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateHighlighted];
        [btn_select addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn_select];
        lb_name = [[UILabel alloc]initWithFrame:CGRectMake(56, 0, 200, 44)];
        lb_name.font = [UIFont systemFontOfSize:17];
        lb_name.backgroundColor = [UIColor clearColor];
        lb_name.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:lb_name];
        iv_next = [[UIImageView alloc]initWithFrame:CGRectMake(280, 0, 30, 44)];
        iv_next.contentMode = UIViewContentModeCenter;
        iv_next.image = [UIImage imageNamed:@"tableCtrlBtnIcon_next_nor"];
        iv_next.hidden = YES;
        [self.contentView addSubview:iv_next];
        line = [[UIView alloc]initWithFrame:CGRectMake(0, [TypeSelectCell height] - 1, self.frame.size.width, 1)];
        line.backgroundColor = HEX_RGB(0xe7e7e7);
        [self.contentView addSubview:line];
    }
    return self;
}

-(void)selectAction{
    if (_delegate) {
        [_delegate selectedAreaSelectCell:self];
    }
}

-(void)setHasNext:(BOOL)hasNext{
    _hasNext = hasNext;
    if (_hasNext) {
        iv_next.hidden = NO;
    }else{
        iv_next.hidden = YES;
    }
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (!_isSelected) {
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateHighlighted];
    }else{
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_Selected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"CheckBox1_unSelected"] forState:UIControlStateHighlighted];
    }
}

-(void)setArea:(BNAreaInfo *)area{
    _area = area;
    lb_name.text = _area.AREA_NAME;
}

+(CGFloat)height{
    return 44.0;
}

@end



@interface CustomerSelectCell : UITableViewCell{
    UILabel *lb_name;
    UILabel *lb_address;
    UIImageView *iv_select;
}
@property(nonatomic,strong) CustomerInfo *customerInfo;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,assign) BOOL deSelected;

+(CGFloat)height;

@end


@implementation CustomerSelectCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setExclusiveTouch:YES];
        lb_name = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 260, 25)];
        lb_name.font = [UIFont systemFontOfSize:17];
        lb_name.backgroundColor = [UIColor clearColor];
        lb_name.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:lb_name];
        lb_address = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 260, 20)];
        lb_address.font = [UIFont systemFontOfSize:15];
        lb_address.textColor = [UIColor clearColor];
        lb_address.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lb_address];
        iv_select = [[UIImageView alloc]initWithFrame:CGRectMake(255, 0, 65, 55)];
        iv_select.contentMode = UIViewContentModeCenter;
        iv_select.image = [UIImage imageNamed:@"btn_check_off"];
        [self.contentView addSubview:iv_select];
    }
    return self;
}

-(void)setCustomerInfo:(CustomerInfo *)customerInfo{
    _customerInfo = customerInfo;
    lb_name.text = _customerInfo.CUST_NAME;
    lb_address.text = _customerInfo.ADDRESS;
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        iv_select.image = [UIImage imageNamed:@"btn_check_on"];
    }else{
        iv_select.image = [UIImage imageNamed:@"btn_check_off"];
    }
}

-(void)setDeSelected:(BOOL)deSelected{
    _deSelected = deSelected;
    if (_deSelected) {
        iv_select.image = [UIImage imageNamed:@"btn_check_deable"];
    }else{
        if (_isSelected) {
            iv_select.image = [UIImage imageNamed:@"btn_check_on"];
        }else{
            iv_select.image = [UIImage imageNamed:@"btn_check_off"];
        }
    }
    
}

+(CGFloat)height{
    return 55.0;
}

@end



@protocol CustomerTagViewDelegate;

@interface CustomerTagView : UIView{
    UILabel *lb_name;
    UIButton *btn_del;
    UIImageView *iv_del;
}

@property(nonatomic,assign) id<CustomerTagViewDelegate> delegate;

+(CGSize)sizeByCustomer:(CustomerInfo *)customer;

@property(nonatomic,strong) CustomerInfo *customer;

@end

@protocol CustomerTagViewDelegate <NSObject>

@required

-(void)customerTagViewOnDelete:(CustomerTagView *)customerTagView;

@end

@implementation CustomerTagView

+(CGSize)sizeByCustomer:(CustomerInfo *)customer{
    NSString *name = customer.CUST_NAME;
    CGSize size = [name sizeWithFont:[UIFont systemFontOfSize:16]];
    size.height = 35;
    size.width += 24;
    if (size.width < 70) {
        size.width = 70;
    }
    return size;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize size = frame.size;
        lb_name = [[UILabel alloc]init];
        lb_name.font = [UIFont systemFontOfSize:16];
        lb_name.textColor = [UIColor whiteColor];
        lb_name.backgroundColor = MCOLOR_GRAY;
        lb_name.layer.cornerRadius = 6;
        lb_name.frame = CGRectMake(0, 5, size.width, size.height-5);
        lb_name.textAlignment = UITextAlignmentCenter;
        btn_del = [[UIButton alloc]init];
        btn_del.frame = CGRectMake(0,0,size.width,size.height);
        [btn_del addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        iv_del = [[UIImageView alloc]init];
        iv_del.frame = CGRectMake(size.width-12, 0, 18, 18);
        iv_del.image = [UIImage imageNamed:@"del_btn_normal"];
        [self addSubview:lb_name];
        [self addSubview:btn_del];
        [self addSubview:iv_del];
    }
    return self;
}

-(void)deleteAction{
    if (_delegate) {
        [_delegate customerTagViewOnDelete:self];
    }
}


-(void)setCustomer:(CustomerInfo *)customer{
    _customer = customer;
    lb_name.text = _customer.CUST_NAME;
}

@end

@interface CustomerChooseViewController ()<UITableViewDataSource,UITableViewDelegate,CustomerTagViewDelegate,SelectInfoCellDelegate,CustomerChooseDelegate,TypeSelectCellDelegate>{
    UITableView *_tv_customerType;
    UITableView *_tv_area;
    
    NSMutableArray *_allCustomers;
    NSMutableArray *_showingCustomersArrays;
    NSMutableArray *_filterCustomers;
    
    NSMutableArray *_selectedCustomers;
    
    NSMutableArray *_customerTypeArray;
    NSMutableArray *_areaArray;
    
    int AREA_PID;
    int TYPE_PID;
    
    BNAreaInfo *_selectedAreaInfo;
    BNCustomerType *_selectedCustomerType;
    
    NSString *_firstAreaName;
    NSString *_secondAreaName;
    
    NSString *_firstTypeName;
    NSString *_secondTypeName;
}

@end

@implementation CustomerChooseViewController

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
    self.title = @"选择客户";
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_OR_LATER) {
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    if (IOS6_OR_LATER) {
        _tableView.sectionIndexColor = [UIColor darkGrayColor];
    }
#endif
    _showingCustomersArrays = [[NSMutableArray alloc]init];
    _allCustomers = [[NSMutableArray alloc]init];
    _filterCustomers = [[NSMutableArray alloc]init];
    _selectedCustomers = [[NSMutableArray alloc]init];
    CGRect rect = _tableView.frame;
    rect.origin.y -= _sb_search.frame.size.height;
    rect.size.height += _sb_search.frame.size.height;
    _tv_customerType = [[UITableView alloc]initWithFrame:rect];
    _tv_customerType.backgroundColor = RGBA(0, 0, 0, 0.5);
    _tv_customerType.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tv_area = [[UITableView alloc]initWithFrame:rect];
    _tv_area.backgroundColor = RGBA(0, 0, 0, 0.5);
    _tv_area.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tv_customerType.hidden = YES;
    _tv_area.hidden = YES;
    _tv_area.delegate = self;
    _tv_area.dataSource = self;
    _tv_customerType.delegate = self;
    _tv_customerType.dataSource = self;
    [_btn_sure configBlueStyle];
    [self.view addSubview:_tv_area];
    [self.view addSubview:_tv_customerType];
    [_btn_type addTarget:self action:@selector(typeChooseAction) forControlEvents:UIControlEventTouchUpInside];
    [_btn_area addTarget:self action:@selector(areaChooseAction) forControlEvents:UIControlEventTouchUpInside];
    [self loadCustomer];
    [self loadCustomerTypes];
    [self loadAreas];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - function

-(void)loadCustomerTypes{
    if (!_customerTypeArray) {
        _customerTypeArray = [NSMutableArray array];
    }
    [_customerTypeArray removeAllObjects];
    if (TYPE_PID == 0) {
        BNCustomerType *allType = [[BNCustomerType alloc]init];
        allType.TYPE_ID = -1;
        allType.TYPE_NAME = @"选择全部";
        allType.TYPE_PID = -1;
        [_customerTypeArray addObject:allType];
    }
    
    NSArray *result  = [BNCustomerType searchWithWhere:[NSString stringWithFormat:@"TYPE_PID=%d",TYPE_PID] orderBy:@"TYPE_NAME_PINYIN" offset:0 count:100];
    [_customerTypeArray addObjectsFromArray:result];
    [_tv_customerType reloadData];
}

-(void)loadAreas{
    if (!_areaArray) {
        _areaArray = [NSMutableArray array];
    }
    [_areaArray removeAllObjects];
    if (AREA_PID == 0) {
        BNAreaInfo *allArea = [[BNAreaInfo alloc]init];
        allArea.AREA_ID = -1;
        allArea.AREA_PID = -1;
        allArea.AREA_NAME = @"选择全部";
        [_areaArray addObject:allArea];
    }
    NSArray *temp = [BNAreaInfo searchWithWhere:[NSString stringWithFormat:@"AREA_PID=%d",AREA_PID] orderBy:@"ORDER_NO" offset:0 count:100];
    [_areaArray addObjectsFromArray:temp];
    [_tv_area reloadData];
}

-(void)typeChooseAction{
    if (_tv_area.hidden == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _tableView.frame;
            rect.size.height = 0;
            _tv_area.frame = rect;
        } completion:^(BOOL finished) {
            _tv_area.hidden = YES;
        }];
        return;
    }
    if (_tv_customerType.hidden == YES) {
        _tv_customerType.hidden = NO;
        CGRect rect = _tableView.frame;
        rect.size.height = 0;
        _tv_customerType.frame = rect;
        [UIView animateWithDuration:0.5 animations:^{
            _tv_customerType.frame = _tableView.frame;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _tableView.frame;
            rect.size.height = 0;
            _tv_customerType.frame = rect;
        } completion:^(BOOL finished) {
            _tv_customerType.hidden = YES;
        }];
    }
}

-(void)areaChooseAction{
    if (_tv_customerType.hidden == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _tableView.frame;
            rect.size.height = 0;
            _tv_customerType.frame = rect;
        } completion:^(BOOL finished) {
            _tv_customerType.hidden = YES;
        }];
        return;
    }
    
    if (_tv_area.hidden == YES) {
        _tv_area.hidden = NO;
        CGRect rect = _tableView.frame;
        rect.size.height = 0;
        _tv_area.frame = rect;
        [UIView animateWithDuration:0.5 animations:^{
            _tv_area.frame = _tableView.frame;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _tableView.frame;
            rect.size.height = 0;
            _tv_area.frame = rect;
        } completion:^(BOOL finished) {
            _tv_area.hidden = YES;
        }];
    }
}

-(void)reloadScollerView{
    NSArray *array = [_sv_customers subviews];
    for (UIView *view in array) {
        [view removeFromSuperview];
    }
    _sv_customers.contentSize = CGSizeMake(_sv_customers.frame.size.width, _sv_customers.frame.size.height);
    CGFloat beginX = 10;
    for (CustomerInfo *customer in _selectedCustomers) {
        CGSize size = [CustomerTagView sizeByCustomer:customer];
        CustomerTagView *tagView = [[CustomerTagView alloc]initWithFrame:CGRectMake(beginX, (_sv_customers.frame.size.height - size.height) /2, size.width, size.height)];
        beginX += (size.width + 10);
        tagView.customer = customer;
        tagView.delegate = self;
        [_sv_customers addSubview:tagView];
    }
    _sv_customers.contentSize = CGSizeMake(beginX, _sv_customers.frame.size.height);
    [_btn_sure setTitle:[NSString stringWithFormat:@"确定(%d)",_selectedCustomers.count] forState:UIControlStateNormal];
}

-(void)filterCustomer:(NSString *)searchText{
    [_filterCustomers removeAllObjects];
    if (searchText.length == 0) {
        [_filterCustomers addObjectsFromArray:_allCustomers];
        [self searchCustomer];
        return;
    }
    int length = [searchText length];
    BOOL isHZ = NO;
    for (int i=0; i<length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [searchText substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            isHZ = YES;
        }
    }
    for (BNCustomerInfo *info in _allCustomers) {
        if (isHZ){
            NSComparisonResult result = [info.CUST_NAME compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
                [_filterCustomers addObject:info];
            }
        }else{
            NSString *pinyin = [OAChineseToPinyin pinyinFromChiniseString:info.CUST_NAME];
            NSComparisonResult result = [pinyin compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
                [_filterCustomers addObject:info];
            }        }
    }
    [self searchCustomer];
}

-(void)loadCustomer{
    [_allCustomers removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *sql = @"";
    if (_selectedCustomerType) {
        sql = [sql stringByAppendingFormat:@"TYPE_ID=%d",_selectedCustomerType.TYPE_ID];
    }
    if (_selectedAreaInfo) {
        if (sql.length > 0) {
            sql = [sql stringByAppendingFormat:@" and "];
        }
        sql = [sql stringByAppendingFormat:@"AREA_ID=%d",_selectedAreaInfo.AREA_ID];
    }
    if (_deselectedCutomerIds.count>0) {
       NSString *ids =   [_deselectedCutomerIds componentsJoinedByString:@","];
        if (sql.length > 0) {
            sql = [sql stringByAppendingFormat:@" and "];
        }
        sql = [sql stringByAppendingFormat:@"CUST_ID not in (%@)",ids];
    }
    NSArray *costomers = [BNCustomerInfo searchWithWhere:sql orderBy:@"CUST_NAME" offset:0 count:1000];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [_allCustomers addObjectsFromArray:costomers];
    [self filterCustomer:_sb_search.text];
}

- (BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}

-(void)searchCustomer{
    NSString *sectionName;
    [_showingCustomersArrays removeAllObjects];
    for (int i = 0; i < 27; i++) [_showingCustomersArrays addObject:[NSMutableArray array]];
    for (CustomerInfo  *customerInfo in _filterCustomers)
    {
        if([self searchResult:customerInfo.CUST_NAME searchText:@"曾"])
            sectionName = @"Z";
        else if([self searchResult:customerInfo.CUST_NAME searchText:@"解"])
            sectionName = @"X";
        else if([self searchResult:customerInfo.CUST_NAME searchText:@"仇"])
            sectionName = @"Q";
        else if([self searchResult:customerInfo.CUST_NAME searchText:@"朴"])
            sectionName = @"P";
        else if([self searchResult:customerInfo.CUST_NAME searchText:@"查"])
            sectionName = @"Z";
        else if([self searchResult:customerInfo.CUST_NAME searchText:@"能"])
            sectionName = @"N";
        else if([self searchResult:customerInfo.CUST_NAME searchText:@"乐"])
            sectionName = @"Y";
        else if([self searchResult:customerInfo.CUST_NAME searchText:@"单"])
            sectionName = @"S";
        else
            sectionName = [NSString stringWithFormat:@"%c",[OAChineseToPinyin sortSectionTitle:customerInfo.CUST_NAME]];
        //        [self.contactNameDic setObject:string forKey:sectionName];
        NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
        if (firstLetter != NSNotFound) [[_showingCustomersArrays objectAtIndex:firstLetter] addObject:customerInfo];
    }
    [_tableView reloadData];
}


#pragma mark - UITableViewDelegate


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == _tableView)
    {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
    else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(tableView == _tableView)
    {
        if (title == UITableViewIndexSearch)
        {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        }
        return [ALPHA rangeOfString:title].location;
    }
    else
        return -1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == _tableView)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)];
        view.backgroundColor = HEX_RGBA(0xd7d7d7, 1);
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, view.frame.size.width - 20 * 2, 16)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor darkGrayColor];
        title.text = [[_showingCustomersArrays objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
        [view addSubview:title];
        return view;
    }
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _tableView)
        return [[_showingCustomersArrays objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
    else
        return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        return [CustomerSelectCell height];
    }else if(tableView == _tv_area){
        if (indexPath.section == 0) {
            return [AreaSelectCell height];
        }else{
            return [SelectInfoCell height];
        }
        
    }else{
        if (indexPath.section == 0) {
            return [TypeSelectCell height];
        }else{
            return [SelectInfoCell height];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _tableView)
        return [_showingCustomersArrays count];
    else
        return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _tableView)
        return [[_showingCustomersArrays objectAtIndex:section] count];
    if (tableView == _tv_customerType) {
        if (section == 0) {
            return [_customerTypeArray count];
        }
        return 1;
    }
    if (tableView == _tv_area) {
        if (section == 0) {
            return [_areaArray count];
        }
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        static NSString *cellIdentifier = @"CUSTOMECELL";
        CustomerSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[CustomerSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *array = [_showingCustomersArrays objectAtIndex:indexPath.section];
        CustomerInfo *customer = [array objectAtIndex:indexPath.row];
        cell.customerInfo = customer;
        
        if ([_deselectedCutomerIds containsObject:[NSNumber numberWithInt:customer.CUST_ID]]) {
            cell.deSelected = YES;
        }else{
            cell.deSelected = NO;
            if ([_selectedCustomers containsObject:customer]) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
        }
        
        return cell;
    }
    if (tableView == _tv_customerType) {
        if (indexPath.section == 0) {
            static NSString *cellIdentifier = @"CUTOMERTYPECELL";
            TypeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[TypeSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            BNCustomerType *type = [_customerTypeArray objectAtIndex:indexPath.row];
            int count = [BNCustomerType rowCountWithWhere:[NSString stringWithFormat:@"TYPE_PID=%d",type.TYPE_ID]];
            if (count > 0) {
                cell.hasNext = YES;
            }else{
                cell.hasNext = NO;
            }
            if (_selectedCustomerType!=nil && _selectedCustomerType == type) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
            cell.type = type;
            return cell;
        }else{
            static NSString *cellIdentifier = @"CHOOSECELL";
            BNCustomerType *type = [_customerTypeArray objectAtIndex:indexPath.row];
            SelectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[SelectInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            BNCustomerType *parent = [BNCustomerType searchSingleWithWhere:[NSString stringWithFormat:@"TYPE_ID=%d",type.TYPE_PID ] orderBy:nil];
            cell.currentObject = parent;
            return cell;
        }
    }
    if (tableView == _tv_area) {
        if (indexPath.section == 0) {
            static NSString *cellIdentifier = @"AREACELL";
            AreaSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[AreaSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            BNAreaInfo *area = [_areaArray objectAtIndex:indexPath.row];
            int count = [BNAreaInfo rowCountWithWhere:[NSString stringWithFormat:@"AREA_PID=%d",area.AREA_ID]];
            if (count > 0) {
                cell.hasNext = YES;
            }else{
                cell.hasNext = NO;
            }
            if (_selectedAreaInfo!=nil && _selectedAreaInfo == area) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
            cell.area = area;
            return cell;
        }else{
            static NSString *cellIdentifier = @"CHOOSECELL";
            SelectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            BNAreaInfo *area = [_areaArray objectAtIndex:0];
            if (!cell) {
                cell = [[SelectInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            BNAreaInfo *parent = [BNAreaInfo searchSingleWithWhere:[NSString stringWithFormat:@"AREA_ID=%d",area.AREA_PID ] orderBy:nil];
            cell.currentObject = parent;
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        NSArray *array = [_showingCustomersArrays objectAtIndex:indexPath.section];
        CustomerInfo *customer = [array objectAtIndex:indexPath.row];
        if ([_deselectedCutomerIds containsObject:[NSNumber numberWithInt:customer.CUST_ID]]) {
            return;
        }
        if ([_selectedCustomers containsObject:customer]) {
            [_selectedCustomers removeObject:customer];
        }else{
            [_selectedCustomers addObject:customer];
        }
        [_tableView reloadData];
        [self reloadScollerView];
    }else if(tableView == _tv_area){
        if (indexPath.section == 0) {
            BNAreaInfo *area = [_areaArray objectAtIndex:indexPath.row];
            int count = [BNAreaInfo rowCountWithWhere:[NSString stringWithFormat:@"AREA_PID=%d",area.AREA_ID]];
            if (count > 0) {
                AREA_PID = area.AREA_ID;
                if (area.AREA_PID == 0) {
                    _firstAreaName = area.AREA_NAME;
                    _secondAreaName = nil;
                }else{
                    _secondAreaName = area.AREA_NAME;
                }
                [self loadAreas];
            }
            
        }
    }else if(tableView == _tv_customerType){
        if (indexPath.section == 0) {
            BNCustomerType *type = [_customerTypeArray objectAtIndex:indexPath.row];
            int count = [BNCustomerType rowCountWithWhere:[NSString stringWithFormat:@"TYPE_PID=%d",type.TYPE_ID]];
            if (count > 0) {
                TYPE_PID = type.TYPE_ID;
                if (type.TYPE_PID == 0) {
                    _firstTypeName = type.TYPE_NAME;
                    _secondTypeName = nil;
                }else{
                    _secondTypeName = type.TYPE_NAME;
                }
                [self loadCustomerTypes];
            }
        }
    }
    
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    [self filterCustomer:searchText];
    [_tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
	[self.searchDisplayController.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[_tableView reloadData];
}



#pragma mark -
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    
	    //const char *cString = [searchText UTF8String];
    [self filterCustomer:searchText];
    // 修改无结果的时候显示文字
    if(_filterCustomers.count < 1)
    {
        UITableView *tableview = self.searchDisplayController.searchResultsTableView;
        for(UIView *subView in tableview.subviews)
        {
            if([subView isKindOfClass:[UILabel class]])
            {
                UILabel *lb = (UILabel *)subView;
                lb.text = @"没有找到符合条件的信息";
                break;
                
            }
        }
        
        [tableview reloadData];
    }
    
}
//#pragma mark -
//#pragma mark UISearchDisplayControllerDelegate
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    if ([searchString isEqualToString:@""]) {
//        return NO;
//    }
//    
//    [self filterContentForSearchText:searchString scope:
//	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    
//    return YES;
//}
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
//	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    
//    return YES;
//}

- (IBAction)typeAction:(id)sender {
    
    
}

- (IBAction)areaAction:(id)sender {
    
}

#pragma mark -CustomerTagViewDelegate
-(void)customerTagViewOnDelete:(CustomerTagView *)customerTagView{
    [_selectedCustomers removeObject:customerTagView.customer];
    [_tableView reloadData];
    [self reloadScollerView];
}

#pragma mark - SelectInfoCellDelegate
-(void)lastAction:(SelectInfoCell *)cell selecteId:(int)selecteId;{
    if (_tv_customerType.hidden == NO) {
        if (TYPE_PID != 0) {
            BNCustomerType *type = [BNCustomerType searchSingleWithWhere:[NSString stringWithFormat:@"TYPE_ID=%d",selecteId] orderBy:nil];
            TYPE_PID = type.TYPE_PID;
            [self loadCustomerTypes];
        }
    }else{
        if (AREA_PID != 0) {
            BNAreaInfo *area = [BNAreaInfo searchSingleWithWhere:[NSString stringWithFormat:@"AREA_ID=%d",selecteId] orderBy:nil];
            AREA_PID = area.AREA_PID;
            [self loadAreas];
        }
    }
}

-(void)sureAction:(SelectInfoCell *)cell{
    if (_tv_area.hidden == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _tableView.frame;
            rect.size.height = 0;
            _tv_area.frame = rect;
        } completion:^(BOOL finished) {
            _tv_area.hidden = YES;
        }];
    }
    if (_tv_customerType.hidden == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _tableView.frame;
            rect.size.height = 0;
            _tv_customerType.frame = rect;
        } completion:^(BOOL finished) {
            _tv_customerType.hidden = YES;
        }];
    }
    if (!_selectedAreaInfo || _selectedAreaInfo.AREA_ID == -1) {
        [_btn_area setTitle:@"区域" forState:UIControlStateNormal];
    }else{
        [_btn_area setTitle:_selectedAreaInfo.AREA_NAME forState:UIControlStateNormal];
    }
    if (!_selectedCustomerType || _selectedCustomerType.TYPE_ID == -1) {
        [_btn_type setTitle:@"客户类型" forState:UIControlStateNormal];
    }else{
        [_btn_type setTitle:_selectedCustomerType.TYPE_NAME forState:UIControlStateNormal];
    }
    
    [self loadCustomer];
}

#pragma mark - AreaSelectCellDelegate
-(void)selectedAreaSelectCell:(AreaSelectCell *)cell{
    if (_selectedAreaInfo.AREA_ID == -1 || _selectedAreaInfo == cell.area) {
        _selectedAreaInfo = nil;
    }else{
        _selectedAreaInfo = cell.area;
    }
    [_tv_area reloadData];
}

#pragma mark - TypeSelectCellDelegate
-(void)selectedTypeSelectCell:(TypeSelectCell *)cell{
    if (_selectedCustomerType.TYPE_ID == -1 ||  _selectedCustomerType == cell.type ) {
        _selectedCustomerType = nil;
    }else{
        _selectedCustomerType = cell.type;
    }
    [_tv_customerType reloadData];
}

#pragma mark - Action
- (IBAction)sureBtnClick:(id)sender {
    if (_chooseDelegate) {
        [_chooseDelegate chooseCustomer:_selectedCustomers];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
