//
//  CusVisitCell.h
//  xsgj
//
//  Created by chenzf on 14-7-16.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNMobileMenu.h"

@interface CusVisitCell : UITableViewCell{
    int _syncState;
}

@property (weak, nonatomic) IBOutlet UIImageView *ivStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) BNMobileMenu *mobileMenu;

-(void)setSyncState:(int)syncState;

@end
