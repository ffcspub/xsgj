//
//  SelectTreeViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SelectTreeViewController.h"
#import "BNCustomerType.h"
#import "BNAreaInfo.h"

@interface SelectTreeViewController ()


@end

@implementation SelectTreeViewController

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
    
    self.strSelect = @"";
    _aryExpanded = [[NSMutableArray alloc] init];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
    }
    self.treeView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"选择";
    [self showRightBarButtonItemWithTitle:@"确定" target:self action:@selector(handleNavBarRight)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
//    // test data
//    TreeViewData *item1 = [TreeViewData dataObjectWithName:@"item 1" children:nil];
//    TreeViewData *item2 = [TreeViewData dataObjectWithName:@"item 2" children:nil];
//    TreeViewData *item3 = [TreeViewData dataObjectWithName:@"item 3" children:nil];
//    TreeViewData *item4 = [TreeViewData dataObjectWithName:@"item 4" children:nil];
//    TreeViewData *items = [TreeViewData dataObjectWithName:@"items"
//                                                  children:[NSArray arrayWithObjects:item1, item2, item3, item4, nil]];
//    
//    TreeViewData *other1 = [TreeViewData dataObjectWithName:@"other 1" children:nil];
//    TreeViewData *other2 = [TreeViewData dataObjectWithName:@"other 2" children:nil];
//    TreeViewData *others = [TreeViewData dataObjectWithName:@"others"
//                                                   children:[NSArray arrayWithObjects:other1,other2, nil]];
//    TreeViewData *oneItem = [TreeViewData dataObjectWithName:@"oneItem" children:nil];
//
//    
//    self.data = @[items,oneItem,others,others,others,others,others];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.frame];
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    [treeView reloadData];
    
    self.treeView = treeView;
    [self.view addSubview:treeView];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    if([self.strSelect isEqualToString:@""])
    {
        // todo: 提示
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECT_FIN object:self.selectInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 44;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 10 * treeNodeInfo.treeDepthLevel;
}

- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    [_aryExpanded addObject:item];
}

- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    [_aryExpanded removeObject:item];
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    for(id exItem in _aryExpanded)
    {
        if ([item isEqual:exItem])
        {
            return YES;
        }
    }

    return NO;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    TreeViewCell *cell = (TreeViewCell *)[treeView cellForItem:item];
    if (!cell.btnExpand.hidden)
    {
        cell.btnExpand.selected = !cell.btnExpand.selected;
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    TreeViewCell *cell = [treeView dequeueReusableCellWithIdentifier:@"TREEVIEWCELL"];
    if (!cell) {
        [treeView registerNib:[UINib nibWithNibName:@"TreeViewCell" bundle:nil] forCellReuseIdentifier:@"TREEVIEWCELL"];
        cell = [treeView dequeueReusableCellWithIdentifier:@"TREEVIEWCELL"];
    }
    
    if([((TreeData *)item).name isEqualToString:self.strSelect])
    {
        ((TreeData *)item).bSelected = YES;
    }
    else
    {
        ((TreeData *)item).bSelected = NO;
    }
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.treeData = (TreeData *)item;
    cell.lbName.text = ((TreeData *)item).name;
    cell.btnSelected.selected = ((TreeData *)item).bSelected;
    cell.iDepthLevel = treeNodeInfo.treeDepthLevel;
    if (((TreeData *)item).children.count > 0)
    {
        cell.btnExpand.hidden = NO;
        cell.btnExpand.selected = treeNodeInfo.expanded;
    }
    else
    {
        cell.btnExpand.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    TreeData *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    TreeData *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}

#pragma mark - TreeViewCellDelegate

- (void)onbtnSelectedClicked:(TreeViewCell *)cell
{
    self.strSelect = cell.lbName.text;
    self.selectInfo = cell.treeData.dataInfo;
    self.navigationItem.rightBarButtonItem.enabled = cell.btnSelected.selected;
    [self.treeView reloadData];
}

@end
