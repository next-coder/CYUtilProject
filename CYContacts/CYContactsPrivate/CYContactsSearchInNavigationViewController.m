//
//  CYContactsSearchInNavigationViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/18/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYContactsSearchInNavigationViewController.h"

@interface CYContactsSearchInNavigationViewController ()

@end

@implementation CYContactsSearchInNavigationViewController

//- (instancetype)initWithParentContactsListViewController:(CYContactsListViewController *)parentController {
//    
//    if (self = [super initWithContactsListAdapter:parentController.adapter]) {
//        
//        _parentContactsListViewController = parentController;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.showsCancelButton = YES;
    
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    [self.searchDisplayController setActive:YES animated:YES];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

//#pragma mark - UISearchDisplayDelegate
//- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
//    
//    if (self.delegate) {
//        
//        [self.delegate contactsDidEndSearch:self];
//    }
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
