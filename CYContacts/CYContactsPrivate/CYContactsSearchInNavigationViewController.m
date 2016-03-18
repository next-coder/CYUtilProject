//
//  CYContactsSearchInNavigationViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/18/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYContactsSearchInNavigationViewController.h"

@implementation CYContactsSearchInNavigationViewController

- (instancetype)initWithParentContactsListViewController:(CYContactsListViewController *)parentController {
    
    if (self = [super initWithContactsListAdapter:parentController.adapter]) {
        
        _parentContactsListViewController = parentController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.searchController.delegate = self;
    self.searchController.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
    self.searchController.searchBar.showsCancelButton = YES;
    
    [self.searchDisplayController setActive:YES animated:YES];
    [self.searchController.searchBar becomeFirstResponder];
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - CYContactsSearchControllerDelegate，UISearchDisplayDelegate
- (void)contactsSearchDisplayController:(CYContactsSearchController *)searchController
                       didSelectContact:(id<CYContactsModel>)contact
                                atIndex:(NSInteger)index {
    
    [_parentContactsListViewController contactsSearchDisplayController:searchController
                                                      didSelectContact:contact
                                                               atIndex:index];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    [_parentContactsListViewController searchDisplayControllerDidEndSearch:controller];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
