//
//  CYPullRefreshBaseView.h
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/7/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Masonry.h"

typedef NS_ENUM(NSInteger, CYPullRefreshState) {
    
    CYPullRefreshStateIdle,
    CYPullRefreshStatePulling,
    CYPullRefreshStateWillRefresh,
    CYPullRefreshStateRefreshing,
    CYPullRefreshStateLoadingMore,
    CYPullRefreshStateNoMoreData
};

@interface CYPullRefreshBaseView : UIView

@property (nonatomic, assign) CYPullRefreshState refreshState;

@property (nonatomic, weak, readonly) UIScrollView *scrollView;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

// 释放资源，使用完一定调用此方法
- (void)cy_releaseResources;

- (void)scrollViewContentOffsetDidChangeFrom:(CGPoint)fromValue
                                          to:(CGPoint)toValue;
- (void)scrollViewContentSizeDidChangeFrom:(CGSize)fromValue
                                        to:(CGSize)toValue;

@end
