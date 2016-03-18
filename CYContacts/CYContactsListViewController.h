//
//  CYContactsListViewController.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYContactsSearchController.h"

@class CYContactsListAdapter;
@protocol CYContactsModel;

typedef NS_ENUM(NSInteger, CYContactsSearchBarPosition) {
    
    CYContactsSearchBarPositionTableHeader,
    CYContactsSearchBarPositionNavigationBar
};

// always UITableViewStylePlain
@interface CYContactsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CYContactsSearchControllerDelegate>

@property (nonatomic, weak, readonly) UITableView *tableView;

// 数据适配器
@property (nonatomic, strong) CYContactsListAdapter *adapter;

// 用于搜索的SearchController
@property (nonatomic, strong, readonly) CYContactsSearchController *searchController;

// 搜索框位置
@property (nonatomic, assign) CYContactsSearchBarPosition searchBarPosition;

// 是否隐藏搜索功能
@property (nonatomic, assign) BOOL hideSearchController;
// 是否隐藏右侧导航
@property (nonatomic, assign) BOOL hideContactsIndex;
// 是否隐藏头像
@property (nonatomic, assign) BOOL hideContactsHeadImage;
// 是否是选择模式
@property (nonatomic, assign) BOOL selected;

// 已选中的联系人列表
@property (nonatomic, strong, readonly) NSArray<id<CYContactsModel>> *selectedContacts;

- (instancetype)initWithContactsListAdapter:(CYContactsListAdapter *)adapter;

@end
