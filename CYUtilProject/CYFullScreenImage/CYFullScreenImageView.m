//
//  CYFullScreenImageView.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/4/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYFullScreenImageView.h"

#import "UIImageView+CYWebImageCache.h"

#define CY_FULL_SCREEN_IMAGE_VIEW_ZOOM_TAG      4729

@interface CYFullScreenImageView ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, assign) CGRect showRect;

@end

@implementation CYFullScreenImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _dismissOnTap = YES;
        _zoomingEnabled = YES;
        
        [self createFullScreenImageSubviews];
        self.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreenImageViewTapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)createFullScreenImageSubviews {
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    scroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    scroll.backgroundColor = [UIColor clearColor];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollEnabled = NO;
    scroll.delegate = self;
    [self addSubview:scroll];
    _scrollView = scroll;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:imageView];
    _imageView = imageView;
}

- (void)setZoomingEnabled:(BOOL)zoomingEnabled {
    
    _zoomingEnabled = zoomingEnabled;
    if (_scrollView) {
        
        _scrollView.minimumZoomScale = 1.f;
        _scrollView.maximumZoomScale = 2.f;
    }
}

- (void)setImage:(UIImage *)image {
    
    _imageView.image = image;
    _image = image;
}

- (void)setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder {
    
    [_imageView cy_setImageWithURLString:imageURL.absoluteString
                             placeholder:placeholder
                              completion:^(UIImage *image, NSError *error) {
                                 
                                  _image = image;
                             }];
    _imageURL = imageURL;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    if (_zoomingEnabled) {
        
        return _imageView;
    }
    return nil;
}

#pragma mark - event
- (void)fullScreenImageViewTapped:(id)sender {
    
    if (_dismissOnTap) {
        
        [self dismissAnimated:YES];
    }
}

#pragma mark - show or dismiss
- (void)showInView:(UIView *)view
          animated:(BOOL)animated {
    
    [view addSubview:self];
    self.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    if (animated) {
        
        self.alpha = 0.f;
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             
                             self.alpha = 1.f;
                         }];
    }
}

- (void)showInKeyWindowAnimated:(BOOL)animated {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self showInView:keyWindow
            animated:animated];
}

- (void)dismissAnimated:(BOOL)animated {
    
    if (animated) {
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             
                             self.alpha = 0;
                             self.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         } completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             self.alpha = 1;
                             self.transform = CGAffineTransformIdentity;
                         }];
    } else {
        
        [self removeFromSuperview];
    }
}

#pragma mark - static show dismiss
+ (instancetype)showImage:(UIImage *)image
                   inView:(UIView *)view
                 animated:(BOOL)animated
        dismissAutomatic:(BOOL)dismiss {
    
    CYFullScreenImageView *imageView = [[CYFullScreenImageView alloc] init];
    [imageView setImage:image];
    [imageView showInView:view animated:animated];
    if (dismiss) {
        
        [imageView performSelector:@selector(dismissAnimated:)
                        withObject:@YES
                        afterDelay:2.5f];
    }
    return imageView;
}

@end
