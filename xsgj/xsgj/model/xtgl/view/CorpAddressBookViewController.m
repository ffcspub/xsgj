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

@interface CorpAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    // A-Z段落列表
    NSMutableArray *mSectionArray;
    // 分段联系人-二维
    NSMutableArray *mLocalSectionContact;
    
    // 部门选择表格
    UITableView *tableDept;
    // 部门数据内容
    NSArray     *arrayDept;
}
@end

@implementation CorpAddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        mLocalSectionContact = [[NSMutableArray alloc]init];
        arrayDept            = [NSArray array];
        [DeptInfoBean deleteWithWhere:nil];
        [ContactBean deleteWithWhere:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"部门选择⬇️" forState:UIControlStateNormal];
    [button setTitle:@"部门选择⬇️" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [button addTarget:self action:@selector(selectDept) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
    CGRect rect = _tabContact.frame;
    rect.origin.y    -= _schBar.frame.size.height;
    rect.size.height += _schBar.frame.size.height;
    
    tableDept = [[UITableView alloc]initWithFrame:rect];
    tableDept.backgroundColor = RGBA(0, 0, 0, 0.5);
    tableDept.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableDept.hidden = YES;
    tableDept.delegate = self;
    tableDept.dataSource = self;
    [self.view addSubview:tableDept];
    
    
    // 部门信息
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GetUserAllDeptHttpRequest *deptRequest = [[GetUserAllDeptHttpRequest alloc]init];
    // 基本信息
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
            
            // 获取A-Z分段列表
            NSMutableArray *mSearch = [ContactBean searchWithWhere:nil orderBy:nil offset:0 count:500];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (ContactBean *bean in mSearch)
            {
                [dict setObject:bean.USER_NAME_HEAD forKey:bean.USER_NAME_HEAD];
            }
            mSectionArray = (NSMutableArray*)[dict allValues];
            NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
            NSWidthInsensitiveSearch|NSForcedOrderingSearch;
            NSComparator sort = ^(NSString *obj1,NSString *obj2)
            {
                NSRange range = NSMakeRange(0,obj1.length);
                return [obj1 compare:obj2 options:comparisonOptions range:range];
            };
            mSectionArray = (NSMutableArray*)[mSectionArray sortedArrayUsingComparator:sort];
            //
            for (NSString*s in mSectionArray)
            {
                NSString *sql = [NSString stringWithFormat:@"USER_NAME_HEAD = '%@'",s];
                NSMutableArray *mN = [ContactBean searchWithWhere:sql orderBy:nil offset:0 count:100];
                [mLocalSectionContact addObject:mN];
            }
            // 刷新table
            [_tabContact reloadData];
            
            /*
            NSMutableArray *temp = [DeptInfoBean searchWithWhere:@"DEPT_PID = 0" orderBy:nil offset:0 count:100];
            for (int i = 0 ; i< [temp count]; i++)
            {
                DeptInfoBean *bean = temp[i];
                TRDeptInfoBean *trBean = [[TRDeptInfoBean alloc]init];
                trBean.DEPT_ID    = bean.DEPT_ID;
                trBean.DEPT_PID   = bean.DEPT_PID;
                trBean.DEPT_NAME  = bean.DEPT_NAME;
                NSString *sql = [NSString stringWithFormat:@"DEPT_PID = %d",bean.DEPT_ID];
                NSMutableArray *subArray = [DeptInfoBean searchWithWhere:sql orderBy:nil offset:0 count:100];
                trBean.SUB_BEAN   = subArray;
                for (int i = 0 ; i < [trBean.SUB_BEAN count]; i++)
                {
                    DeptInfoBean *bean = trBean.SUB_BEAN[i];
                    TRDeptInfoBean *sbBean = [[TRDeptInfoBean alloc]init];
                    sbBean.DEPT_ID    = bean.DEPT_ID;
                    sbBean.DEPT_PID   = bean.DEPT_PID;
                    sbBean.DEPT_NAME  = bean.DEPT_NAME;
                }
            }
            */
            
        }
    }
    fail:^(BOOL notReachable, NSString *desciption)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
    }];
    
    
}

-(void)selectDept
{
    if (tableDept.hidden == NO)
    {
        tableDept.hidden = YES;
    }
    else
    {
        tableDept.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([mLocalSectionContact count] == 0)
    {
        return 0;
    }
    else
    {
        return [mLocalSectionContact[section] count];
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
    ContactBean *bean = mLocalSectionContact[indexPath.section][indexPath.row];
    cell.labName.text = bean.REALNAME;
    cell.btnMsg.tag  = indexPath.section*10000 +indexPath.row;
    cell.btnDail.tag = indexPath.section*10000 +indexPath.row;
    [cell.btnMsg  addTarget:self action:@selector(clkMsg:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDail addTarget:self action:@selector(clkDail:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}
-(void)clkMsg:(id)sender
{
    UIButton *btn = sender;
    ContactBean *bean = [[ContactBean alloc]init];
    bean =  mLocalSectionContact[btn.tag/10000][btn.tag%10000];
    NSString *str = [NSString stringWithFormat:@"sms://%@",bean.MOBILENO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)clkDail:(id)sender
{
    UIButton *btn = sender;
    ContactBean *bean = [[ContactBean alloc]init];

    bean =  mLocalSectionContact[btn.tag/10000][btn.tag%10000];

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

//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    [self filterBySubString:searchText];
//}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    [self filterBySubString:searchBar.text];
    [searchBar resignFirstResponder];
}

-(void)filterBySubString:(NSString*)subStr
{
//    NSString *sql = @"REALNAME like '林%'";
//    searchData = [ContactBean searchWithWhere:sql orderBy:nil offset:0 count:100];
    [_tabContact reloadData];
}
@end
