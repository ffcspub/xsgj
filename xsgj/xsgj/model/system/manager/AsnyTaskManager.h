//
//  AsnyTaskManager.h
//  xsgj
//
//  Created by ilikeido on 14-7-25.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsnyTaskManager : NSObject

+(AsnyTaskManager *)shareInstance;

-(void)loadConfig;

-(void)startTask;

-(void)stopTask;

@end
