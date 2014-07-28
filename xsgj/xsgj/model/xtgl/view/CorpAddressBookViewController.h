//
//  CorpAddressBookViewController.h
//  xsgj
//
//  Created by linw on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabViewController.h"

@interface CorpAddressBookViewController : HideTabViewController

@property (weak, nonatomic) IBOutlet UISearchBar *schBar;
@property (weak, nonatomic) IBOutlet UITableView *tabContact;

@end
