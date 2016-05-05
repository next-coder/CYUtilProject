//
//  CYPullRefreshConstants.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/7/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYPullRefreshConstants.h"

NSString * const CYPullRefreshContentOffsetKey = @"contentOffset";          // contentOffset
NSString * const CYPullRefreshContentSizeKey = @"contentSize";
NSString * const CYPullRefreshLastUpdateTimeKey = @"CYPullRefreshLastUpdateTimeKey";

NSString * const CYPullRefreshPullingText = @"下拉可以更新数据";
NSString * const CYPullRefreshWillRefreshText = @"松开立即更新数据";
NSString * const CYPullRefreshRefreshingText = @"更新数据中...";

NSString * const CYPullRefreshLoadingMoreText = @"正在加载更多的数据...";          // 上拉加载更多提示语

const double CYPullRefreshHeaderMinScrollDistance = 60.f;                      // 下拉刷新需要的最短拉动高度
const double CYPullRefreshHeaderViewHeight = 60.f;                             // 下拉刷新视图的高度
