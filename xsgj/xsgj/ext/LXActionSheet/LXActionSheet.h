//
//  LXActionSheet.h
//  LXActionSheetDemo
//
//  Created by lixiang on 14-3-10.
//  Copyright (c) 2014年 lcolco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXActionSheetDelegate;
@interface LXActionSheet : UIView
- (id)initWithTitle:(NSString *)title delegate:(id<LXActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void)showInView:(UIView *)view;

-(void)setCancelButtonColor:(UIColor *)buttonColor titleColor:(UIColor *)titleColor  icon:(UIImage *)image;

-(void)setdestructiveButtonColor:(UIColor *)buttonColor titleColor:(UIColor *)titleColor  icon:(UIImage *)image;

-(void)setButtonIndex:(NSInteger)index buttonColor:(UIColor *)buttonColor titleColor:(UIColor *)titleColor icon:(UIImage *)image;

@end

@protocol LXActionSheetDelegate <NSObject>
// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)lxactionSheet:(LXActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@optional
- (void)lxactionSheetDestructive:(LXActionSheet *)actionSheet;
- (void)lxactionSheetCancel:(LXActionSheet *)actionSheet;
@end