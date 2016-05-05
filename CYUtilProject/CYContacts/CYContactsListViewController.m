//
//  CYContactsListViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYContactsListViewController.h"
#import "CYContactsSearchInNavigationViewController.h"

//#import "CYContactsListCell.h"
//#import "CYContactsListHeaderView.h"
//
//#import "CYContactsListAdapter.h"
//#import "CYContactsModel.h"
//
//#import "UIImageView+CYWebImageCache.h"

@interface CYContactsListViewController ()

@property (nonatomic, strong) UISearchBar *internalSeachBar;
@property (nonatomic, strong) UISearchDisplayController *internalSearchDisplayController;

@property (nonatomic, strong) NSMutableArray *internalSelectedContacts;
@property (nonatomic, strong) NSArray *searchResults;

@property (nonatomic, weak) CYContactsSearchInNavigationViewController *contactsSearchController;

@end

@implementation CYContactsListViewController

//static NSString *const cyContactsListCellIdentifier = @"cyContactsListCellIdentifier";
//
//- (instancetype)initWithContactsListAdapter:(CYContactsListAdapter *)adapter {
//
//    if (self = [super initWithNibName:nil bundle:nil]) {
//
////        _adapter = adapter;
//        self.extendedLayoutIncludesOpaqueBars = YES;
//    }
//    return self;
//}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self.contactsListDataSource;
    self.tableView.delegate = self.contactsListDelegate;
    
    [self refreshSearchBarPosition];
}

#pragma mark - setter
- (void)setSearchBarPosition:(CYContactsSearchBarPosition)searchBarPosition {
    
    if (_searchBarPosition != searchBarPosition) {
        
        _searchBarPosition = searchBarPosition;
        if (self.isViewLoaded) {
            
            [self refreshSearchBarPosition];
        }
    }
}

- (void)refreshSearchBarPosition {
    
    switch (_searchBarPosition) {
        case CYContactsSearchBarPositionNavigationBar: {
            
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"搜索"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(searchShouldStart:)];
            self.navigationItem.rightBarButtonItem = item;
            
//            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"friends_invite_list_search_item.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                                                     style:UIBarButtonItemStylePlain
//                                                                    target:self
//                                                                    action:@selector(searchShouldStart:)];
//            self.navigationItem.rightBarButtonItem = item;
            
            if (self.tableView.tableHeaderView == self.searchBar) {
                
                self.tableView.tableHeaderView = nil;
            }
            break;
        }
            
        case CYContactsSearchBarPositionTableHeader: {
            
            self.tableView.tableHeaderView = self.internalSeachBar;
            break;
        }
            
        default: {
            
            break;
        }
    }
}

//- (void)setSelected:(BOOL)selected {
//
//    if (_selected != selected) {
//
//        _selected = selected;
//
//        if (self.isViewLoaded) {
//
//            [self.tableView reloadData];
//        }
//    }
//}
//
//- (void)setHideContactsIndex:(BOOL)hideContactsIndex {
//
//    if (_hideContactsIndex != hideContactsIndex) {
//
//        _hideContactsIndex = hideContactsIndex;
//
//        if (self.isViewLoaded) {
//
//            [self.tableView reloadSectionIndexTitles];
//        }
//    }
//}
//
//- (void)setAdapter:(CYContactsListAdapter *)adapter {
//
//    _adapter = adapter;
//
//    if (self.isViewLoaded) {
//
//        [self.tableView reloadData];
//    }
//}

- (void)setContactsListDataSource:(id<UITableViewDataSource>)contactsListDataSource {
    
    _contactsListDataSource = contactsListDataSource;
    
    if (self.isViewLoaded) {
        
        self.tableView.dataSource = _contactsListDataSource;
    }
}

- (void)setContactsListDelegate:(id<UITableViewDelegate>)contactsListDelegate {
    
    _contactsListDelegate = contactsListDelegate;
    
    if (self.isViewLoaded) {
        
        self.tableView.delegate = _contactsListDelegate;
    }
}

- (void)setSearchResultsDataSource:(id<UITableViewDataSource>)searchResultsDataSource {
    
    _searchResultsDataSource = searchResultsDataSource;
    
    if (self.isViewLoaded
        && self.searchBarPosition == CYContactsSearchBarPositionTableHeader) {
        
        self.internalSearchDisplayController.searchResultsDataSource = _searchResultsDataSource;
    }
}

- (void)setSearchResultsDelegate:(id<UITableViewDelegate>)searchResultsDelegate {
    
    _searchResultsDelegate = searchResultsDelegate;
    
    if (self.isViewLoaded
        && self.searchBarPosition == CYContactsSearchBarPositionTableHeader) {
        
        self.internalSearchDisplayController.searchResultsDelegate = _searchResultsDelegate;
    }
}

