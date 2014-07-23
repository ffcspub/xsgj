//
//  KcPreviewViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-20.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "PreviweDetailCell.h"
#import "PreviewNameCell.h"

@interface KcPreviewViewController : HideTabViewController

@property (weak, nonatomic) IBOutlet UIScrollView *svMainContain;
@property (weak, nonatomic) IBOutlet UIScrollView *svSubContain;
@property (weak, nonatomic) IBOutlet UITableView *tvTypeName;
@property (weak, nonatomic) IBOutlet UITableView *tvDetail;
@property (weak, nonatomic) NSArray *aryData;



@end
