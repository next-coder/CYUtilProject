//
//  CYContactsSearchController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/16/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYContactsSearchController.h"
#import "CYContactsListViewController.h"

#import "CYContactsListCell.h"
#import "CYContactsModel.h"

#import "UIImageView+CYWebImageCache.h"

@implementation CYContactsSearchController

static NSString *const cyContactsListCellSearchIdentifier = @"cyContactsListCellSearchIdentifier";

- (instancetype)initWithContentsController:(CYContactsListViewController *)contentsController {
    
    if (self = [super init]) {
        
        _contentsController = contentsController;
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _searchBar.backgroundColor = [UIColor colorWithRed:240/255.f
                                                     green:239/255.f
                                                      blue:245/255.f
                                                     alpha:1];
        if (![[UISearchBar appearance] backgroundImage]) {
            
            _searchBar.backgroundImage = [[UIImage alloc] init];
        }
        
        _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar
                                                                     contentsController:contentsController];
        _searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.searchResultsDelegate = self;
        [_searchDisplayController.searchResultsTableView registerClass:[CYContactsListCell class]
                                                forCellReuseIdentifier:cyContactsListCellSearchIdentifier];
    }
    return self;
}

#pragma mark - setter
- (void)setDelegate:(id<CYContactsSearchControllerDelegate>)delegate {
    
    _delegate = delegate;
    self.searchDisplayController.delegate = delegate;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<CYContactsModel> contact = self.searchResults[indexPath.row];
    
    CYContactsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cyContactsListCellSearchIdentifier];
    cell.accessoryImageView.hidden = YES;
    
    // 头像
    cell.headImageHidden = self.contentsController.hideContactsHeadImage;
    if (!self.contentsController.hideContactsHeadImage) {
        
        [cell.headImageView cy_setImageWithURLString:contact.cy_headImageUrl
                                         placeholder:nil];
    }
    
    // 名称
    cell.nameLabel.text = contact.cy_nameDescription;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(contactsSearchDisplayController:didSelectContact:atIndex:)]) {
        
        // 通知delegate，选中了搜索结果的某一行
        [self.delegate contactsSearchDisplayController:self
                                      didSelectContact:self.searchResults[indexPath.row]
                                               atIndex:indexPath.row];
    }
}

@end
