//
//  DhPreviewViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-24.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "PreviewNameCell.h"
#import "DhPreviweDetailCell.h"

@interface DhPreviewViewController : HideTabViewController

@property (weak, nonatomic) IBOutlet UIScrollView *svMainContain;
@property (weak, nonatomic) IBOutlet UIScrollView *svSubContain;
@property (weak, nonatomic) IBOutlet UITableView *tvTypeName;
@property (weak, nonatomic) IBOutlet UITableView *tvDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbCooperation;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) NSArray *aryData;

@end

