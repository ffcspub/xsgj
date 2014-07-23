//
//  KcEditViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KcEditViewController.h"
#import "KcPreviewViewController.h"
#import "BNProduct.h"

@interface KcEditViewController ()

@end

@implementation KcEditViewController

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
    
    _selectIndex = nil;
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"库存编辑";
}

#pragma mark - functions

- (IBAction)handleBtnCommitClicked:(id)sender {
    
}

- (IBAction)handleBtnPreviewClicked:(id)sender {
    KcPreviewViewController *viewController = [[KcPreviewViewController alloc] initWithNibName:@"KcPreviewViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectIndex.row && _selectIndex != nil)
    {
        return 204;
    }
    else
    {
       return 44;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KcEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KCEDITCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KcEditCell" bundle:nil] forCellReuseIdentifier:@"KCEDITCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"KCEDITCELL"];
    }
    
    if(_aryData.count > 0)
    {
        BNProduct *product = [_aryData objectAtIndex:indexPath.row];
        cell.indexPath = indexPath;
        cell.lbName.text = product.PROD_NAME;
        cell.lbNumber.text = @"0";
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

#pragma mark - KcEditCellDelegate

- (void)onBtnAddClicked:(KcEditCell *)cell
{
    // todo: 添加数据源
    NSInteger iAddRow = cell.indexPath.row + 1;
    NSIndexPath *path = [NSIndexPath indexPathForRow:iAddRow inSection:0];
    [_tvContain deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)onBtnDelClicked:(KcEditCell *)cell
{
    // todo: 删除数据源
    [_tvContain insertRowsAtIndexPaths:[NSMutableArray arrayWithObject:cell.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)onBtnPhotoClicked:(KcEditCell *)cell
{
    [super takePhoto];
}

#pragma mark - UIImagePickerControllerDelegate

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [image imageByScaleForSize:CGSizeMake(self.view.frame.size.width * 1.5, self.view.frame.size.height * 1.5)];
        // todo: 显示，数据处理
        
        ImageFileInfo *imageInfo = [[ImageFileInfo alloc]initWithImage:image];
        [_aryfileDatas addObject:imageInfo];
        _totalfilesize += imageInfo.filesize;
        
    }
    [picker dismissModalViewControllerAnimated:YES];
    _picker = nil;
}


@end
