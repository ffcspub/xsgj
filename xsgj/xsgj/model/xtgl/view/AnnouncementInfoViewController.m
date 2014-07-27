//
//  AnnouncementInfoViewController.m
//  xsgj
//
//  Created by Geory on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "AnnouncementInfoViewController.h"
#import "XTGLAPI.h"
#import "MBProgressHUD+Add.h"
#import "NoticeInfoBean.h"
#import "NoticeDetailBean.h"
#import <NSDate+Helper.h>
#import "NoticeAttmentBean.h"

@interface AnnouncementInfoViewController (){
    NoticeDetailBean *_noticeDetail;
}

@end

@implementation AnnouncementInfoViewController

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
    
    self.title = @"公告详情";
    
    [self noticeDetailRequest];
    
    self.scrollView.backgroundColor = HEX_RGB(0xefeff4);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    UILabel *lb_topic = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 300, 30)];
    lb_topic.text = _noticeDetail.TOPIC;
    lb_topic.font = [UIFont boldSystemFontOfSize:19];
    lb_topic.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:lb_topic];
    
    NSDate *beginTime = [NSDate dateFromString:_noticeDetail.BEGIN_TIME withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [NSDate stringFromDate:beginTime withFormat:@"yyyy-MM-dd"];
    
    UILabel *lb_time = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lb_topic.frame), 290, 25)];
    lb_time.text = [NSString stringWithFormat:@"root  %@",time];
    lb_time.textColor = [UIColor grayColor];
    lb_time.font = [UIFont systemFontOfSize:16];
    lb_time.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:lb_time];
    
    CGFloat originY = CGRectGetMaxY(lb_time.frame) + 10;
    
    for (NoticeAttmentBean *noticeAttment in _noticeDetail.attmentlist) {
        UIImageView *iv_icon = [[UIImageView alloc] initWithFrame:CGRectMake(25, originY, 25, 25)];
        if ([[noticeAttment.file_name pathExtension] isEqualToString:@"doc"] || [[noticeAttment.file_name pathExtension] isEqualToString:@"docx"]) {
            iv_icon.image = [UIImage imageNamed:@"favoritesdoc_pic"];
        } else if ([[noticeAttment.file_name pathExtension] isEqualToString:@"pdf"]) {
            iv_icon.image = [UIImage imageNamed:@"favoritespdf_pic"];
        } else {
            iv_icon.image = [UIImage imageNamed:@"favoritesnote_pic"];
        }
        [self.scrollView addSubview:iv_icon];
        
        UILabel *lb_file = [[UILabel alloc] initWithFrame:CGRectMake(60, originY, 240, 25)];
        lb_file.text = noticeAttment.file_name;
        lb_file.font = [UIFont systemFontOfSize:16];
        lb_file.lineBreakMode = NSLineBreakByTruncatingMiddle;
        lb_file.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:lb_file];
        
        originY = CGRectGetMaxY(lb_file.frame) + 10;
    }
    
    UILabel *lb_content = [[UILabel alloc] initWithFrame:CGRectMake(25, originY, 270, 25)];
    lb_content.text = _noticeDetail.CONTENT;
    lb_content.font = [UIFont systemFontOfSize:16];
    lb_content.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:lb_content];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(lb_content.frame) + 10);
}

#pragma mark - private

- (void)noticeDetailRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NoticeDetailHttpRequest *request = [[NoticeDetailHttpRequest alloc] init];
    request.NOTICE_ID = _noticeInfo.NOTICE_ID;
    
    [XTGLAPI noticeDetailByRequest:request success:^(NoticeDetailHttpResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([response.DATA count] > 0) {
            _noticeDetail = [response.DATA objectAtIndex:0];
            
            [self setup];
        }
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

@end
