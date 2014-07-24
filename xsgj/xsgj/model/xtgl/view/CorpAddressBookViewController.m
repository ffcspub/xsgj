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

@interface CorpAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    // 本地部门信息
    NSMutableArray *mLocalDept;
    // 本地联系人
    NSMutableArray *mLocalContact;

    // A-Z段落列表
    NSMutableArray *mSectionArray;
    // 分段联系人-二维
    NSMutableArray *mLocalSectionContact;
}
@end

@implementation CorpAddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        mLocalDept           = [[NSMutableArray alloc]init];
        mLocalContact        = [[NSMutableArray alloc]init];
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
                [mLocalDept addObject:bean];
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
                
                [mLocalContact addObject:bean];
            }
            
            // 获取A-Z分段列表
            NSMutableArray *mSearch = [ContactBean searchWithWhere:nil orderBy:nil offset:0 count:100];
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

    cell.btnMsg.tag  = indexPath.row;
    cell.btnDail.tag = indexPath.row;
    
    [cell.btnMsg  addTarget:self action:@selector(clkMsg:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDail addTarget:self action:@selector(clkDail:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}

-(void)clkMsg:(id)sender
{
    UIButton *btn = sender;
    ContactBean *bean =  mLocalContact[btn.tag];
    NSString *str = [NSString stringWithFormat:@"sms://%@",bean.MOBILENO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)clkDail:(id)sender
{
    UIButton *btn = sender;
    ContactBean *bean =  mLocalContact[btn.tag];
    NSString *str = [NSString stringWithFormat:@"tel://%@",bean.MOBILENO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_schBar resignFirstResponder];
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
@end
