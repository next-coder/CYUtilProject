//
//  CYPullRefreshHeaderView.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/7/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYPullRefreshHeaderView.h"
#import "CYPullRefreshConstants.h"

@interface CYPullRefreshHeaderView ()

@property (nonatomic, assign) UIEdgeInsets originScrollContentInset;

@end

@implementation CYPullRefreshHeaderView

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cy_releaseResources {
    
    [super cy_releaseResources];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    
    if (self = [super initWithScrollView:scrollView]) {
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(applicationWillResignActive:)
//                                                     name:UIApplicationWillResignActiveNotification
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(applicationDidBecomeActive:)
//                                                     name:UIApplicationDidBecomeActiveNotification
//                                                   object:nil];
//        
        [self createAndAddSubviews];
    }
    return self;
}

- (void)createAndAddSubviews {
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.hidesWhenStopped = YES;
    [self addSubview:indicator];
    _activityIndicatorView = indicator;
    [_activityIndicatorView startAnimating];
    _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

#pragma mark - scroll
- (void)scrollViewContentOffsetDidChangeFrom:(CGPoint)fromValue
                                          to:(CGPoint)toValue {
    
    [super scrollViewContentOffsetDidChangeFrom:fromValue to:toValue];
    
    if (self.refreshState == CYPullRefreshStateRefreshing) {
        
        return;
    }
    
    UIEdgeInsets insets = self.scrollView.contentInset;
    
    // 当前scroll的offset
    CGFloat offsetY = self.scrollView.contentOffset.y;
    // header出现的offset
    CGFloat happenOffsetY = insets.top;
    
    // 头部刷新还没显示
    if (offsetY > happenOffsetY) return;
    
    CGFloat refreshingMinOffsetY = happenOffsetY - CYPullRefreshHeaderMinScrollDistance;
    if (self.scrollView.isDragging) {
        
        if (self.refreshState == CYPullRefreshStateIdle
            && offsetY > refreshingMinOffsetY) {
            
            self.refreshState = CYPullRefreshStatePulling;
        } else if (self.refreshState == CYPullRefreshStatePulling
                   && offsetY < refreshingMinOffsetY) {
            
            self.refreshState = CYPullRefreshStateWillRefresh;
        } else if (self.refreshState == CYPullRefreshStateWillRefresh
                   && offsetY > refreshingMinOffsetY) {
            
            self.refreshState = CYPullRefreshStatePulling;
        }
    } else if (self.refreshState == CYPullRefreshStateWillRefresh) {
        
        [self cy_beginRefreshing];
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(refreshDidBeginRefreshing:)]) {
            
            [self.delegate refreshDidBeginRefreshing:self];
        }
    } else {
        
        self.refreshState = CYPullRefreshStateIdle;
    }
}

- (BOOL)isRefreshing {
    
    return self.refreshState == CYPullRefreshStateRefreshing;
}

#pragma mark - refreshing
- (void)cy_beginRefreshing {
    
    self.refreshState = CYPullRefreshStateRefreshing;
    [self animatedResetContentInsetWithRefreshState:CYPullRefreshStateRefreshing];
}

- (void)cy_endRefreshing {
    
    self.refreshState = CYPullRefreshStateIdle;
    [self animatedResetContentInsetWithRefreshState:CYPullRefreshStateIdle];
//    self.lastUpdateTime = [NSDate date];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:self.lastUpdateTime
//                                              forKey:self.lastUpdateTimeKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - private
- (void)animatedResetContentInsetWithRefreshState:(CYPullRefreshState)state {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        UIEdgeInsets insets = self.scrollView.contentInset;
        if (state == CYPullRefreshStateRefreshing) {
            
            self.scrollView.contentInset = UIEdgeInsetsMake(insets.top + CYPullRefreshHeaderMinScrollDistance,
                                                            insets.left,
                                                            insets.bottom,
                                                            insets.right);
        } else {
            
            self.scrollView.contentInset = UIEdgeInsetsMake(insets.top - CYPullRefreshHeaderMinScrollDistance,
                                                            insets.left,
                                                            insets.bottom,
                                                            insets.right);
        }
    }];
}

//- (void)startAnimatingRefreshImage {
//    
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.keyTimes = @[
//                           @0.f,
//                           @0.25,
//                           @0.5,
//                           @0.75,
//                           @1 ];
//    animation.values = @[
//                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1.f)],
//                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI / 15.f, 0, 0, 1.f)],
//                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.f, 0, 0, 1.f)],
//                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI / 15.f, 0, 0, 1.f)],
//                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.f, 0, 0, 1.f)]
//                         ];
//    animation.duration = 0.4;
//    animation.repeatCount = FLT_MAX;
//    [self.imageView.layer addAnimation:animation
//                                forKey:@"transform"];
//}
//
//- (void)endAnimatingRefreshImage {
//    
//    [self.imageView.layer removeAllAnimations];
//}
//
//#pragma mark - NSNotifications
//- (void)applicationWillResignActive:(NSNotification *)notice {
//    
//    [self endAnimatingRefreshImage];
//}
//
//- (void)applicationDidBecomeActive:(NSNotification *)notice {
//    
//    if (self.isRefreshing) {
//        
//        [self startAnimatingRefreshImage];
//    }
//}

@end
