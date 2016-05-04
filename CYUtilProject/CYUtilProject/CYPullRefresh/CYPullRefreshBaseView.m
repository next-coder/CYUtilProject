//
//  CYPullRefreshBaseView.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/7/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYPullRefreshBaseView.h"
#import "CYPullRefreshConstants.h"

@implementation CYPullRefreshBaseView

- (void)dealloc {
    
    if (_scrollView) {
        
        [_scrollView removeObserver:self
                         forKeyPath:CYPullRefreshContentOffsetKey];
        [_scrollView removeObserver:self
                         forKeyPath:CYPullRefreshContentSizeKey];
    }
}

- (void)cy_releaseResources {
    
    if (_scrollView) {
        
        [_scrollView removeObserver:self
                         forKeyPath:CYPullRefreshContentOffsetKey];
        [_scrollView removeObserver:self
                         forKeyPath:CYPullRefreshContentSizeKey];
    }
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    
    if (self = [super initWithFrame:CGRectMake(0,
                                               -CYPullRefreshHeaderViewHeight - scrollView.contentInset.top,
                                               scrollView.frame.size.width,
                                               CYPullRefreshHeaderViewHeight)]) {
        
        _scrollView = scrollView;
        [_scrollView addSubview:self];
        [_scrollView addObserver:self
                      forKeyPath:CYPullRefreshContentOffsetKey
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                         context:NULL];
        [_scrollView addObserver:self
                      forKeyPath:CYPullRefreshContentSizeKey
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                         context:NULL];
        
        _refreshState = CYPullRefreshStateIdle;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (instancetype)init {
    
    NSAssert(NO, @"Please use initWithScrollView: to init");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    NSAssert(NO, @"Please use initWithScrollView: to init");
    return nil;
}

#pragma mark - remove
- (void)removeFromSuperview {
    
    [self cy_releaseResources];
    [super removeFromSuperview];
}

#pragma mark - contentOffset changed
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == _scrollView) {
        
        if ([keyPath isEqualToString:CYPullRefreshContentSizeKey]) {
            
            CGSize oldValue = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
            CGSize newValue = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
            [self scrollViewContentSizeDidChangeFrom:oldValue
                                                  to:newValue];
        } else if ([keyPath isEqualToString:CYPullRefreshContentOffsetKey]) {
            
            CGPoint oldValue = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
            CGPoint newValue = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
            [self scrollViewContentOffsetDidChangeFrom:oldValue
                                                    to:newValue];
        }
    }
}

- (void)scrollViewContentOffsetDidChangeFrom:(CGPoint)fromValue
                                          to:(CGPoint)toValue {
    
    
}

- (void)scrollViewContentSizeDidChangeFrom:(CGSize)fromValue
                                        to:(CGSize)toValue {
    
    
}

@end
