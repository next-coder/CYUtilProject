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

@property (nonatomic, strong) NSArray *contentViews;

@property (nonatomic, assign) NSUInteger currentIndex;
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
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    [self addSubview:scroll];
    _scrollView = scroll;
}

- (void)setImages:(NSArray *)images placeholder:(UIImage *)placeholder firstShowingIndex:(NSInteger)index {
    
    _images = images;
    _placeholder = placeholder;
    _firstShowingIndex = index;
    if (_firstShowingIndex < images.count) {
        
        _currentIndex = _firstShowingIndex;
    }
    
    [self recreateContentViews];
}

- (void)setZoomingEnabled:(BOOL)zoomingEnabled {
    
    _zoomingEnabled = zoomingEnabled;
    if (_contentViews) {
        
        [_contentViews enumerateObjectsUsingBlock:^(UIScrollView *scroll, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([scroll isKindOfClass:[UIScrollView class]]) {
                
                if (_zoomingEnabled) {
                    
                    scroll.maximumZoomScale = 2.f;
                    scroll.minimumZoomScale = 1.f;
                } else {
                    
                    scroll.maximumZoomScale = 1.f;
                    scroll.minimumZoomScale = 1.f;
                }
            }
        }];
    }
}

- (void)recreateContentViews {
    
    if (_contentViews
        && [_contentViews count] > 0) {
        
        [_contentViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj removeFromSuperview];
        }];
        _contentViews = nil;
    }
    
    NSUInteger imagesCount = [_images count];
    if (imagesCount > 0) {
        
        CGFloat scrollWidth = CGRectGetWidth(_scrollView.frame);
        CGFloat scrollHeight = CGRectGetHeight(_scrollView.frame);
        
        NSMutableArray *contentViews = [NSMutableArray arrayWithCapacity:imagesCount];
        [_images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, scrollHeight)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = CY_FULL_SCREEN_IMAGE_VIEW_ZOOM_TAG;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            if ([obj isKindOfClass:[UIImage class]]) {
                
                imageView.image = obj;
            } else if ([obj isKindOfClass:[NSURL class]]) {
                
                [imageView cy_setImageWithURL:obj
                                  placeholder:_placeholder
                                   completion:nil];
            } else if ([obj isKindOfClass:[NSString class]]) {
                
                [imageView cy_setImageWithURLString:obj
                                        placeholder:_placeholder];
            }
            
            UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(idx * scrollWidth, 0, scrollWidth, scrollHeight)];
            scroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            scroll.backgroundColor = [UIColor clearColor];
            scroll.delegate = self;
            [scroll addSubview:imageView];
            [_scrollView addSubview:scroll];
            
            if (_zoomingEnabled) {
                
                scroll.maximumZoomScale = 2.f;
                scroll.minimumZoomScale = 1.f;
            }
            
            [contentViews addObject:scroll];
        }];
        _contentViews = contentViews;
        
        _scrollView.contentSize = CGSizeMake(imagesCount * scrollWidth, scrollHeight);
        _scrollView.contentOffset = CGPointMake(_currentIndex * scrollWidth, 0);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrollWidth = CGRectGetWidth(_scrollView.frame);
    NSInteger index = (scrollView.contentOffset.x + scrollWidth / 2.f) / scrollWidth;
    if (index < 0) {
        index = 0;
    } else if (index >= _contentViews.count) {
        
        index = _contentViews.count;
    }
    _currentIndex = index;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    if (_zoomingEnabled) {
        
        return [scrollView viewWithTag:CY_FULL_SCREEN_IMAGE_VIEW_ZOOM_TAG];
    }
    return nil;
}

#pragma mark - event
- (void)fullScreenImageViewTapped:(id)sender {
    
    if (_dismissOnTap) {
        
        [self dismiss];
    }
}

#pragma mark - show or dismiss
- (void)showFromRect:(CGRect)rect
              inView:(UIView *)view {
    
    [view addSubview:self];
    self.scrollView.frame = rect;
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    self.backgroundColor = [UIColor clearColor];
    _showRect = rect;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
                         self.backgroundColor = [UIColor blackColor];
                     }];
}

- (void)showInKeyWindowFromRect:(CGRect)rect {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self showFromRect:rect inView:keyWindow];
}

- (void)dismissToRect:(CGRect)rect {
    
    if (_firstShowingIndex == _currentIndex) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.backgroundColor = [UIColor clearColor];
            self.scrollView.frame = rect;
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    } else {
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             
                             self.alpha = 0;
                         } completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             self.alpha = 1;
                         }];
    }
}

- (void)dismiss {
    
    [self dismissToRect:_showRect];
}

#pragma mark - static show dismiss
+ (instancetype)showImages:(NSArray *)images
               placeholder:(UIImage *)placeholder
         firstShowingIndex:(NSInteger)index
                  fromRect:(CGRect)rect
                    inView:(UIView *)view {
    
    CYFullScreenImageView *fullScreenImage = [[CYFullScreenImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    [fullScreenImage setImages:images placeholder:placeholder firstShowingIndex:index];
    [fullScreenImage showFromRect:rect inView:view];
    return fullScreenImage;
}

+ (instancetype)showImagesInKeyWindow:(NSArray *)images
                          placeholder:(UIImage *)placeholder
                    firstShowingIndex:(NSInteger)index
                             fromRect:(CGRect)rect {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    return [self showImages:images
                placeholder:placeholder
          firstShowingIndex:index
                   fromRect:rect
                     inView:keyWindow];
}

@end
