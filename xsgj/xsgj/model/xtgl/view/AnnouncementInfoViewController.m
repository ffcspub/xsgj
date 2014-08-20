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
#import <AFNetworking.h>
#import "FileViewVCL.h"

@interface MYProgressView : UIView{
    UIView *_progressView;
    UILabel *lb_success;
}

@property(nonatomic,assign) CGFloat progress;

@end

@implementation MYProgressView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor grayColor].CGColor;
        lb_success = [[UILabel alloc]initWithFrame:self.bounds];
        lb_success.font = [UIFont systemFontOfSize:13];
        lb_success.textColor = MCOLOR_GREEN;
        lb_success.text = @"未下载";
        lb_success.backgroundColor = [UIColor clearColor];
        [self addSubview:lb_success];
        _progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.frame))];
        _progressView.backgroundColor = MCOLOR_GREEN;
        _progressView.hidden = NO;
        [self addSubview:_progressView];
    }
    return self;
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (progress == 1) {
        self.layer.borderWidth = 0;
        lb_success.text = @"下载完成";
        lb_success.hidden = NO;
        [_progressView setHidden:YES];
        return;
    }
    if (progress == 0) {
        self.layer.borderWidth = 0;
        lb_success.text = @"未下载";
        lb_success.hidden = NO;
        [_progressView setHidden:YES];
    }else{
        self.layer.borderWidth = 0.7;
        [_progressView setHidden:NO];
    }
    NSLog(@"%f",progress);
    CGRect rect = _progressView.frame;
    CGFloat width = (CGRectGetWidth(self.frame) * progress);
    rect.size.width = width;
    _progressView.frame = rect;
}

@end

@interface AnnouncementInfoViewController (){
    NoticeDetailBean *_noticeDetail;
    NSMutableArray *_btns;
    NSMutableArray *_progressViews;
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
    
    _btns = [[NSMutableArray alloc]init];
    _progressViews = [[NSMutableArray alloc]init];
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
    lb_topic.font = [UIFont systemFontOfSize:19];
    lb_topic.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:lb_topic];
    
    NSDate *beginTime = [NSDate dateFromString:_noticeDetail.BEGIN_TIME withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [NSDate stringFromDate:beginTime withFormat:@"yyyy-MM-dd"];
    
    UILabel *lb_time = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lb_topic.frame), 250, 25)];
    lb_time.text = [NSString stringWithFormat:@"root  %@",time];
    lb_time.textColor = [UIColor grayColor];
    lb_time.font = [UIFont systemFontOfSize:16];
    lb_time.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:lb_time];
    
    CGFloat originY = CGRectGetMaxY(lb_time.frame) + 10;
    int i = 0;
    for (NoticeAttmentBean *noticeAttment in _noticeDetail.attmentlist) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(25, originY, 200, 25)];
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.tag = i;
        [btn addTarget:self action:@selector(downloadFile:) forControlEvents:UIControlEventTouchUpInside];
        if ([[noticeAttment.file_name pathExtension] isEqualToString:@"doc"] || [[noticeAttment.file_name pathExtension] isEqualToString:@"docx"]) {
            [btn setImage:[UIImage imageNamed:@"favoritesdoc_pic"] forState:UIControlStateNormal];
        } else if ([[noticeAttment.file_name pathExtension] isEqualToString:@"pdf"]) {
            [btn setImage:[UIImage imageNamed:@"favoritespdf_pic"] forState:UIControlStateNormal];
        } else {
            [btn setImage:[UIImage imageNamed:@"favoritesnote_pic"] forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setTitle:noticeAttment.file_name forState:UIControlStateNormal];
        MYProgressView *progressView = [[MYProgressView alloc]initWithFrame:CGRectMake(240, originY + 2.5, 70, 20)];
        [self.scrollView addSubview:btn];
        [self.scrollView addSubview:progressView];
        originY = CGRectGetMaxY(btn.frame) + 10;
        [_btns addObject:btn];
        [_progressViews addObject:progressView];
        // 指定文件保存路径，将文件保存在沙盒中
        NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // 指定文件保存路径，将文件保存在沙盒中
        NSString *path = [docs[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",noticeAttment.file_id,[noticeAttment.file_name pathExtension]]];
        if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
            progressView.progress = 1.0;
        }
        i++;
    }
    UILabel *lb_content = [[UILabel alloc] initWithFrame:CGRectMake(25, originY, 270, 25)];
    lb_content.text = _noticeDetail.CONTENT;
    lb_content.font = [UIFont systemFontOfSize:16];
    lb_content.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:lb_content];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(lb_content.frame) + 10);
}


-(void)downloadFile:(UIButton *)btn{
    int index = btn.tag;
    NoticeAttmentBean *noticeAttment = [_noticeDetail.attmentlist objectAtIndex:index];
    // 下载
    // 指定文件保存路径，将文件保存在沙盒中
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 指定文件保存路径，将文件保存在沙盒中
    NSString *path = [docs[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",noticeAttment.file_id,[noticeAttment.file_name pathExtension]]];
    NSString *temppath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",noticeAttment.file_id,[noticeAttment.file_name pathExtension]]];
     NSLog(@"%@",temppath);
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        FileViewVCL *vlc = [[FileViewVCL alloc]init];
        vlc.fileUrl = [[NSURL alloc]initFileURLWithPath:path];
        vlc.title = noticeAttment.file_name;
        [self.navigationController pushViewController:vlc animated:YES];
        return;
    }
    long long downloadedBytes = [self fileSizeForPath:temppath];
    if (noticeAttment.file_id) {
        NSString *fileUrl = [ShareValue getFileUrlByFileId:noticeAttment.file_id];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:fileUrl]];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.outputStream = [NSOutputStream outputStreamToFileAtPath:temppath append:NO];
        [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%lld,===%lld",totalBytesRead,totalBytesExpectedToRead);
                MYProgressView *progressView = [_progressViews objectAtIndex:index];
                 float progress = ((float)totalBytesRead + downloadedBytes) / (totalBytesExpectedToRead + downloadedBytes);
                [progressView setProgress:progress];
            });
        }];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [btn setEnabled:YES];
            MYProgressView *progressView = [_progressViews objectAtIndex:index];
            [progressView setProgress:1.0];
            NSError *erro = nil;
            [[NSFileManager defaultManager]copyItemAtPath:temppath toPath:path error:&erro];
            if (erro) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无法完成下载请确定是否有足够的剩余空间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [btn setEnabled:YES];
        }];
        [op start];
        UIButton *btn = [_btns objectAtIndex:index];
        [btn setEnabled:NO];
    }
}


//获取已下载的文件大小
- (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
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
