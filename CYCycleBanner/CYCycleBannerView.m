//
//  CYCycleBannerView.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/4/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYCycleBannerView.h"

#import "UIImageView+CYWebImageCache.h"

@interface CYCycleBannerView () 

@property (nonatomic, strong) NSArray *contentViews;

@property (nonatomic, strong) NSArray *internalImages;

@end

@implementation CYCycleBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createCycleBannerSubviews];
    }
    return self;
}

- (void)createCycleBannerSubviews {
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    [self addSubview:scroll];
    _scrollView = scroll;
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 30, CGRectGetWidth(self.frame), 30)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    _pageControl = pageControl;
}

- (void)setImages:(NSArray *)images placeholder:(UIImage *)placeholder continuous:(BOOL)continuous {
    
    _images = images;
    _placeholder = placeholder;
    _continuous = continuous;
    
    if (!images
        || images.count < 2) {
        
        _continuous = NO;
    }
    if (_continuous) {
        
        NSMutableArray *internalImages = [images mutableCopy];
        [internalImages insertObject:[images lastObject] atIndex:0];
        [internalImages addObject:[images firstObject]];
        _internalImages = [internalImages copy];
    } else {
        
        _internalImages = _images;
    }
    
    [self recreateContentViews];
}

#pragma mark - create contents
- (void)recreateContentViews {
    
    if (_contentViews
        && _contentViews.count > 0) {
        
        [_contentViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj removeFromSuperview];
        }];
        _contentViews = nil;
    }
    
    NSUInteger imagesCount = _images.count;
    CGFloat scrollWidth = CGRectGetWidth(_scrollView.frame);
    CGFloat scrollHeight = CGRectGetHeight(_scrollView.frame);
    
    _pageControl.numberOfPages = imagesCount;
    _scrollView.contentSize = CGSizeMake(scrollWidth * _internalImages.count, scrollHeight);
    
    if (imagesCount > 0) {
        
        NSMutableArray *contentViews = [NSMutableArray arrayWithCapacity:_internalImages.count];
        [_internalImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * scrollWidth,
                                                                                   0,
                                                                                   CGRectGetWidth(_scrollView.frame),
                                                                                   CGRectGetHeight(_scrollView.frame))];
            imageView.backgroundColor = [UIColor clearColor];
            [_scrollView addSubview:imageView];
            [contentViews addObject:imageView];
            
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
        }];
        _contentViews = contentViews;
        
        if (_continuous) {
            
            _scrollView.contentOffset = CGPointMake(scrollWidth, 0);
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat targetX = scrollView.contentOffset.x;
    CGFloat itemWidth = CGRectGetWidth(scrollView.frame);
    NSUInteger imagesCount = _internalImages.count;
    
    if (_continuous
        && imagesCount > 3) {
        
        CGFloat offsetY = scrollView.contentOffset.y;
        
        if (targetX > (imagesCount - 1) * itemWidth) {
            
            targetX = itemWidth;
            _scrollView.contentOffset = CGPointMake(targetX, offsetY);
        } else if (targetX < 0) {
            
            targetX = (imagesCount - 2) * itemWidth;
            _scrollView.contentOffset = CGPointMake(targetX, offsetY);
        }
        
    }
    
    NSInteger page = (targetX + itemWidth * 0.5) / itemWidth;
    
    if (_continuous) {
        
        page--;
        if (page < 0) {
            
            page = _pageControl.numberOfPages - 1;
        } else if (page >= _pageControl.numberOfPages) {
            
            page = 0;
        }
    }
    _pageControl.currentPage = page;
}

@end