#pragma mark - getter
- (UISearchBar *)internalSeachBar {
    
    if (!_internalSeachBar) {
        
        _internalSeachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    }
    return _internalSeachBar;
}

- (UISearchDisplayController *)internalSearchDisplayController {
    
    if (!_internalSearchDisplayController) {
        
        _internalSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.internalSeachBar
                                                                             contentsController:self];
        _internalSearchDisplayController.delegate = self.searchDisplayDelegate;
        _internalSearchDisplayController.searchResultsDataSource = self.searchResultsDataSource;
        _internalSearchDisplayController.searchResultsDelegate = self.searchResultsDelegate;
    }
    return _internalSearchDisplayController;
}

//- (NSMutableArray *)internalSelectedContacts {
//
//    if (!_internalSelectedContacts) {
//
//        _internalSelectedContacts = [NSMutableArray array];
//    }
//    return _internalSelectedContacts;
//}
//
//- (NSArray<id<CYContactsModel>> *)selectedContacts {
//
//    return [_internalSelectedContacts copy];
//}
//
//- (BOOL)showSearchSectionIndex {
//
//    return (self.searchBarPosition == CYContactsSearchBarPositionTableHeader);
//}

- (UISearchBar *)searchBar {
    
    return self.internalSeachBar;
}

- (UISearchDisplayController *)searchDisplayController {
    
    return self.internalSearchDisplayController;
}

- (UITableView *)searchResultsTableView {
    
    if (self.searchBarPosition == CYContactsSearchBarPositionTableHeader) {
        
        return self.searchDisplayController.searchResultsTableView;
    } else if (self.searchBarPosition == CYContactsSearchBarPositionNavigationBar) {
        
        return self.contactsSearchController.searchDisplayController.searchResultsTableView;
    } else {
        
        return nil;
    }
}

- (UITableView *)searchBackgrounTableView {
    
    if (self.searchBarPosition == CYContactsSearchBarPositionTableHeader) {
        
        return self.tableView;
    } else if (self.searchBarPosition == CYContactsSearchBarPositionNavigationBar) {
        
        return self.contactsSearchController.tableView;
    } else {
        
        return nil;
    }
}

