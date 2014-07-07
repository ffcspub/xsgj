//
//  BNAssetType.h
//  fxtx
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNAssetType : NSObject
/** 类别ID */
@property (nonatomic,assign)    int TYPE_ID;
/** 类别名称 */
@property (nonatomic,weak)      NSString* TYPE_NAME;
@end
