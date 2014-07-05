//
//  LKSignal.h
//  LK_EasySignal
//
//  Created by hesh on 13-9-3.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKSignal : NSObject

@property(nonatomic,weak) UIResponder *sender;

@property(nonatomic,weak) UIResponder *firstRouter;

@property(nonatomic,weak) UIResponder *currentRouter;

@property(nonatomic,weak) NSObject *object;

@property(nonatomic,weak) NSString *signalName;

@property(nonatomic,weak) NSString *preName;

@property(nonatomic,assign) int tag;

@property(nonatomic,weak) NSString *tagString;

-(BOOL)is:(NSString *)signalName;

-(id)initWithSender:(UIResponder *)sender firstRouter:(UIResponder *)firstRouter object:(NSObject *)object signalName:(NSString *)signalName tag:(int)tag tagString:(NSString *)tagString;

@end
