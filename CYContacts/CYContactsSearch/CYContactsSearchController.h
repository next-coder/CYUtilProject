//
//  CYContactsSearchController.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/16/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CYContactsModel;
@class CYContactsSearchController;
@class CYContactsListViewController;

@protocol CYContactsSearchControllerDelegate <UISearchDisplayDelegate>

@optional
- (void)contactsSearchDisplayController:(CYContactsSearchController *)searchController
                       didSelectContact:(id<CYContactsModel>)contact
                                atIndex:(NSInteger)index;

@end

@interface CYContactsSearchController : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<CYContactsSearchControllerDelegate> delegate;

@property (nonatomic, copy) NSArray<id<CYContactsModel>> *searchResults;

@property (nonatomic, strong, readonly) UISearchBar *searchBar;

@property (nonatomic, weak, readonly) CYContactsListViewController *contentsController;

// for iOS7.x and previous
@property (nonatomic, strong, readonly) UISearchDisplayController *searchDisplayController;

// For iOS8.x and later
@property (nonatomic, strong, readonly) UISearchController *searchController;

- (instancetype)initWithContentsController:(CYContactsListViewController *)contentsController;

@end
