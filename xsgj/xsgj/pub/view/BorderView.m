//
//  BorderView.m
//  xsgj
//
//  Created by xujunwen on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "BorderView.h"
#import "NSString+URL.h"

@interface BorderView ()

- (void)_initialize;

@property (nonatomic, strong) UIImageView *ivBackground;

@end

@implementation BorderView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
    
	return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
	[self _initialize];
}

#pragma mark - Private

- (void)_initialize
{
    self.imgBorder = @"日期选择控件背板"; // 默认为圆角边框
    
	UIImageView *ivBackground = [[UIImageView alloc] initWithFrame:self.bounds];
    ivBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIImage *imgOrigin = [UIImage imageNamed:self.imgBorder];
    CGFloat h = imgOrigin.size.width / 2;
    CGFloat v = imgOrigin.size.height / 2;
    ivBackground.image = [imgOrigin resizableImageWithCapInsets:UIEdgeInsetsMake(v, h, v, h)];
    [self addSubview:ivBackground];
    [self sendSubviewToBack:ivBackground];
    
    self.ivBackground = ivBackground;
}

#pragma mark - 访问器

- (void)setImgBorder:(NSString *)image
{
    if (![image isEmptyOrWhitespace] && ![_imgBorder isEqualToString:image]) {
        _imgBorder = image;
        
        UIImage *imgOrigin = [UIImage imageNamed:image];
        CGFloat h = imgOrigin.size.width / 2;
        CGFloat v = imgOrigin.size.height / 2;
        self.ivBackground.image = [imgOrigin resizableImageWithCapInsets:UIEdgeInsetsMake(v, h, v, h)];
        
        [self setNeedsLayout];
    }
}

@end
