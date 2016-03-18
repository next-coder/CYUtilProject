//
//  CYContactsSearchInNavigationViewController.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/18/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYContactsListViewController.h"

@interface CYContactsSearchInNavigationViewController : CYContactsListViewController

@property (nonatomic, weak, readonly) CYContactsListViewController *parentContactsListViewController;

- (instancetype)initWithParentContactsListViewController:(CYContactsListViewController *)parentController;

@end