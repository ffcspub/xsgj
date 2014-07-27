//
//  BorderButton.m
//  xsgj
//
//  Created by xujunwen on 14-7-26.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "BorderButton.h"

@interface BorderButton ()
{
    UIImageView *_backgroundView;
    UILabel *_lblTitle;
}

@property (nonatomic, strong) UILabel *lblTitle;

- (void)_initialize;

@end

@implementation BorderButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self _initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    if (!_backgroundView) {

        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.image = [[UIImage imageNamed:@"normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)];
        _backgroundView.highlightedImage = [[UIImage imageNamed:@"press"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 20, 30)];
        [self insertSubview:_backgroundView atIndex:0];
    }
    
    if (!_lblTitle) {
        
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 80.f, 40.f)];
        _lblTitle.font = [UIFont systemFontOfSize:FONT_SIZE_INPUT_TITLE];
        _lblTitle.textColor = COLOR_INPUT_TITLE;
        _lblTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:_lblTitle];
    }
}

+ (BorderButton *)buttonWithTitle:(NSString *)title;
{
    BorderButton *btn = [self buttonWithType:UIButtonTypeCustom];
    btn.leftTitle = title;
    return btn;
}

#pragma mark - 访问器

- (void)setBackgroundView:(UIImageView *)backgroundView
{
    [_backgroundView removeFromSuperview];
    _backgroundView = backgroundView;
    if(_backgroundView){
        [self insertSubview:_backgroundView atIndex:0];
        [self setNeedsLayout];
    }
}

- (void)setLeftTitle:(NSString *)title
{
    if (![_leftTitle isEqualToString:title]) {
        _leftTitle = title;
        _lblTitle.text = _leftTitle;
    }
}

#pragma mark - Override

- (void)setSelected:(BOOL)select
{
    [super setSelected:select];

    [_backgroundView setHighlighted:select||self.highlighted];
}

- (void)setHighlighted:(BOOL)highl
{
    [super setHighlighted:highl];

    [_backgroundView setHighlighted:highl||self.selected];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lblTitle.frame = CGRectMake(10.f, 0.f, 80.f, 40.f);
    self.backgroundView.frame = self.bounds;
}

@end
