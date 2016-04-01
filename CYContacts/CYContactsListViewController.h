//
//  CYContactsListViewController.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CYContactsSearchBarPosition) {
    
    CYContactsSearchBarPositionNone,                // 没有搜索功能
    CYContactsSearchBarPositionTableHeader,         // 搜索框在tableHeader
    CYContactsSearchBarPositionNavigationBar        // 搜索框在navigation
};

// always UITableViewStylePlain
@interface CYContactsListViewController : UIViewController

@property (nonatomic, weak, readonly) UITableView *tableView;
@property (nonatomic, weak, readonly) UITableView *searchResultsTableView;
// 搜索背景后的TableView，seachBarPosition == CYContactsSearchBarPositionTableHeader时，此值为self.tableView，其他不为self.tableView
@property (nonatomic, weak, readonly) UITableView *searchBackgrounTableView;

@property (nonatomic, weak) id<UITableViewDataSource> contactsListDataSource;
@property (nonatomic, weak) id<UITableViewDelegate> contactsListDelegate;

@property (nonatomic, weak) id<UITableViewDataSource> searchResultsDataSource;
@property (nonatomic, weak) id<UITableViewDelegate> searchResultsDelegate;

@property (nonatomic, weak) id<UISearchDisplayDelegate> searchDisplayDelegate;

//// 数据适配器
//@property (nonatomic, strong) CYContactsListAdapter *adapter;

// 搜索框位置
@property (nonatomic, assign) CYContactsSearchBarPosition searchBarPosition;
@property (nonatomic, weak, readonly) UISearchBar *searchBar;

//// 是否隐藏右侧导航
//@property (nonatomic, assign) BOOL hideContactsIndex;
//// 是否隐藏头像
//@property (nonatomic, assign) BOOL hideContactsHeadImage;
//// 是否是选择模式
//@property (nonatomic, assign) BOOL selected;
//
//// 已选中的联系人列表
//@property (nonatomic, strong, readonly) NSArray<id<CYContactsModel>> *selectedContacts;
//
//- (instancetype)initWithContactsListAdapter:(CYContactsListAdapter *)adapter;

@end
