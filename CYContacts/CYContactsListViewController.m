//
//  CYContactsListViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYContactsListViewController.h"
#import "CYContactsSearchInNavigationViewController.h"

#import "CYContactsListCell.h"
#import "CYContactsListHeaderView.h"

#import "CYContactsListAdapter.h"
#import "CYContactsModel.h"

#import "UIImageView+CYWebImageCache.h"

@interface CYContactsListViewController ()

@property (nonatomic, strong) NSMutableArray *internalSelectedContacts;

@end

@implementation CYContactsListViewController

static NSString *const cyContactsListCellIdentifier = @"cyContactsListCellIdentifier";

- (instancetype)initWithContactsListAdapter:(CYContactsListAdapter *)adapter {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        _adapter = adapter;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    if (self.searchController) {
        
        self.tableView.tableHeaderView = self.searchController.searchBar;
        self.searchController.delegate = self;
    }
    
    _searchController = [[CYContactsSearchController alloc] initWithContentsController:self];
    _searchController.delegate = self;
    
    if (!self.hideSearchController) {
        
        [self refreshSearchBarPosition];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 55;
    [self.tableView registerClass:[CYContactsListCell class]
           forCellReuseIdentifier:cyContactsListCellIdentifier];
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
            
            if (self.tableView.tableHeaderView == self.searchController.searchBar) {
                
                self.tableView.tableHeaderView = nil;
            }
            break;
        }
            
        default:
            self.tableView.tableHeaderView = self.searchController.searchBar;
            break;
    }
}

- (void)setSelected:(BOOL)selected {
    
    if (_selected != selected) {
        
        _selected = selected;
        
        if (self.isViewLoaded) {
            
            [self.tableView reloadData];
        }
    }
}

- (void)setHideContactsIndex:(BOOL)hideContactsIndex {
    
    if (_hideContactsIndex != hideContactsIndex) {
        
        _hideContactsIndex = hideContactsIndex;
        
        if (self.isViewLoaded) {
            
            [self.tableView reloadSectionIndexTitles];
        }
    }
}

- (void)setHideSearchController:(BOOL)hideSearchController {
    
    if (_hideSearchController == hideSearchController) {
        
        return;
    }
    _hideSearchController = hideSearchController;
    
    if (self.isViewLoaded) {
        
        if (_hideSearchController) {
            
            self.tableView.tableHeaderView = nil;
        } else {
            
            self.tableView.tableHeaderView = _searchController.searchBar;
        }
        [self.tableView reloadSectionIndexTitles];
    }
}

- (void)setAdapter:(CYContactsListAdapter *)adapter {
    
    _adapter = adapter;
    
    if (self.isViewLoaded) {
        
        [self.tableView reloadData];
    }
}
//
//- (void)setSearchController:(CYContactsSearchController *)searchController {
//    
//    _searchController = searchController;
//    
//    if (self.isViewLoaded) {
//        
//        self.tableView.tableHeaderView = self.searchController.searchBar;
//        self.searchController.delegate = self;
//    }
//}

