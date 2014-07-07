//
//  BNVisitCondition.h
//  fxtx
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNVisitCondition : NSObject
/**
 * 拜访情况编码
 */
@property (nonatomic,weak)      NSString* CONDITION_CODE;
/**
 * 拜访情况值
 */
@property (nonatomic,weak)      NSString* CONDITION_NAME;
@end
