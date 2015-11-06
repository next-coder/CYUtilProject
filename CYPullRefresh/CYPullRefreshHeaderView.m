//
//  CYPullRefreshHeaderView.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/7/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYPullRefreshHeaderView.h"
#import "CYPullRefreshConstants.h"
#import "NSDate+CYPullRefresh.h"

#import "Masonry.h"

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [self createAndAddSubviews];
        [self createConstraintsForSubviews];
    }
    return self;
}

- (void)createAndAddSubviews {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_refresh_idle.png"]];
    imageView.layer.anchorPoint = CGPointMake(0.5, 1.f);
    [self addSubview:imageView];
    _imageView = imageView;
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont boldSystemFontOfSize:15.f];
    title.textColor = [UIColor grayColor];
    title.backgroundColor = [UIColor clearColor];
    [self addSubview:title];
    _titleLabel = title;
    
    UILabel *detail = [[UILabel alloc] init];
    detail.font = [UIFont systemFontOfSize:13.f];
    detail.textColor = [UIColor lightGrayColor];
    detail.backgroundColor = [UIColor clearColor];
    [self addSubview:detail];
    _detailLabel = detail;
}

- (void)createConstraintsForSubviews {
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(12);
        make.height.equalTo(@20);
        make.width.equalTo(@120);
        make.centerX.equalTo(self).offset(30);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.equalTo(@20);
        make.width.equalTo(@180);
        make.left.equalTo(_titleLabel);
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 考虑到anchorPoint = CGPointMake(0.5, 1.f)
        make.centerY.equalTo(self).offset(_imageView.frame.size.height / 2.f);
        make.right.equalTo(_titleLabel.mas_left).offset(-15);
    }];
}

- (NSDate *)lastUpdateTime {
    
    if (!_lastUpdateTime) {
        
        _lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdateTimeKey];
    }
    return _lastUpdateTime;
}

- (NSString *)lastUpdateTimeKey {
    
    if (!_lastUpdateTimeKey) {
        
        _lastUpdateTimeKey = CYPullRefreshLastUpdateTimeKey;
    }
    return _lastUpdateTimeKey;
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



- (void)setRefreshState:(CYPullRefreshState)refreshState {
    [super setRefreshState:refreshState];
    
    if (refreshState == CYPullRefreshStateWillRefresh) {
        
        self.titleLabel.text = CYPullRefreshWillRefreshText;
        self.imageView.image = [UIImage imageNamed:@"common_refresh_refreshing.png"];
        [self startAnimatingRefreshImage];
    } else if (refreshState == CYPullRefreshStateRefreshing) {
        
        self.titleLabel.text = CYPullRefreshRefreshingText;
    } else {
        
        self.titleLabel.text = CYPullRefreshPullingText;
        self.imageView.image = [UIImage imageNamed:@"common_refresh_idle.png"];
        [self endAnimatingRefreshImage];
    }
    
    NSDate *lastUpdate = nil;
    if (self.lastUpdateTime) {
        lastUpdate = self.lastUpdateTime;
    } else {
        lastUpdate = [NSDate date];
    }
    self.detailLabel.text = [NSString stringWithFormat:@"最后更新: %@", [lastUpdate cy_pullRefreshFormattedDate]];
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
    self.lastUpdateTime = [NSDate date];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.lastUpdateTime
                                              forKey:self.lastUpdateTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (void)startAnimatingRefreshImage {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.keyTimes = @[
                           @0.f,
                           @0.25,
                           @0.5,
                           @0.75,
                           @1 ];
    animation.values = @[
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1.f)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI / 15.f, 0, 0, 1.f)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.f, 0, 0, 1.f)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI / 15.f, 0, 0, 1.f)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.f, 0, 0, 1.f)]
                         ];
    animation.duration = 0.4;
    animation.repeatCount = FLT_MAX;
    [self.imageView.layer addAnimation:animation
                                forKey:@"transform"];
}

- (void)endAnimatingRefreshImage {
    
    [self.imageView.layer removeAllAnimations];
}

#pragma mark - NSNotifications
- (void)applicationWillResignActive:(NSNotification *)notice {
    
    [self endAnimatingRefreshImage];
}

- (void)applicationDidBecomeActive:(NSNotification *)notice {
    
    if (self.isRefreshing) {
        
        [self startAnimatingRefreshImage];
    }
}

@end
