//
//  CYBaseTableWithPullRefreshViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/15/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYBaseTableWithPullRefreshViewController.h"

@interface CYBaseTableWithPullRefreshViewController ()

@end

@implementation CYBaseTableWithPullRefreshViewController

- (void)dealloc {
    
    if (_refreshHeaderView) {
        
        [_refreshHeaderView cy_releaseResources];
        _refreshHeaderView = nil;
    }
    if (_refreshFooterView) {
        
        [_refreshFooterView cy_releaseResources];
        _refreshFooterView = nil;
    }
}

- (void)cy_addPullRefresh {
    
    CYPullRefreshHeaderView *refresh = [[CYPullRefreshHeaderView alloc] initWithScrollView:self.tableView];
    refresh.delegate = self;
    _refreshHeaderView = refresh;
}

- (void)cy_addLoadMore {
    
    CYPullRefreshFooterView *refresh = [[CYPullRefreshFooterView alloc] initWithScrollView:self.tableView];
    refresh.delegate = self;
    _refreshFooterView = refresh;
    [_refreshFooterView cy_stopLoadMore];
}

#pragma mark - CYPullRefreshHeaderDelegate, CYPullRefreshFooterDelegate
- (void)refreshDidBeginRefreshing:(CYPullRefreshHeaderView *)view {
    
    
}

- (void)refreshDidBeginLoadingMore:(CYPullRefreshFooterView *)view {
    
    
}

@end
