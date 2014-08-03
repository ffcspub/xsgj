//
//  ProductDelView.m
//  xsgj
//
//  Created by chenzf on 14-8-3.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ProductDelView.h"

@implementation ProductDelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)handleDel:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnDelClicked:)])
    {
        [self.delegate onBtnDelClicked:self];
    }
}

@end
