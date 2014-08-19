//
//  HideTabViewController.h
//  yikezhong
//
//  Created by hesh on 14-1-15.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HideTabViewController : UIViewController

-(UIButton *)titleButton;

-(UIButton *)defaultRightButtonWithTitle:(NSString *)title;

-(void)setLeftButtonTitle:(NSString *)title;

/**
 *  用于查询类显示"没有数据"
 */
-(void)showNoDataLabel;
-(void)hideNODataLabel;

@end
