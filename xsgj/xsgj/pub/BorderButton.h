//
//  BorderButton.h
//  xsgj
//
//  Created by xujunwen on 14-7-26.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorderButton : UIButton

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) NSString *leftTitle;

+ (BorderButton *)buttonWithTitle:(NSString *)title;

@end
