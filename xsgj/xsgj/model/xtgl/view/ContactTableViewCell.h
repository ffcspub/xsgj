//
//  ContactTableViewCell.h
//  xsgj
//
//  Created by linw on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIButton *btnMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnDail;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;

@end