//#pragma mark - UITableViewDataSource
//// section count
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    if (tableView == self.tableView) {
//
//        return [self allContactsSections];
//    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
//
//        return [self searchContactsSections];
//    } else {
//
//        return 0;
//    }
//}
//
//- (NSInteger)allContactsSections {
//
//    if (self.adapter.groupContacts) {
//
//        return self.adapter.groupedContacts.count;
//    }
//    return 1;
//}
//
//- (NSInteger)searchContactsSections {
//
//    return 1;
//}
//
//// row count
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    if (tableView == self.tableView) {
//
//        return [self allContactsRowsInSection:section];
//    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
//
//        return [self searchContactsRowsInSection:section];
//    } else {
//
//        return 0;
//    }
//}
//
//- (NSInteger)allContactsRowsInSection:(NSInteger)section {
//
//    if (!self.adapter.groupContacts) {
//
//        return self.adapter.contacts.count;
//    } else {
//
//        NSString *key = self.adapter.sortedGroupKeys[section];
//        return self.adapter.groupedContacts[key].count;
//    }
//}
//
//- (NSInteger)searchContactsRowsInSection:(NSInteger)section {
//
//    return self.searchResults.count;
//}
//
//// cell
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    id<CYContactsModel> contact = nil;
//    if (tableView == self.tableView) {
//
//        contact = [self contactInAllContactsAtIndexPath:indexPath];
//    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
//
//        contact = [self contactInSearchContactsAtIndexPath:indexPath];
//    }
//
//    CYContactsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cyContactsListCellIdentifier];
//    if (!cell) {
//
//        cell = [[CYContactsListCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                         reuseIdentifier:cyContactsListCellIdentifier];
//    }
//    // 头像
//    cell.headImageHidden = self.hideContactsHeadImage;
//    if (!self.hideContactsHeadImage) {
//
//        [cell.headImageView cy_setImageWithURLString:contact.cy_headImageUrl
//                                         placeholder:nil];
//    }
//
//    // 名称
//    cell.nameLabel.text = contact.cy_nameDescription;
//
//    if (self.selected) {
//
//        if ([self.internalSelectedContacts containsObject:contact]) {
//
//            cell.accessoryImageView.image = [UIImage imageNamed:@"CYContacts.bundle/cy_contacts_list_selected_icon.png"];
//        } else {
//
//            cell.accessoryImageView.image = [UIImage imageNamed:@"CYContacts.bundle/cy_contacts_list_unselected_icon.png"];
//        }
//    } else {
//
//        cell.accessoryImageView.image = nil;
//    }
//
//    return cell;
//}
//
//- (id<CYContactsModel>)contactInAllContactsAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (!self.adapter.groupContacts) {
//
//        return self.adapter.contacts[indexPath.row];
//    } else {
//
//        NSString *key = self.adapter.sortedGroupKeys[indexPath.section];
//        return self.adapter.groupedContacts[key][indexPath.row];
//    }
//}
//
//- (id<CYContactsModel>)contactInSearchContactsAtIndexPath:(NSIndexPath *)indexPath {
//
//    return self.searchResults[indexPath.row];
//}
//
//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//
//        return nil;
//    } else if (self.hideContactsIndex) {
//
//        return nil;
//    } else if (!self.showSearchSectionIndex) {
//
//        return self.adapter.sortedGroupKeys;
//    } else {
//
//        return [@[ UITableViewIndexSearch ] arrayByAddingObjectsFromArray:self.adapter.sortedGroupKeys];
//    }
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//
//        return 0;
//    } else if (!self.showSearchSectionIndex) {
//
//        return index;
//    } else if (index == 0) {
//
//        [tableView scrollRectToVisible:CGRectMake(0, 0, tableView.frame.size.width, 40) animated:NO];
//        return NSNotFound;
//    } else {
//
//        return (index - 1);
//    }
//}
//
//#pragma mark - UITableViewDelegate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//
//        return nil;
//    } else if (!self.adapter.groupContacts) {
//
//        return nil;
//    } else {
//
//        CYContactsListHeaderView *view = [[CYContactsListHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
//        view.titleLabel.text = self.adapter.sortedGroupKeys[section];
//        return view;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//
//        return 0;
//    } else if (!self.adapter.groupContacts) {
//
//        return 0;
//    } else {
//
//        return 20;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return 55;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    id<CYContactsModel> contact = nil;
//    if (tableView == self.tableView) {
//
//        contact = [self contactInAllContactsAtIndexPath:indexPath];
//    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
//
//        contact = [self contactInSearchContactsAtIndexPath:indexPath];
//    }
//
//    if (self.selected) {
//
//        // 获取当前选择的cell
//        CYContactsListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//        if ([self.internalSelectedContacts containsObject:contact]) {
//
//            [self.internalSelectedContacts removeObject:contact];
//            cell.accessoryImageView.image = [UIImage imageNamed:@"CYContacts.bundle/cy_contacts_list_unselected_icon.png"];
//        } else {
//
//            [self.internalSelectedContacts addObject:contact];
//            cell.accessoryImageView.image = [UIImage imageNamed:@"CYContacts.bundle/cy_contacts_list_selected_icon.png"];
//        }
//
//        [self.tableView reloadData];
//    } else {
//
//#warning select contact
//    }
//}

//#pragma mark - UISearchDisplayDelegate
//- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
//
//
//}
//
//- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
//
//    if (self.selected) {
//
//        // 搜索结束时，需要reload数据，以刷新通过搜索选中的联系人在列表中的选择状态
//        [self.tableView reloadData];
//    }
//}
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
//
//    self.searchResults = [self searchResultsWithText:searchString];
//    return YES;
//}
//
//- (NSArray *)searchResultsWithText:(NSString *)searchString {
//
//    if (!searchString
//        || [searchString isEqualToString:@""]) {
//
//        return nil;
//    }
//
//    // 获取搜索结果
//    NSMutableArray *searchResults = [NSMutableArray array];
//    [self.adapter.contacts enumerateObjectsUsingBlock:^(id<CYContactsModel>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        if ([obj.cy_nameDescription rangeOfString:searchString].location != NSNotFound) {
//
//            [searchResults addObject:obj];
//        }
//    }];
//
//    return [searchResults copy];
//}
//
//#pragma mark - CYContactsSearchInNavigationDelegate
//// 搜索在navigation时，搜索完成
//- (void)contactsDidEndSearch:(CYContactsSearchInNavigationViewController *)search {
//
//    self.internalSelectedContacts = search.internalSelectedContacts;
//    [self.tableView reloadData];
//}

#pragma mark - event
// 搜索在navigation时，点击按钮，进入下一页搜索
- (void)searchShouldStart:(id)sender {
    
    CYContactsSearchInNavigationViewController *search = [[CYContactsSearchInNavigationViewController alloc] init];
    search.contactsListDataSource = self.contactsListDataSource;
    search.contactsListDelegate = self.contactsListDelegate;
    search.searchResultsDataSource = self.searchResultsDataSource;
    search.searchResultsDelegate = self.searchResultsDelegate;
    search.searchDisplayDelegate = self.searchDisplayDelegate;
    if (self.navigationItem.leftBarButtonItem) {
        
        search.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
    }
    [self.navigationController pushViewController:search animated:YES];
    self.contactsSearchController = search;
}

@end
