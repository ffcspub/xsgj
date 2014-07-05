//
//  MJPhotoLoadingView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoLoadingView.h"
#import "MJPhotoBrowser.h"
#import <QuartzCore/QuartzCore.h>
#import "MJPhotoProgressView.h"

@interface MJPhotoLoadingView ()
{
    UILabel *_failureLabel;
    MJPhotoProgressView *_progressView;
    
    UIImageView *_failImageView;
    UIImageView *_loadingImageView;
    UILabel *_loadingLabel;
    double _diAngle;
}

@end

@implementation MJPhotoLoadingView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[UIScreen mainScreen].bounds];
    self.backgroundColor = [UIColor blackColor];
    self.bAnimation = NO;
    _diAngle = 0;
}

- (void)showFailure
{
//    [_progressView removeFromSuperview];
    
//    if (_failureLabel == nil) {
//        _failureLabel = [[UILabel alloc] init];
//        _failureLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, 44);
//        _failureLabel.textAlignment = NSTextAlignmentCenter;
//        _failureLabel.center = self.center;
//        _failureLabel.text = @"网络不给力，图片下载失败";
//        _failureLabel.font = [UIFont boldSystemFontOfSize:20];
//        _failureLabel.textColor = [UIColor whiteColor];
//        _failureLabel.backgroundColor = [UIColor clearColor];
//        _failureLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    }
//    [self addSubview:_failureLabel];
    
    // modify by chenzf 20140624
    self.bAnimation = NO;
    [_loadingImageView removeFromSuperview];
    [_loadingLabel removeFromSuperview];
    if(_failImageView == nil){
        _failImageView = [[UIImageView alloc] init];
        _failImageView.bounds = CGRectMake(0, 0, 90, 109);
        _failImageView.center = self.center;
        _failImageView.image = [UIImage imageNamed:@"icon_loadfail"];
    }
    [self addSubview:_failImageView];
}

- (void)showLoading
{
//    [_failureLabel removeFromSuperview];
//    
//    if (_progressView == nil) {
//        _progressView = [[MJPhotoProgressView alloc] init];
//        _progressView.bounds = CGRectMake( 0, 0, 60, 60);
//        _progressView.center = self.center;
//    }
//    _progressView.progress = kMinProgress;
//    [self addSubview:_progressView];
    
    // modify by chenzf 20140625
    [_failImageView removeFromSuperview];
    if(_loadingImageView == nil){
        _loadingImageView = [[UIImageView alloc] init];
        _loadingImageView.bounds = CGRectMake(0, 0, 73, 73);
        _loadingImageView.center = CGPointMake(self.center.x, self.center.y - 30);
        _loadingImageView.image = [UIImage imageNamed:@"icon_imageloading"];
    }
    [self addSubview:_loadingImageView];
    self.bAnimation = YES;
    _diAngle = 0;
    [self startRotationAnimation:_loadingImageView];
    
    if (_loadingLabel == nil) {
        _loadingLabel = [[UILabel alloc] init];
        _loadingLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, 44);
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        _loadingLabel.center = CGPointMake(self.center.x, self.center.y + 30);
        _loadingLabel.text = @"图片加载中...";
        _loadingLabel.font = [UIFont boldSystemFontOfSize:14];
        _loadingLabel.textColor = [UIColor lightGrayColor];
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    [self addSubview:_loadingLabel];

}

#pragma mark - customlize method
- (void)setProgress:(float)progress
{
    _progress = progress;
    _progressView.progress = progress;
    if (progress >= 1.0) {
        [_progressView removeFromSuperview];
    }
}

// start rotation animation
- (void)startRotationAnimation:(UIImageView *)imageView
{
    
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(_diAngle * (M_PI / 180.0f));
    [UIView animateWithDuration:0.01f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.transform = rotationTransform;
    } completion:^(BOOL finished) {
        if(self.bAnimation)
        {
            _diAngle += 2;
            [self startRotationAnimation:imageView];
        }
        else
        {
            _diAngle = 0;
            [imageView stopAnimating];
        }
    }];
    
}

@end
