//
//  CYSearchController.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/21/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CYSearchUpdater <NSObject>



@end

@interface CYSearchController : UIViewController

@property (nonatomic, weak, readonly) UIViewController *contentsController;
@property (nonatomic, weak, readonly) UIViewController *searchResultsController;

@property (nonatomic, weak, readonly) UISearchBar *searchBar;

@end
