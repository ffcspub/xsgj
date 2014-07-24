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

@interface CorpAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *mAry_DEPT_ID;
    NSMutableArray *mAry_DEPT_NAME;
    NSMutableArray *mAry_DEPT_PID;
    NSMutableArray *mAry_REALNAME;
    NSMutableArray *mAry_MOBILENO;
}
@end

@implementation CorpAddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        mAry_DEPT_ID   = [[NSMutableArray alloc]init];
        mAry_DEPT_NAME = [[NSMutableArray alloc]init];
        mAry_DEPT_PID  = [[NSMutableArray alloc]init];
        mAry_REALNAME  = [[NSMutableArray alloc]init];
        mAry_MOBILENO  = [[NSMutableArray alloc]init];
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
                [mAry_DEPT_ID    addObject:@(bean.DEPT_ID)];
                [mAry_DEPT_PID   addObject:@(bean.DEPT_PID)];
                [mAry_DEPT_NAME  addObject:bean.DEPT_NAME];
            }
            NSLog(@"%@",mAry_DEPT_ID);
            NSLog(@"%@",mAry_DEPT_PID);
            for (NSString *s in mAry_DEPT_NAME)
            {
                 NSLog(@"%@",s);
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
                [mAry_REALNAME    addObject:bean.REALNAME];
                [mAry_MOBILENO    addObject:bean.MOBILENO];
            }
            for (NSString *s in mAry_REALNAME)
            {
                NSLog(@"%@",s);
            }
            for (NSString *s in mAry_MOBILENO)
            {
                NSLog(@"%@",s);
            }
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
    return [mAry_REALNAME count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CONTACTCELL";
    
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell"  owner:self options:nil] lastObject];
    }
    cell.labName.text = mAry_REALNAME[indexPath.row];
    cell.btnMsg.tag  = indexPath.row;
    cell.btnDail.tag = indexPath.row;
    
    [cell.btnMsg  addTarget:self action:@selector(clkMsg:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDail addTarget:self action:@selector(clkDail:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}

-(void)clkMsg:(id)sender
{
    UIButton *btn = sender;
    NSString *str = [NSString stringWithFormat:@"sms://%@",mAry_MOBILENO[btn.tag]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)clkDail:(id)sender
{
    UIButton *btn = sender;
    NSString *str = [NSString stringWithFormat:@"tel://%@",mAry_MOBILENO[btn.tag]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_schBar resignFirstResponder];
}

@end
