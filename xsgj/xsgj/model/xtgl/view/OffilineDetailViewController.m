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
#import <NSDate+Helper.h>

@interface OffilineDetailViewController (){
    
    __weak IBOutlet UILabel *lb_title;
    
    __weak IBOutlet UILabel *lb_state;
    
    __weak IBOutlet UILabel *lb_creattime;
    
    __weak IBOutlet UILabel *lb_trytime;
    
    __weak IBOutlet UILabel *lb_lasttime;
    
    __weak IBOutlet UILabel *lb_lastnet;
    
    __weak IBOutlet UIButton *btn_update;

    __weak IBOutlet UILabel *lb_error;
    
    __weak IBOutlet UIView *vi_error;
    
    __weak IBOutlet UIView *vi_content;
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
    [self upUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)upUI{
    lb_title.text = _cache.name;
    if (_cache.updateCount > 0) {
        lb_state.text = @"上报失败";
    }else{
        lb_state.text = @"等待上报";
    }
    lb_creattime.text = _cache.time;
    lb_error.text = _cache.errorDescript;
    lb_trytime.text = [NSString stringWithFormat:@"%d次",_cache.updateCount];
    if (_cache.updateCount > 0) {
        NSDate *date = [NSDate dateFromString:_cache.datetime withFormat:@"yyyyMMddHHmmss"];
        lb_lasttime.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        lb_lastnet.text = _cache.netstate==1?@"有网络":@"无网络";
        if (_cache.netstate==1) {
            CGRect rect = vi_content.frame;
            rect.size.height = 273.0;
            vi_content.frame = rect;
            return;
        }
    }
    CGRect rect = vi_content.frame;
    rect.size.height = 232.0;
    vi_content.frame = rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
   MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在提交" toView:ShareAppDelegate.window];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        BOOL flag = [[OfflineAPI shareInstance]sendOfflineRequest:_cache];
        if (flag) {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"上传成功";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [MBProgressHUD showError:@"上传失败" toView:ShareAppDelegate.window];
                btn.enabled = YES;
                _cache = [OfflineRequestCache searchSingleWithWhere:[NSString stringWithFormat:@"rowid=%d",_cache.rowid ] orderBy:nil];
                [self upUI];
            });
            
        }
    });
    
    
}



@end
