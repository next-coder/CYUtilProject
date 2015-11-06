//
//  CYPullRefreshFooterView.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/7/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYPullRefreshFooterView.h"
#import "CYPullRefreshConstants.h"

@implementation CYPullRefreshFooterView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    
    if (self = [super initWithScrollView:scrollView]) {
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.hidesWhenStopped = YES;
        [self addSubview:indicator];
        _activityIndicatorView = indicator;
        [_activityIndicatorView startAnimating];
        _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        UIEdgeInsets insets = scrollView.contentInset;
        scrollView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom + CYPullRefreshHeaderViewHeight, insets.right);
    }
    return self;
}

- (void)setRefreshState:(CYPullRefreshState)refreshState {
    [super setRefreshState:refreshState];
    
    if (refreshState == CYPullRefreshStateLoadingMore) {
        
        if (_delegate
            && [_delegate respondsToSelector:@selector(refreshDidBeginLoadingMore:)]) {
            
            [_delegate refreshDidBeginLoadingMore:self];
        }
    }
}

- (BOOL)isLoadingMore {
    
    return self.refreshState == CYPullRefreshStateLoadingMore;
}

- (void)scrollViewContentOffsetDidChangeFrom:(CGPoint)fromValue
                                          to:(CGPoint)toValue {
    
    if (self.refreshState == CYPullRefreshStateNoMoreData
        || self.refreshState == CYPullRefreshStateLoadingMore) {
        
        return;
    }
    CGSize contentSize = self.scrollView.contentSize;
    CGFloat loadMoreMinOffsetY = contentSize.height + CYPullRefreshHeaderMinScrollDistance - self.scrollView.frame.size.height;
    CGFloat currentOffset = toValue.y;
    
    if (currentOffset > loadMoreMinOffsetY
        && self.refreshState == CYPullRefreshStateIdle) {
        
        self.refreshState = CYPullRefreshStateLoadingMore;
    }
}

- (void)scrollViewContentSizeDidChangeFrom:(CGSize)fromValue
                                        to:(CGSize)toValue {
    
    self.frame = CGRectMake(0, toValue.height, self.scrollView.frame.size.width, CYPullRefreshHeaderViewHeight);
}

- (void)cy_endLoading {
    
    self.refreshState = CYPullRefreshStateIdle;
}

- (void)cy_resumeLoadMore {
    
    if (self.refreshState == CYPullRefreshStateNoMoreData) {
        
        self.refreshState = CYPullRefreshStateIdle;
        
        self.hidden = NO;
        [_activityIndicatorView startAnimating];
        
        UIEdgeInsets insets = self.scrollView.contentInset;
        self.scrollView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom + CYPullRefreshHeaderMinScrollDistance, insets.right);
    }
    
}

- (void)cy_stopLoadMore {
    
    if (self.refreshState != CYPullRefreshStateNoMoreData) {
        
        self.refreshState = CYPullRefreshStateNoMoreData;
        
        self.hidden = YES;
        [_activityIndicatorView stopAnimating];
        
        UIEdgeInsets insets = self.scrollView.contentInset;
        self.scrollView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom - CYPullRefreshHeaderMinScrollDistance, insets.right);
    }
    
}

@end
