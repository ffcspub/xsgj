//
//  OffilineDetailViewController.m
//  xsgj
//
//  Created by mac on 14-8-26.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "OffilineDetailViewController.h"
#import "OfflineAPI.h"
#import "MBProgressHUD+Add.h"

@interface OffilineDetailViewController (){
    
    __weak IBOutlet UILabel *lb_title;
    
    __weak IBOutlet UILabel *lb_state;
    
    __weak IBOutlet UILabel *lb_creattime;
    
    __weak IBOutlet UILabel *lb_trytime;
    
    __weak IBOutlet UILabel *lb_lasttime;
    
    __weak IBOutlet UILabel *lb_lastnet;
    
    __weak IBOutlet UIButton *btn_update;

}

@end

@implementation OffilineDetailViewController

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
    [btn_update configBlueStyle];
    lb_title.text = _cache.name;
    if (_cache.updateCount > 0) {
        lb_state.text = @"上报失败";
    }else{
        lb_state.text = @"等待上报";
    }
    lb_creattime.text = _cache.time;
    lb_trytime.text = [NSString stringWithFormat:@"%d次",_cache.updateCount];
    if (_cache.updateCount > 0) {
        lb_lasttime.text = _cache.datetime;
        lb_lastnet.text = @"有网络";
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadAction:(id)sender {
    [MBProgressHUD showMessag:@"正在提交" toView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        BOOL flag = [[OfflineAPI shareInstance]sendOfflineRequest:_cache];
        if (flag) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:@"上传失败" toView:self.view];
        }
    });
    
    
}



@end
