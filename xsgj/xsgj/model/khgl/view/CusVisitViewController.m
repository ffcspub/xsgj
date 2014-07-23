//
//  CusVisitViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-16.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "CusVisitViewController.h"
#import "LKDBHelper.h"
#import "BNMobileMenu.h"
#import "DzPhotoViewController.h"
#import "CLPhotoViewController.h"
#import "ClLivelyViewController.h"
#import "ClCostViewController.h"
#import "HdReportViewController.h"
#import "JpReportViewController.h"
#import "KcReportViewController.h"
#import "DhReportViewController.h"

@interface CusVisitViewController ()
{
    NSArray *_aryFuncItems;
    IBActionSheet *_actionSheet;
}

@end

@implementation CusVisitViewController

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
    [self LoadFunctionItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"客户拜访";
    [_svContain setContentSize:CGSizeMake(_svContain.frame.size.width, _btnVisitEnd.frame.origin.y + _btnVisitEnd.frame.size.height + 10)];
    
    UIImage *image = [UIImage imageNamed:@"CommonBtn_nor"];
    image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    UIImage *imageH = [UIImage imageNamed:@"CommonBtn_press"];
    imageH = [imageH stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    UIImage *imageD = [UIImage imageNamed:@"CommonBtn_disable"];
    imageD = [imageD stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    [_btnVisitBegin setBackgroundImage:image forState:UIControlStateNormal];
    [_btnVisitBegin setBackgroundImage:imageH forState:UIControlStateHighlighted];
    [_btnVisitBegin setBackgroundImage:imageD forState:UIControlStateDisabled];
    [_btnVisitEnd setBackgroundImage:image forState:UIControlStateNormal];
    [_btnVisitEnd setBackgroundImage:imageH forState:UIControlStateHighlighted];
    [_btnVisitEnd setBackgroundImage:imageD forState:UIControlStateDisabled];
    
    if(_customerInfo)
    {
        _lbCusName.text = _customerInfo.CUST_NAME;
        // todo: 拜访情况数据显示，是否已经到访登记和时间
    }
}

#pragma mark - functions

- (IBAction)handleBtnRefreshClicked:(id)sender {
}

- (IBAction)handleBtnMapClicked:(id)sender {
}

- (IBAction)handleBtnVisitCaseClicked:(id)sender {
    // todo:根据查询数据显示拜访情况
    NSArray *aryCusNames = @[@"情况1",@"情况2",@"情况3"];
    _actionSheet = [[IBActionSheet alloc] initWithTitle:@"选择拜访情况"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil, nil];
    for(NSString *cusName in aryCusNames)
    {
        [_actionSheet addButtonWithTitle:cusName];
    }
    
    [_actionSheet showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view];
}

- (IBAction)handleBtnVisitBeginClicked:(id)sender {
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strCurrentTime = [timeFormatter stringFromDate:[NSDate date]];
    _lbVisitTime.text = strCurrentTime;
    _btnVisitBegin.enabled = NO;
}

- (IBAction)handleBtnVisitEndClicked:(id)sender {
}

- (void)LoadFunctionItems
{
    _aryFuncItems = [BNMobileMenu searchWithWhere:[NSString stringWithFormat:@"PARENT_ID=%D and STATE=1",17] orderBy:@"ORDER_NO" offset:0 count:100];
    
    CGRect frame = _tvFuncBg.frame;
    frame.size.height = _aryFuncItems.count * 44;
    _tvFuncBg.frame = frame;
    
    frame = _ivIconOver.frame;
    frame.origin.y = _tvFuncBg.frame.origin.y + _tvFuncBg.frame.size.height;
    _ivIconOver.frame = frame;
    
    frame = _btnVisitEnd.frame;
    frame.origin.y = _ivIconOver.frame.origin.y + 8;
    _btnVisitEnd.frame = frame;
    
    [_svContain setContentSize:CGSizeMake(_svContain.frame.size.width, _btnVisitEnd.frame.origin.y + _btnVisitEnd.frame.size.height + 10)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryFuncItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CusVisitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CUSVISITCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CusVisitCell" bundle:nil] forCellReuseIdentifier:@"CUSVISITCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"CUSVISITCELL"];
    }
    
    if(_aryFuncItems.count > 0)
    {
        BNMobileMenu *funcItem = [_aryFuncItems objectAtIndex:indexPath.row];
        cell.lbName.text = funcItem.MENU_NAME;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_btnVisitBegin.enabled)
    {
        // 提示尚未到访登记
        return;
    }
    
    UIViewController *controller = nil;
    CusVisitCell *cell = (CusVisitCell *)[tableView cellForRowAtIndexPath:indexPath];
    if([cell.lbName.text isEqual:@"店招拍照"])
    {
        DzPhotoViewController *viewController = [[DzPhotoViewController alloc] initWithNibName:@"DzPhotoViewController" bundle:nil];
        controller = viewController;
    }
    else if([cell.lbName.text isEqual:@"陈列拍照"])
    {
        CLPhotoViewController *viewController = [[CLPhotoViewController alloc] initWithNibName:@"CLPhotoViewController" bundle:nil];
        controller = viewController;
    }
    else if([cell.lbName.text isEqual:@"陈列生动化"])
    {
        ClLivelyViewController *viewController = [[ClLivelyViewController alloc] initWithNibName:@"ClLivelyViewController" bundle:nil];
        controller = viewController;
    }
    else if([cell.lbName.text isEqual:@"陈列费用"])
    {
        ClCostViewController *viewController = [[ClCostViewController alloc] initWithNibName:@"ClCostViewController" bundle:nil];
        controller = viewController;
    }
    else if([cell.lbName.text isEqual:@"库存上报"])
    {
        KcReportViewController *viewController = [[KcReportViewController alloc] initWithNibName:@"KcReportViewController" bundle:nil];
        controller = viewController;
    }
    else if([cell.lbName.text isEqual:@"订货上报"])
    {
        DhReportViewController *viewController = [[DhReportViewController alloc] initWithNibName:@"KcReportViewController" bundle:nil];
        controller = viewController;
    }
    else if([cell.lbName.text isEqual:@"退货上报"])
    {
        
    }
    else if([cell.lbName.text isEqual:@"活动上报"])
    {
        HdReportViewController *viewController = [[HdReportViewController alloc] initWithNibName:@"HdReportViewController" bundle:nil];
        controller = viewController;
    }
    else if([cell.lbName.text isEqual:@"竞品上报"])
    {
        JpReportViewController *viewController = [[JpReportViewController alloc] initWithNibName:@"JpReportViewController" bundle:nil];
        controller = viewController;
    }
    
    if(!controller)
        return;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - IBActionSheetDelegate

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *strSelect = [_actionSheet buttonTitleAtIndex:buttonIndex];
    _lbCusName.text = strSelect;
}

@end
