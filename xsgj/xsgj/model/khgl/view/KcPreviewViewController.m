//
//  KcPreviewViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KcPreviewViewController.h"

@interface KcPreviewViewController ()

@end

@implementation KcPreviewViewController

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
    
    [self initView];
    [self adjustTableViewHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"库存预览";
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(handleNavBarRight)];
    
    [self.svSubContain setContentSize:CGSizeMake(360, 0)];
    
}

#pragma mark - functions

- (void)handleNavBarRight
{
}

- (void)adjustTableViewHeight
{
    // todo: 根据数据计算
    CGRect frame = self.tvTypeName.frame;
    frame.size.height = (5 + 1) * 44;
    self.tvTypeName.frame = frame;
    
    frame = self.tvDetail.frame;
    frame.size.height = (5 + 1) * 44;
    self.tvDetail.frame = frame;
    
    [self.svMainContain setContentSize:CGSizeMake(0, self.tvTypeName.frame.origin.y + self.tvTypeName.frame.size.height + 10)];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    return self.aryData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tvTypeName)
    {
        PreviewNameCell *nameCell = [tableView dequeueReusableCellWithIdentifier:@"PREVIEWNAMECELL"];
        if (!nameCell) {
            [tableView registerNib:[UINib nibWithNibName:@"PreviewNameCell" bundle:nil] forCellReuseIdentifier:@"PREVIEWNAMECELL"];
            nameCell = [tableView dequeueReusableCellWithIdentifier:@"PREVIEWNAMECELL"];
        }
        nameCell.lbName.text = @"产品名字";
        
        nameCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return nameCell;
    }
    else if(tableView == self.tvDetail)
    {
        PreviweDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"PREVIEWDETAILCELL"];
        if (!detailCell) {
            [tableView registerNib:[UINib nibWithNibName:@"PreviweDetailCell" bundle:nil] forCellReuseIdentifier:@"PREVIEWDETAILCELL"];
            detailCell = [tableView dequeueReusableCellWithIdentifier:@"PREVIEWDETAILCELL"];
        }
        
        NSArray *arytest = @[@"100",@"箱",@"2014-08-20"];
        [detailCell setCellValue:arytest];
        detailCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return detailCell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
