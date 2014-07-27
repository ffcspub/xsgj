//
//  AnnouncementInfoViewController.h
//  xsgj
//
//  Created by Geory on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"

@class NoticeInfoBean;

@interface AnnouncementInfoViewController : HideTabViewController

@property (nonatomic, strong) NoticeInfoBean *noticeInfo;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
