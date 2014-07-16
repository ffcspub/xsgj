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

@protocol SelectInfoCellDelegate;

@interface SelectInfoCell : UITableViewCell{
    UIButton *btn_last;
    UIButton *btn_firstSelected;
    UIButton *btn_secondSelected;
    UIButton *btn_sure;
    UIView *line1;
    UIView *line2;
    UIImageView *breakLine1;
    UIImageView *breakLine2;
}

@property(nonatomic,strong) NSString *firstSelected;
@property(nonatomic,strong) NSString *secondSelected;
@property(nonatomic,strong) NSObject *currentObject;

@property(nonatomic,assign) id<SelectInfoCellDelegate> delegate;

+(CGFloat)height;

@end

@protocol SelectInfoCellDelegate <NSObject>

-(void)lastAction:(SelectInfoCell *)cell;
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
        btn_firstSelected = [[UIButton alloc]initWithFrame:CGRectMake(62, 0, 72, 44)];
        [btn_firstSelected addTarget:self action:@selector(lastChooseAction) forControlEvents:UIControlEventTouchUpInside];
        line1 = [[UIView alloc]initWithFrame:CGRectMake(56, 0, 1, 44)];
        line1.backgroundColor = [UIColor lightGrayColor];
        btn_secondSelected = [[UIButton alloc]initWithFrame:CGRectMake(142, 0, 72, 44)];
        breakLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(126, 0, 40, 44)];
        breakLine1.image = [UIImage imageNamed:@"file_path_icon"];
        breakLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(207, 0, 72, 44)];
        breakLine2.image = [UIImage imageNamed:@"file_path_icon"];
        line2 = [[UIView alloc]initWithFrame:CGRectMake(260, 0, 1, 44)];
        line2.backgroundColor = [UIColor lightGrayColor];
        btn_sure = [[UIButton alloc]initWithFrame:CGRectMake(260, 0, 60, 44)];
        [btn_sure setImage:[UIImage imageNamed:@"icon_done"] forState:UIControlStateNormal];
        [btn_sure addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn_last];
        [self.contentView addSubview:line1];
        [self.contentView addSubview:btn_firstSelected];
        [self.contentView addSubview:breakLine1];
        [self.contentView addSubview:btn_secondSelected];
        [self.contentView addSubview:breakLine2];
        [self.contentView addSubview:line2];
        [self.contentView addSubview:btn_sure];
    }
    return self;
}


-(void)setFirstSelected:(NSString *)firstSelected{
    _firstSelected = firstSelected;
    [btn_firstSelected setTitle:firstSelected forState:UIControlStateNormal];
    if (!_firstSelected) {
        breakLine1.hidden = YES;
        btn_firstSelected.hidden = YES;
    }else{
        breakLine1.hidden = NO;
        btn_firstSelected.hidden = NO;
    }
}

-(void)setSecondSelected:(NSString *)secondSelected{
    _secondSelected = secondSelected;
    [btn_secondSelected setTitle:secondSelected forState:UIControlStateNormal];
    if (_secondSelected == nil) {
        breakLine2.hidden = YES;
        btn_secondSelected.hidden = YES;
    }else{
        breakLine2.hidden = NO;
        btn_secondSelected.hidden = NO;
    }
}


#pragma mark - Action

-(void)lastChooseAction{
    if (_delegate) {
        [_delegate lastAction:self];
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
        [btn_select setImage:[UIImage imageNamed:@"checkbox_unselected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateHighlighted];
        [btn_select addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn_select];
        lb_name = [[UILabel alloc]initWithFrame:CGRectMake(56, 0, 200, 44)];
        lb_name.font = [UIFont systemFontOfSize:17];
        lb_name.backgroundColor = [UIColor clearColor];
        lb_name.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:lb_name];
        iv_next = [[UIImageView alloc]initWithFrame:CGRectMake(280, 0, 30, 44)];
        iv_next.image = [UIImage imageNamed:@"tableCtrlBtnIcon_next-press.png"];
        iv_next.hidden = YES;
        [self.contentView addSubview:iv_next];
        
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
    if (_isSelected) {
        [btn_select setImage:[UIImage imageNamed:@"checkbox_unselected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateHighlighted];
    }else{
        [btn_select setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"checkbox_unselected"] forState:UIControlStateHighlighted];
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
        [btn_select setImage:[UIImage imageNamed:@"checkbox_unselected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateHighlighted];
        [btn_select addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn_select];
        lb_name = [[UILabel alloc]initWithFrame:CGRectMake(56, 0, 200, 44)];
        lb_name.font = [UIFont systemFontOfSize:17];
        lb_name.backgroundColor = [UIColor clearColor];
        lb_name.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:lb_name];
        iv_next = [[UIImageView alloc]initWithFrame:CGRectMake(280, 0, 30, 44)];
        iv_next.image = [UIImage imageNamed:@"tableCtrlBtnIcon_next-press.png"];
        iv_next.hidden = YES;
        [self.contentView addSubview:iv_next];
        
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
    if (_isSelected) {
        [btn_select setImage:[UIImage imageNamed:@"checkbox_unselected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateHighlighted];
    }else{
        [btn_select setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
        [btn_select setImage:[UIImage imageNamed:@"checkbox_unselected"] forState:UIControlStateHighlighted];
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
@property(nonatomic,strong) BNCustomerInfo *customerInfo;
@property(nonatomic,assign) BOOL isSelected;

+(CGFloat)height;

@end


@implementation CustomerSelectCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        lb_name = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 260, 25)];
        lb_name.font = [UIFont systemFontOfSize:15];
        lb_name.backgroundColor = [UIColor clearColor];
        lb_name.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:lb_name];
        lb_address = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 260, 20)];
        lb_address.font = [UIFont systemFontOfSize:12];
        lb_address.textColor = [UIColor clearColor];
        lb_address.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lb_address];
        iv_select = [[UIImageView alloc]initWithFrame:CGRectMake(265, 0, 55, 55)];
        iv_select.image = [UIImage imageNamed:@"btn_check_off"];
        [self.contentView addSubview:iv_select];
    }
    return self;
}

-(void)setCustomerInfo:(BNCustomerInfo *)customerInfo{
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

+(CGFloat)height{
    return 55.0;
}

@end


@interface CustomerChooseViewController (){
    UITableView *_tv_customerType;
    UITableView *_tv_area;
    
    NSMutableArray *_allCustomers;
    NSMutableArray *_showingCustomers;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabelViewDelegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
	} else {
//        return [_listContent count];
    }
    return 1;
}

@end
