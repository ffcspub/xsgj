//
//  UILKSignal.h
//  LK_EasySignal
//
//  Created by hesh on 13-9-4.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIButton (LK_EasySignal)

+(NSString *)UPINSIDE;

@end

@interface UIView (LK_EasySignal)

@property(nonatomic,assign) BOOL tapable;
+(NSString *)TAPED;

@end

@interface UISlider(LK_EasySignal)

+(NSString *)VALUECHANGE;

@end

@interface UISwitch (LK_EasySignal)

+(NSString *)VALUECHANGE;

@end

@interface UIAlertView (LK_EasySignal)

-(void)showInView:(UIView *)view cancelSignalObject:(NSObject *)cancelSignalObject sumbitSignalObject:(NSObject *)sumbitSignalObject;

+(NSString *)CANCEL;

+(NSString *)SUMBIT;

@end

@interface UIActionSheet (LK_EasySignal)

+(NSString *)CLICKED;

-(void)setSignalObject:(NSObject *)object index:(int)index;

-(void)addButtonWithTitle:(NSString *)title signalObject:(NSObject *)object;

-(void)showSheetInView:(UIView *)view;

@end


@interface UITextField (LK_EasySignal)

@property(nonatomic,assign) int maxLength;

+(NSString *)BEGIN_EDITING;

+(NSString *)RETURN;

+(NSString *)TEXTCHANGED;

@end


@interface UITextView  (LK_EasySignal)

@property(nonatomic,strong) NSString *placeHolder;
@property(nonatomic,assign) int maxLength;

+(NSString *)BEGIN_EDITING;

+(NSString *)RETURN;

+(NSString *)TEXTCHANGED;

@end

@interface UIDatePicker (LK_EasySignal)

-(void)showTitle:(NSString *)title inView:(UIView *)view;

+(NSString *)DATECHANGED;

+(NSString *)COMFIRM;

@end

@interface UIPickerView (LK_EasySignal)

-(void)showTitle:(NSString *)title inView:(UIView *)view;

+(NSString *)COMFIRM;

@end

