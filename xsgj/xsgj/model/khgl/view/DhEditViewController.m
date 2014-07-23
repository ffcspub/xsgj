//
//  DhEditViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DhEditViewController.h"

@interface DhEditViewController ()

@end

@implementation DhEditViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"订货编辑";
}

#pragma mark - functions

- (IBAction)handleBtnTypeClicked:(id)sender {
}

- (IBAction)handleBtnNameClicked:(id)sender {
}

- (IBAction)handleCommit:(id)sender {
}

- (IBAction)handlePreview:(id)sender {
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectIndex.row && _selectIndex != nil)
    {
        return 224;
    }
    else
    {
        return 44;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DhEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DHEDITCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"DhEditCell" bundle:nil] forCellReuseIdentifier:@"DHEDITCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DHEDITCELL"];
    }
    
    if(_aryData.count > 0)
    {
        cell.indexPath = indexPath;
        cell.lbName.text = @"纯牛奶（200ml）";
        cell.lbNumber.text = @"300";
        cell.tfUnit.text = @"瓶";
    }
    
    if (indexPath.row == _selectIndex.row && _selectIndex != nil)
    {
        cell.vDetail.hidden = NO;
    }
    else
    {
        cell.vDetail.hidden = YES;
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_selectIndex)
    {
        _selectIndex = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_selectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        BOOL selectTheSameRow = indexPath.row == _selectIndex.row? YES:NO;
        if (!selectTheSameRow)
        {
            NSIndexPath *tempIndexPath = [_selectIndex copy];
            _selectIndex = nil;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tempIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            _selectIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_selectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            _selectIndex = nil;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

#pragma mark - DhEditCellDelegate

- (void)onBtnDelClicked:(DhEditCell *)cell
{
    // todo: 删除数据源
    [_tvContain insertRowsAtIndexPaths:[NSMutableArray arrayWithObject:cell.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
