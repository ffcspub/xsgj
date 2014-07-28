//
//  CorpAddressBookViewController.m
//  xsgj
//
//  Created by linw on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "CorpAddressBookViewController.h"
#import "XTGLAPI.h"
#import "XTGLHttpRequest.h"
#import "XTGLHttpResponse.h"
#import "ShareValue.h"
#import "DeptInfoBean.h"
#import "ContactBean.h"
#import "ContactTableViewCell.h"
#import "MBProgressHUD+Add.h"
#import "OAChineseToPinyin.h"
#import "NSObject+LKDBHelper.h"
#import "TreeViewCell.h"
#import "SelectTreeViewController.h"

@interface CorpAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
//    // A-Z段落列表
//    NSMutableArray *mSectionArray;
//    // 分段联系人-二维
//    NSMutableArray *mLocalSectionContact;
    // 原始部门数据
    NSArray        *arraySourceDept;
    // 选定的部门
    DeptInfoBean   *selectedDept;
    // 原始联系人数据
    NSArray        *arraySourceContact;
    // 联系人查询条件
    NSString       *sqlDeptId;
}
@end

@implementation CorpAddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        arraySourceDept      = [NSArray array];
        [DeptInfoBean deleteWithWhere:nil];
        [ContactBean deleteWithWhere:nil];
    }
    return self;
}

// 设置标题栏上的按钮
-(void)setTitleButtonStyle
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"部门选择▼" forState:UIControlStateNormal];
    [button setTitle:@"部门选择▼" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [button addTarget:self action:@selector(selectDept) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotifySelectFin:) name:NOTIFICATION_SELECT_FIN object:nil];
    // 标题按钮
    [self setTitleButtonStyle];
    // 部门信息获取
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GetUserAllDeptHttpRequest *deptRequest = [[GetUserAllDeptHttpRequest alloc]init];
    deptRequest.SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
    deptRequest.CORP_ID    = [ShareValue shareInstance].userInfo.CORP_ID;
    deptRequest.DEPT_ID    = [ShareValue shareInstance].userInfo.DEPT_ID;
    deptRequest.USER_AUTH  = [ShareValue shareInstance].userInfo.USER_AUTH;
    deptRequest.USER_ID    = [ShareValue shareInstance].userInfo.USER_ID;
    [XTGLAPI getUserALlDeptByRequest:deptRequest success:^(GetUserAllDeptHttpResponse *response)
    {
        if ([response.MESSAGE.MESSAGECODE isEqual:DEFINE_SUCCESSCODE])
        {
            NSArray *aryTemp = response.DATA;
            for (DeptInfoBean *bean in aryTemp)
            {
                [bean saveToDB];
            }
        }
        // 保存部门原始数据
        arraySourceDept = [DeptInfoBean searchWithWhere:nil orderBy:nil offset:0 count:1000];
    }
    fail:^(BOOL notReachable, NSString *desciption)
    {
        
    }];
    // 联系人信息
    QueryContactsHttpRequest *contactRequest = [[QueryContactsHttpRequest alloc]init];
    // 基本信息
    contactRequest.SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
    contactRequest.CORP_ID    = [ShareValue shareInstance].userInfo.CORP_ID;
    contactRequest.DEPT_ID    = [ShareValue shareInstance].userInfo.DEPT_ID;
    contactRequest.USER_AUTH  = [ShareValue shareInstance].userInfo.USER_AUTH;
    contactRequest.USER_ID    = [ShareValue shareInstance].userInfo.USER_ID;
    // 请求
    [XTGLAPI queryContactsByRequest:contactRequest success:^(QueryContactsHttpResponse *response)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([response.MESSAGE.MESSAGECODE isEqual:DEFINE_SUCCESSCODE])
        {
            NSArray *aryTemp = response.DATA;
            for (ContactBean *bean in aryTemp)
            {
                bean.USER_NAME_PINYIN = [OAChineseToPinyin pinyinFromChiniseString:bean.REALNAME];
                bean.USER_NAME_HEAD   = [bean.USER_NAME_PINYIN substringWithRange:NSMakeRange(0, 1)];
                [bean saveToDB];
            }
            // 获取原始联系人数据
            arraySourceContact = [ContactBean searchWithWhere:nil orderBy:nil offset:0 count:1000];
            // 刷新表格
            [self filltheTable:arraySourceContact];
            [_tabContact reloadData];
        }
    }
    fail:^(BOOL notReachable, NSString *desciption)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
    }];
}

-(void)handleNotifySelectFin:(NSNotification*)note
{
    if (note)
    {
       selectedDept =  [note object];
    }
    // 合并取值条件
    NSString *deptids = [DeptInfoBean getOwnerAndChildDeptIds:selectedDept.DEPT_ID];
    sqlDeptId = [NSString stringWithFormat:@"DEPT_ID IN (%@)",deptids];
    arraySourceContact = [ContactBean searchWithWhere:sqlDeptId orderBy:nil offset:0 count:1000];
    [self filltheTable:arraySourceContact];
    // 刷新表格
    [_tabContact reloadData];
}

