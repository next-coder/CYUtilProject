//
//  CYContactsListTestViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/15/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYContactsListTestViewController.h"
//
//#import "CYSearchInNavigationController.h"

#import "CYAddressBookUtils.h"
#import "CYContactViewModel.h"

@interface CYContactsListTestViewController ()

//@property (nonatomic, strong) CYSearchInNavigationController *search;

@end

@implementation CYContactsListTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CYAddressBookUtils *util = [[CYAddressBookUtils alloc] init];
    
    if ([util addressBookGetAuthorizationStatus] == CYAddressBookAuthorizedStatusNotDetermine) {
        
        [util requestAddressBookAccessWithCompletion:^(BOOL granted, NSError *error) {
            
            NSArray *list = [util fetchAllPeopleInAddressBookWithNameFormat:CYAddressBookNameFormatLastNameFirst];
            
            NSMutableArray<CYContactViewModel *> *allContacts = [NSMutableArray arrayWithCapacity:list.count];
            [list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CYContactViewModel *model = [[CYContactViewModel alloc] init];
                model.name = [obj.allValues firstObject];
                [allContacts addObject:model];
            }];
            
            CYContactsListAdapter *adapter = [[CYContactsListAdapter alloc] initWithContacts:allContacts
                                                                               groupContacts:YES];
            self.adapter = adapter;
        }];
    } else {
        
        NSArray *list = [util fetchAllPeopleInAddressBookWithNameFormat:CYAddressBookNameFormatLastNameFirst];
        
        NSMutableArray<CYContactViewModel *> *allContacts = [NSMutableArray arrayWithCapacity:list.count];
        [list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CYContactViewModel *model = [[CYContactViewModel alloc] init];
            model.name = [obj.allValues firstObject];
            [allContacts addObject:model];
        }];
        
        CYContactsListAdapter *adapter = [[CYContactsListAdapter alloc] initWithContacts:allContacts
                                                                           groupContacts:YES];
        self.adapter = adapter;
        
        self.title = @"CYContacts";
        
        self.searchBarPosition = CYContactsSearchBarPositionNavigationBar;
    }
}

@end
