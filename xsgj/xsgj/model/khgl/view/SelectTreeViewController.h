//
//  SelectTreeViewController.h
//  xsgj
//
//  Created by chenzf on 14-7-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"
#import "RATreeView.h"
#import "TreeViewCell.h"


@interface SelectTreeViewController : HideTabViewController<RATreeViewDelegate, RATreeViewDataSource,TreeViewCellDelegate>

@property (strong, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSMutableArray *aryExpanded;
@property (weak, nonatomic) NSString *strSelect;
@property (weak, nonatomic) id selectInfo;

@end
