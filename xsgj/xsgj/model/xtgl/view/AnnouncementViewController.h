//
//  AnnouncementViewController.h
//  xsgj
//
//  Created by Geory on 14-7-25.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HideTabViewController.h"
#import "LeveyPopListView.h"

@interface AnnouncementViewController : HideTabViewController<LeveyPopListViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_starttime;
@property (weak, nonatomic) IBOutlet UIButton *btn_endtime;
@property (weak, nonatomic) IBOutlet UIButton *btn_announceType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)selectBeginTimeAction:(id)sender;
- (IBAction)selectEndTimeAction:(id)sender;
- (IBAction)selectAnnounceTypeAction:(id)sender;

@end
