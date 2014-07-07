//
//  BNMessage.h
//  结果信息
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNMessage : NSObject
// 结果编码
@property (nonatomic,weak) NSString* MESSAGECODE;
// 结果信息
@property (nonatomic,weak) NSString* MESSAGECONTENT;
@end
