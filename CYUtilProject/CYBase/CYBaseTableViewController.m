//
//  CYBaseTableViewController.m
//  MoneyJar2
//
//  Created by Charry on 7/9/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import "CYBaseTableViewController.h"

@interface CYBaseTableViewController () 

@end

@implementation CYBaseTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    return [self initWithTableViewStyle:UITableViewStylePlain];
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        _tableViewStyle = style;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:_tableViewStyle];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor colorWithRed:228/255.f
                                               green:230/255.f
                                                blue:231/255.f
                                               alpha:1.f];
    self.view = tableView;
    _tableView = tableView;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

@end