#pragma mark - getter
- (NSMutableArray *)internalSelectedContacts {
    
    if (!_internalSelectedContacts) {
        
        _internalSelectedContacts = [NSMutableArray array];
    }
    return _internalSelectedContacts;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.adapter.groupContacts) {
        
        return self.adapter.groupedContacts.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!self.adapter.groupContacts) {
        
        return self.adapter.contacts.count;
    } else {
        
        NSString *key = self.adapter.sortedGroupKeys[section];
        return self.adapter.groupedContacts[key].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<CYContactsModel> contact = nil;
    if (!self.adapter.groupContacts) {
        
        contact = self.adapter.contacts[indexPath.row];
    } else {
        
        NSString *key = self.adapter.sortedGroupKeys[indexPath.section];
        contact = self.adapter.groupedContacts[key][indexPath.row];
    }
    
    CYContactsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cyContactsListCellIdentifier];
    
    // 头像
    cell.headImageHidden = self.hideContactsHeadImage;
    if (!self.hideContactsHeadImage) {
        
        [cell.headImageView cy_setImageWithURLString:contact.cy_headImageUrl
                                         placeholder:nil];
    }
    
    // 名称
    cell.nameLabel.text = contact.cy_nameDescription;
    
    if (self.selected) {
        
#warning image
        if ([self.internalSelectedContacts containsObject:contact]) {
            
            cell.accessoryImageView.image = [UIImage imageNamed:@""];
        } else {
            
            cell.accessoryImageView.image = [UIImage imageNamed:@""];
        }
    } else {
        
        cell.accessoryImageView.image = nil;
    }
    
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (self.hideContactsIndex) {
        
        return nil;
    } else if (self.hideSearchController) {
        
        return self.adapter.sortedGroupKeys;
    } else {
        
        return [@[ UITableViewIndexSearch ] arrayByAddingObjectsFromArray:self.adapter.sortedGroupKeys];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
//    if (index == 0) {
//        
//        return index;
//    } else {
//        
//        return (index - 1);
//    }
//    return (index - 1);
    
    if (self.hideSearchController) {
        
        return index;
    } else if (index == 0) {
        
        [tableView scrollRectToVisible:CGRectMake(0, 0, tableView.frame.size.width, 40) animated:NO];
        return NSNotFound;
    } else {
        
        return (index - 1);
    }
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!self.adapter.groupContacts) {
        
        return nil;
    } else {
        
        CYContactsListHeaderView *view = [[CYContactsListHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        view.titleLabel.text = self.adapter.sortedGroupKeys[section];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (!self.adapter.groupContacts) {
        
        return 0;
    } else {
        
        return 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSString *key = self.adapter.sortedGroupKeys[indexPath.section];
//    id<CYContactsModel> contact = self.adapter.groupedContacts[key][indexPath.row];
    id<CYContactsModel> contact = nil;
    if (!self.adapter.groupContacts) {
        
        contact = self.adapter.contacts[indexPath.row];
    } else {
        
        NSString *key = self.adapter.sortedGroupKeys[indexPath.section];
        contact = self.adapter.groupedContacts[key][indexPath.row];
    }
    
    if (self.selected) {
        
        // 获取当前选择的cell
        CYContactsListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([self.internalSelectedContacts containsObject:contact]) {
            
#warning 未选中image
            [self.internalSelectedContacts removeObject:contact];
            cell.accessoryImageView.image = [UIImage imageNamed:@""];
        } else {
            
#warning 已选中image
            [self.internalSelectedContacts addObject:contact];
            cell.accessoryImageView.image = [UIImage imageNamed:@""];
        }
        
    } else {
        
#warning select contact
    }
}

#pragma mark - CYContactsSearchControllerDelegate，UISearchDisplayDelegate
- (void)contactsSearchDisplayController:(CYContactsSearchController *)searchController
                       didSelectContact:(id<CYContactsModel>)contact
                                atIndex:(NSInteger)index {
    
    if (self.selected) {
        
        [self.internalSelectedContacts addObject:contact];
    } else {
        
#warning select contact
    }
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    if (self.selected) {
        
        // 搜索结束时，需要reload数据，以刷新通过搜索选中的联系人在列表中的选择状态
        [self.tableView reloadData];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    NSArray *searchResults = [self searchResultsWithText:searchString];
    self.searchController.searchResults = searchResults;
    return YES;
}

- (NSArray *)searchResultsWithText:(NSString *)searchString {
    
    if (!searchString
        || [searchString isEqualToString:@""]) {
        
        return nil;
    }
    
    // 获取搜索结果
    NSMutableArray *searchResults = [NSMutableArray array];
    [self.adapter.contacts enumerateObjectsUsingBlock:^(id<CYContactsModel>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.cy_nameDescription rangeOfString:searchString].location != NSNotFound) {
            
            [searchResults addObject:obj];
        }
    }];
    
    return [searchResults copy];
}

#pragma mark - event
- (void)searchShouldStart:(id)sender {
    
    CYContactsSearchInNavigationViewController *search = [[CYContactsSearchInNavigationViewController alloc] initWithParentContactsListViewController:self];
    [self.navigationController pushViewController:search animated:YES];
    
//    self.searchController.searchBar.frame = CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.searchController.searchBar];
//    item.width = 200;
//    [self.navigationItem setRightBarButtonItem:item animated:YES];
//    
////    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
//    [self.searchController.searchDisplayController setActive:YES animated:YES];
}

@end
