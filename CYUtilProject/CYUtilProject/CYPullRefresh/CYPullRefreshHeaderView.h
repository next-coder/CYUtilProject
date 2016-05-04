//
//  CYPullRefreshHeaderView.h
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/7/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYPullRefreshBaseView.h"

@class CYPullRefreshHeaderView;

@protocol CYPullRefreshHeaderDelegate <NSObject>

@optional
- (void)refreshDidBeginRefreshing:(CYPullRefreshHeaderView *)view;

@end

@interface CYPullRefreshHeaderView : CYPullRefreshBaseView

@property (nonatomic, weak) id<CYPullRefreshHeaderDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isRefreshing;

@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;

//@property (nonatomic, weak, readonly) UIImageView *imageView;
//@property (nonatomic, weak, readonly) UILabel *titleLabel;
//@property (nonatomic, weak, readonly) UILabel *detailLabel;
//
//@property (nonatomic, strong) NSDate *lastUpdateTime;
//@property (nonatomic, strong) NSString *lastUpdateTimeKey;          // 存储最后更新时间的Key

- (void)cy_beginRefreshing;
- (void)cy_endRefreshing;

@end
