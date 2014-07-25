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
    // 搜索状态
    BOOL isSeach;
    // 原始表格数据
    NSArray* tableData;
    // 搜索结果数据
    NSArray* searchData;
}
@end

@implementation CorpAddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        mLocalSectionContact = [[NSMutableArray alloc]init];
        [DeptInfoBean deleteWithWhere:nil];
        [ContactBean deleteWithWhere:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
            tableData = mSearch;
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
                NSLog(@"mN = %@",mN);
                [mLocalSectionContact addObject:mN];
            }
            NSLog(@"mLocalSectionContact = %@",mLocalSectionContact);
            // 刷新table
            [_tabContact reloadData];

        }
    }
    fail:^(BOOL notReachable, NSString *desciption)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络不给力" toView:self.view];
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSeach)
    {
        return [searchData count];
    }
    else
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CONTACTCELL";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell"  owner:self options:nil] lastObject];
    }
    if (isSeach)
    {
        cell.labName.text = searchData[indexPath.row];
        cell.btnMsg.tag  = indexPath.row;
        cell.btnDail.tag = indexPath.row;
    }
    else
    {
        ContactBean *bean = mLocalSectionContact[indexPath.section][indexPath.row];
        cell.labName.text = bean.REALNAME;
        cell.btnMsg.tag  = indexPath.section*10000 +indexPath.row;
        cell.btnDail.tag = indexPath.section*10000 +indexPath.row;
    }
    [cell.btnMsg  addTarget:self action:@selector(clkMsg:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDail addTarget:self action:@selector(clkDail:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}
-(void)clkMsg:(id)sender
{
    UIButton *btn = sender;
    ContactBean *bean = [[ContactBean alloc]init];
    if (isSeach)
    {
        bean =  searchData[btn.tag];
    }
    else
    {
        bean =  mLocalSectionContact[btn.tag/10000][btn.tag%10000];
    }
    NSString *str = [NSString stringWithFormat:@"sms://%@",bean.MOBILENO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)clkDail:(id)sender
{
    UIButton *btn = sender;
    ContactBean *bean = [[ContactBean alloc]init];
    if (isSeach)
    {
        bean =  searchData[btn.tag];
    }
    else
    {
        bean =  mLocalSectionContact[btn.tag/10000][btn.tag%10000];
    }
    NSString *str = [NSString stringWithFormat:@"tel://%@",bean.MOBILENO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isSeach = NO;
    [_schBar resignFirstResponder];
    [_tabContact reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSeach)
    {
        return 1;
    }
    return [mSectionArray count];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (isSeach)
    {
        return @"";
    }
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
    isSeach = YES;
    NSString *sql = @"REALNAME like '林%'";
    searchData = [ContactBean searchWithWhere:sql orderBy:nil offset:0 count:100];
    [_tabContact reloadData];
}
@end
