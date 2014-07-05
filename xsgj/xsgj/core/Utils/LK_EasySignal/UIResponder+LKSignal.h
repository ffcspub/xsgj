//
//  UIResponder+EasySignal.h
//  LK_EasySignal
//
//  Created by hesh on 13-9-3.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LKSignal;

#undef	ON_LKSIGNAL
#define ON_LKSIGNAL( __signal ) \
- (void)handleLKSignal:(LKSignal *)__signal

#undef	ON_LKSIGNAL2
#define ON_LKSIGNAL2( __filter, __signal ) \
- (void)handleLKSignal_##__filter:(LKSignal *)__signal

#undef	ON_LKSIGNAL3
#define ON_LKSIGNAL3( __class, __signalName, __signal ) \
- (void)handleLKSignal_##__class##_##__signalName:(LKSignal *)__signal

#undef	ON_LKSIGNAL4
#define ON_LKSIGNAL4( __class, __tag, __signal ) \
- (void)handleLKSignal_##__class##_TAG##__tag:(LKSignal *)__signal

#undef	ON_LKSIGNAL5
#define ON_LKSIGNAL5( __class, __signalName,__tagString, __signal ) \
- (void)handleLKSignal_##__class##_##__signalName##_##__tagString:(LKSignal *)__signal

#undef	ON_LKSIGNAL6
#define ON_LKSIGNAL6( __class, __signalName,__tag, __signal ) \
- (void)handleLKSignal_##__class##_##__signalName##_TAG##__tag:(LKSignal *)__signal

@interface UIResponder(LK_EasySignal)

@property(nonatomic,strong) NSString *tagString;

@property(nonatomic,strong) NSObject *object;

-(void)sendSignal:(LKSignal *)signal;

-(void)sendSignal;

-(void)sendSignalName:(NSString *)signalName;

-(void)sendSignalObject:(NSString *)object;

-(void)sendSignalTag:(int)tag;

-(void)sendSignalName:(NSString *)signalName object:(NSObject *)object;

-(void)sendSignalObject:(NSObject *)object tag:(int)tag;

-(void)sendSignalName:(NSString *)signalName object:(NSObject *)object tag:(int)tag;

-(void)handleLKSignal:(LKSignal *)signal;

-(NSString *)className;

-(NSString *)signalName;

@end





