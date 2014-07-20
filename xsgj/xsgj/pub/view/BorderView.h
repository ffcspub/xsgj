//
//  BorderView.h
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, BorderViewStyle) {
    BorderViewStyleGroupTop = 1,
    BorderViewStyleGroupMiddle,
    BorderViewStyleGroupBottom,
    BorderViewStyleGroupSingle,
    
    BorderViewStyleRoundCorner,
    BorderViewStyleMutableColumn, // 多行文本框背景，左侧有两个分割线
    BorderViewStyleMutableColumn1 // 多行文本框背景，顶部有两个分割线
};

/**
 *  带有边框的视图
 */
@interface BorderView : UIView

@property (nonatomic, assign) BorderViewStyle borderStyle;

@end
