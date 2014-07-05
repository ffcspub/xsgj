//
//  UIControl+LKSignal.m
//  LK_EasySignal
//
//  Created by hesh on 13-9-4.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "UIControl+LKSignal.h"
#import <objc/runtime.h>
#import "LKSignal.h"
#import "UI+LKSignal.h"
#import "UIResponder+LKSignal.h"


@interface LKActionWrapper : NSObject

@property (nonatomic, copy) LKActionBlock actionBlock;
@property (nonatomic, assign) UIControlEvents controlEvents;

- (void)invokeBlock:(id)sender;

@end

@implementation LKActionWrapper

-(void)invokeBlock:(id)sender{
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}

@end


@implementation UIControl (LK_EasySignal_Private)

static NSString *const LKActionBlocksArray = @"LKActionBlocksArray";

- (void)handleControlEvents:(UIControlEvents)controlEvents withBlock:(LKActionBlock)actionBlock {
    NSMutableArray *actionBlocksArray = [self actionBlocksArray];
    LKActionWrapper *wrapper = [[LKActionWrapper alloc]init];
    wrapper.actionBlock = actionBlock;
    wrapper.controlEvents = controlEvents;
    [actionBlocksArray addObject:wrapper];
    [self addTarget:wrapper action:@selector(invokeBlock:) forControlEvents:controlEvents];
}


- (void)removeActionBlocksForControlEvents:(UIControlEvents)controlEvents {
    NSMutableArray *actionBlocksArray = [self actionBlocksArray];
    NSMutableArray *wrappersToRemove = [NSMutableArray arrayWithCapacity:[actionBlocksArray count]];
    
    [actionBlocksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LKActionWrapper *wrapperTmp = obj;
        if (wrapperTmp.controlEvents == controlEvents) {
            [wrappersToRemove addObject:wrapperTmp];
            [self removeTarget:wrapperTmp action:@selector(invokeBlock:) forControlEvents:controlEvents];
        }
    }];
    
    [actionBlocksArray removeObjectsInArray:wrappersToRemove];
}


- (NSMutableArray *)actionBlocksArray {
    NSMutableArray *actionBlocksArray = objc_getAssociatedObject(self, &LKActionBlocksArray);
    if (!actionBlocksArray) {
        actionBlocksArray = [NSMutableArray array];
        objc_setAssociatedObject(self, &LKActionBlocksArray, actionBlocksArray, OBJC_ASSOCIATION_RETAIN);
    }
    return actionBlocksArray;
}

@end

@interface UIControl (LK_EasySignal)

@end

@implementation UIControl (LK_EasySignal)

-(NSString *)className;{
    const char *name =  class_getName([self class]);
    return [NSString stringWithUTF8String:name];
}

-(void)addEventsSignal{
    if ([self isKindOfClass:[UIButton class]]) {
        if ([[self className] isEqual:@"UIAlertButton"]) {
            
        }else if ([[self className] isEqual:@"UIRoundedRectButton"]) {
            [self handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
                LKSignal *signal = [[LKSignal alloc]initWithSender:self firstRouter:self object:nil signalName:UIButton.UPINSIDE tag:0 tagString:nil];
                signal.preName = @"UIButton";
                [self sendSignal:signal];
            }];
        }else{
            [self handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
                [self sendSignalName:UIButton.UPINSIDE];
            }];
        }
    }else if ([self isKindOfClass:[UISlider class]]) {
        [self handleControlEvents:UIControlEventValueChanged withBlock:^(id weakSender) {
            [self sendSignalName:UISlider.VALUECHANGE];
        }];
    }else if ([self isKindOfClass:[UISlider class]]) {
        [self handleControlEvents:UIControlEventValueChanged withBlock:^(id weakSender) {
            [self sendSignalName:UISlider.VALUECHANGE];
        }];
    }else if ([self isKindOfClass:[UISwitch class]]) {
        [self handleControlEvents:UIControlEventValueChanged withBlock:^(id weakSender) {
            [self sendSignalName:UISwitch.VALUECHANGE];
        }];
    }
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self addEventsSignal];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addEventsSignal];
    }
    return self;
}

-(id)init{
    if (self = [super init]) {
        [self addEventsSignal];
    }
    return self;
}
@end

