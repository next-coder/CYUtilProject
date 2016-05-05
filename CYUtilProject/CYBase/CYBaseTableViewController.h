//
//  CYBaseTableViewController.h
//  MoneyJar2
//
//  Created by Charry on 7/9/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import "CYBaseViewController.h"
//#import "CYRefreshHeaderView.h"
//#import "CYRefreshFooterView.h"

@interface CYBaseTableViewController : CYBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign, readonly) UITableViewStyle tableViewStyle;
@property (nonatomic, weak) UITableView *tableView;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style;

@end
