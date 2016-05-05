//
//  CYBaseTableWithPullRefreshViewController.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/15/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYBaseTableViewController.h"

#import "CYPullRefresh.h"

@interface CYBaseTableWithPullRefreshViewController : CYBaseTableViewController <CYPullRefreshHeaderDelegate, CYPullRefreshFooterDelegate>

// pull refresh
@property (nonatomic, weak) CYPullRefreshHeaderView *refreshHeaderView;
- (void)cy_addPullRefresh;

@property (nonatomic, weak) CYPullRefreshFooterView *refreshFooterView;
- (void)cy_addLoadMore;

@end
