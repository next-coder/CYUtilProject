//
//  CYPullRefreshFooterView.h
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/7/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYPullRefreshBaseView.h"

@class CYPullRefreshFooterView;

@protocol CYPullRefreshFooterDelegate <NSObject>

@optional
- (void)refreshDidBeginLoadingMore:(CYPullRefreshFooterView *)view;

@end

@interface CYPullRefreshFooterView : CYPullRefreshBaseView

@property (nonatomic, weak) id<CYPullRefreshFooterDelegate> delegate;

@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign, readonly) BOOL isLoadingMore;

- (void)cy_endLoading;             // 结束加载更多
- (void)cy_resumeLoadMore;         // 重置loadmore
- (void)cy_stopLoadMore;           // 停止loadmore，如果需要再次启用Loadmore，请调用resumeLoadMore

@end
