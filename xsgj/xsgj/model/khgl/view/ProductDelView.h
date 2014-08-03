//
//  ProductDelView.h
//  xsgj
//
//  Created by chenzf on 14-8-3.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNProduct.h"

@protocol ProductDelViewDelegate;

@interface ProductDelView : UIView

@property (weak, nonatomic) id<ProductDelViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) BNProduct *productData;

- (IBAction)handleDel:(id)sender;

@end

@protocol ProductDelViewDelegate <NSObject>

- (void)onBtnDelClicked:(ProductDelView *)view;

@end