-(void)filltheTable:(NSArray*)array
{
    /*
    // 获取分段信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (ContactBean *bean in array)
    {
        [dict setObject:bean.USER_NAME_HEAD forKey:bean.USER_NAME_HEAD];
    }
     */
    /*
    mSectionArray = (NSMutableArray*)[dict allValues];
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2)
    {
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    mSectionArray = (NSMutableArray*)[mSectionArray sortedArrayUsingComparator:sort];
    // 表格数据填充
    for (NSString*s in mSectionArray)
    {
        NSString *sql = [NSString stringWithFormat:@"USER_NAME_HEAD = '%@'",s];
        NSMutableArray *mN = [ContactBean searchWithWhere:sql orderBy:nil offset:0 count:100];
        [mLocalSectionContact addObject:mN];
    }
     */
}

-(void)selectDept
{
    NSArray *data = [self makeCusTypeTreeData];
    SelectTreeViewController *selectTreeViewController = [[SelectTreeViewController alloc] initWithNibName:@"SelectTreeViewController" bundle:nil];
    selectTreeViewController.data = data;
    [self.navigationController pushViewController:selectTreeViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    if ([mLocalSectionContact count] == 0)
    {
        return 0;
    }
    else
    {
        return [mLocalSectionContact[section] count];
    }
    */
    return [arraySourceContact count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CONTACTCELL";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell"  owner:self options:nil] lastObject];
    }
    ContactBean *bean = arraySourceContact[indexPath.row];
//    ContactBean *bean = mLocalSectionContact[indexPath.section][indexPath.row];
    cell.labName.text = bean.REALNAME;
    cell.btnMsg.tag  = indexPath.section*10000 +indexPath.row;
    cell.btnDail.tag = indexPath.section*10000 +indexPath.row;
    [cell.btnMsg  addTarget:self action:@selector(clkMsg:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDail addTarget:self action:@selector(clkDail:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}
-(void)clkMsg:(id)sender
{
    /*
    UIButton *btn = sender;
    ContactBean *bean = [[ContactBean alloc]init];
    bean =  mLocalSectionContact[btn.tag/10000][btn.tag%10000];
    NSString *str = [NSString stringWithFormat:@"sms://%@",bean.MOBILENO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
     */
}
-(void)clkDail:(id)sender
{
    /*
    UIButton *btn = sender;
    ContactBean *bean = [[ContactBean alloc]init];

    bean =  mLocalSectionContact[btn.tag/10000][btn.tag%10000];

    NSString *str = [NSString stringWithFormat:@"tel://%@",bean.MOBILENO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
     */
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_schBar resignFirstResponder];
    [_tabContact reloadData];
}
/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mSectionArray count];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return mSectionArray[section];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return mSectionArray;
}
*/

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *text = [searchBar text];
    NSMutableString *sql =  [NSMutableString stringWithFormat:@"(USER_NAME_PINYIN LIKE '%%%@%%' OR REALNAME LIKE '%%%@%%' OR MOBILENO LIKE '%%%@%%')",text,text,text];
    if (sqlDeptId!= nil)
    {
        [sql appendFormat:@" AND %@",sqlDeptId];
    }
    arraySourceContact = [ContactBean searchWithWhere:sql orderBy:nil offset:0 count:1000];
    [_tabContact reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *text = [searchBar text];
    NSMutableString *sql =  [NSMutableString stringWithFormat:@"(USER_NAME_PINYIN LIKE '%%%@%%' OR REALNAME LIKE '%%%@%%' OR MOBILENO LIKE '%%%@%%')",text,text,text];
    if (sqlDeptId!= nil)
    {
        [sql appendFormat:@" AND %@",sqlDeptId];
    }
    arraySourceContact = [ContactBean searchWithWhere:sql orderBy:nil offset:0 count:1000];
    [_tabContact reloadData];
}


- (NSArray *)makeCusTypeTreeData
{
    NSMutableArray *parentTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:arraySourceDept];
    for(DeptInfoBean *customerType in arraySourceDept)
    {
        if(customerType.DEPT_PID == 0)
        {
            TreeData *aryData = [[TreeData alloc] init];
            aryData.name = customerType.DEPT_NAME;
            aryData.dataInfo = customerType;
            [parentTree addObject:aryData];
            
            [arySourceData removeObject:customerType];
        }
    }
    
    [self makeSubCusTypeTreeData:arySourceData ParentTreeData:parentTree];
    return parentTree;
}

- (void)makeSubCusTypeTreeData:(NSArray *)sourceData ParentTreeData:(NSMutableArray *)parentTree
{
    NSMutableArray *aryChildTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:sourceData];
    for(DeptInfoBean *customerType in sourceData)
    {
        for(TreeData *parentData in parentTree)
        {
            DeptInfoBean *parentCusType = (DeptInfoBean *)parentData.dataInfo;
            if(customerType.DEPT_PID == parentCusType.DEPT_ID)
            {
                TreeData *aryData = [[TreeData alloc] init];
                aryData.name = customerType.DEPT_NAME;
                aryData.dataInfo = customerType;
                [parentData.children addObject:aryData];
                
                [aryChildTree addObject:aryData];
                [arySourceData removeObject:customerType];
            }
        }
    }
    
    if(arySourceData.count > 0)
    {
        [self makeSubCusTypeTreeData:arySourceData ParentTreeData:aryChildTree];
    }
}
@end
