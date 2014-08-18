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
#import "NSString+URL.h"
#import "NSObject+LKDBHelper.h"
#import "TreeViewCell.h"
#import "SelectTreeViewController.h"
#import "UIImageView+WebCache.h"
#import <Reachability.h>

@interface CorpAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    // A-Z段落列表
    NSMutableArray *mAzArray;
    // 原始部门数据
    NSArray        *arraySourceDept;
    // 原始联系人数据
    NSArray        *arraySourceContact;
    // 选定的部门
    DeptInfoBean   *selectedDept;
    // 联系人查询条件
    NSString       *sqlDeptId;
    // 综合查询条件
    NSString       *sqlDeptIdAndSerach;
    // UI实际填充-二维
    NSMutableArray *mUIdataArray;
}
@end

@implementation CorpAddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        arraySourceDept      = [NSArray array];
        mAzArray             = [NSMutableArray array];
        mUIdataArray         = [NSMutableArray array];
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
    // 网路状态好则重新获取信息列表,状态查则从本地数据库读取
    if ([self isEnableNetwork])
    {
        [DeptInfoBean deleteWithWhere:nil];
        [ContactBean deleteWithWhere:nil];
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
        }fail:^(BOOL notReachable, NSString *desciption)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"网络不给力" toView:self.view];
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
                     bean.USER_NAME_PINYIN = [bean.REALNAME convertCNToPinyin];
                     if (bean.USER_NAME_PINYIN.length > 0) {
                         bean.USER_NAME_HEAD   = [bean.USER_NAME_PINYIN substringWithRange:NSMakeRange(0, 1)];
                     }
                     [bean saveToDB];
                 }
                 // 获取原始联系人数据
                 arraySourceContact = [ContactBean searchWithWhere:nil orderBy:nil offset:0 count:1000];
                 // 分段处理
                 [self filltheTable:arraySourceContact];
             }
         }fail:^(BOOL notReachable, NSString *desciption)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MBProgressHUD showError:@"网络不给力" toView:self.view];
         }];

    }
    // 无网络情况
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        arraySourceDept = [DeptInfoBean searchWithWhere:nil orderBy:nil offset:0 count:1000];
        if (!arraySourceDept)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"部门信息为空" toView:self.view];
        }
        arraySourceContact = [ContactBean searchWithWhere:nil orderBy:nil offset:0 count:1000];
        if (!arraySourceContact)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"联系人信息为空" toView:self.view];
        }
        [self filltheTable:arraySourceContact];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
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
}

-(void)filltheTable:(NSArray*)array
{
    mUIdataArray = nil;
    mAzArray     = nil;
    mUIdataArray = [NSMutableArray array];
    mAzArray     = [NSMutableArray array];
    // 获取分段信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (ContactBean *bean in array)
    {
        [dict setObject:bean.USER_NAME_HEAD forKey:bean.USER_NAME_HEAD];
    }
    mAzArray = (NSMutableArray*)[dict allValues];
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2)
    {
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    mAzArray = (NSMutableArray*)[mAzArray sortedArrayUsingComparator:sort];
    // 表格数据填充
    for (NSString*s in mAzArray)
    {
        NSMutableString *sql = [NSMutableString stringWithFormat:@"USER_NAME_HEAD = '%@'",s];
        if ([[_schBar text] length] <= 0 && sqlDeptId)
        {
            [sql appendFormat:@" AND (%@)",sqlDeptId];
        }
        if ([[_schBar text] length] > 0  && sqlDeptIdAndSerach)
        {
            [sql appendFormat:@" AND (%@)",sqlDeptIdAndSerach];
        }
        NSMutableArray *list = [ContactBean searchWithWhere:sql orderBy:nil offset:0 count:1000];
        [mUIdataArray addObject:list];
    }
    //NSLog(@"[mUIdataArray count] = %d",[mUIdataArray count]);
    // 刷新表格
    [_tabContact reloadData];
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
    if ([mAzArray count] == 0)
    {
        return 0;
    }
    else
    {
        //NSLog(@"numberOfRowsInSection = %d",[mUIdataArray[section] count]);
        return [mUIdataArray[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CONTACTCELL";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell"  owner:self options:nil] lastObject];
    }
    ContactBean *bean = mUIdataArray[indexPath.section][indexPath.row];
    cell.labName.text = bean.REALNAME;
    cell.btnMsg.tag  = indexPath.section*10000 +indexPath.row;
    cell.btnDail.tag = indexPath.section*10000 +indexPath.row;
    [cell.btnMsg  addTarget:self action:@selector(clkMsg:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDail addTarget:self action:@selector(clkDail:) forControlEvents:UIControlEventTouchUpInside];
    if([bean.PHOTO length] > 1)
    {
        NSString *strUrl = [ShareValue getFileUrlByFileId:bean.PHOTO];
        [cell.imageIcon sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"defaultPhoto"]];
    }
    
    return cell;

}

-(void)clkMsg:(id)sender
{
    
    UIButton *btn = sender;
    ContactBean *bean = [[ContactBean alloc]init];
    bean =  mUIdataArray[btn.tag/10000][btn.tag%10000];
    NSString *str = [NSString stringWithFormat:@"sms://%@",bean.MOBILENO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
-(void)clkDail:(id)sender
{
    UIButton *btn = sender;
    ContactBean *bean = [[ContactBean alloc]init];
    bean =  mUIdataArray[btn.tag/10000][btn.tag%10000];
    NSString *str = [NSString stringWithFormat:@"tel://%@",bean.MOBILENO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_schBar resignFirstResponder];
    [_tabContact reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mAzArray count];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return mAzArray[section];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return mAzArray;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *text = [searchBar text];
    NSString *sql  = @"";
    if ([text length] <= 0)
    {
        if (sqlDeptId!= nil)
        {
            sql = [NSString stringWithFormat:@"%@",sqlDeptId];
            arraySourceContact = [ContactBean searchWithWhere:sql orderBy:nil offset:0 count:1000];
            [self filltheTable:arraySourceContact];
            return;
        }
        else
        {
            arraySourceContact = [ContactBean searchWithWhere:nil orderBy:nil offset:0 count:1000];
            [self filltheTable:arraySourceContact];
            return;
        }
    }
    else
    {
        if (sqlDeptId!= nil)
        {
            sql =  [NSMutableString stringWithFormat:@"(USER_NAME_PINYIN LIKE '%%%@%%' OR REALNAME LIKE '%%%@%%' OR MOBILENO LIKE '%%%@%%') AND %@",text,text,text,sqlDeptId];
            sqlDeptIdAndSerach = sql;
            arraySourceContact = [ContactBean searchWithWhere:sqlDeptIdAndSerach orderBy:nil offset:0 count:1000];
            [self filltheTable:arraySourceContact];
        }
        else
        {
            sql =  [NSMutableString stringWithFormat:@"(USER_NAME_PINYIN LIKE '%%%@%%' OR REALNAME LIKE '%%%@%%' OR MOBILENO LIKE '%%%@%%')",text,text,text];
            sqlDeptIdAndSerach = sql;
            arraySourceContact = [ContactBean searchWithWhere:sqlDeptIdAndSerach orderBy:nil offset:0 count:1000];
            [self filltheTable:arraySourceContact];
        }
    }
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
    [self filltheTable:arraySourceContact];
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

-(BOOL)isEnableNetwork
{
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable)
    {
        return NO;
    }
    return YES;
}
@end
