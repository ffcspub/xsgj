//
//  LKSignal.m
//  LK_EasySignal
//
//  Created by hesh on 13-9-3.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "LKSignal.h"
#import <objc/runtime.h>
#import "UIResponder+LKSignal.h"

@implementation LKSignal

-(BOOL)is:(NSString *)signalName;{
    NSArray *array = [signalName componentsSeparatedByString:@"."];
    if (array.count == 2) {
        NSString *className = [array objectAtIndex:0];
        Class class = NSClassFromString(className);
        if (class) {
            return [_sender isKindOfClass:class];
        }
    }
    return [self.signalName isEqual:signalName];
}

-(id)initWithSender:(UIResponder *)sender firstRouter:(UIResponder *)firstRouter object:(NSObject *)object signalName:(NSString *)signalName tag:(int)tag tagString:(NSString *)tagString;{
    if (self = [super init]) {
        self.sender = sender;
        self.firstRouter = firstRouter;
        self.currentRouter = firstRouter;
        self.object = object;
        self.signalName = signalName;
        self.tag = tag;
        self.tagString = tagString;
    }
    return self;
}

@end
