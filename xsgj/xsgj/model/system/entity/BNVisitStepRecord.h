//
//  BNVisitStepRecord.h
//  fxtx
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNVisitStepRecord : NSObject

@property (nonatomic,strong)     NSString* VISIT_NO;
@property (nonatomic,assign)    int OPER_MENU;
@property (nonatomic,assign)    int OPER_NUM;//操作次数
@property (nonatomic,assign)    int SYNC_STATE; //0初始  1 上报中   2 已上报

-(void)save;

@end
