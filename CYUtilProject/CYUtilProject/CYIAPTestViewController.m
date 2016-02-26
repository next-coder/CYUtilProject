//
//  CYIAPTestViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 1/22/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYIAPTestViewController.h"

#import "CYIAPUtils.h"

NSString *const kCYIAPTestProduct1 = @"com.laohu.sdkdemo.100";
NSString *const kCYIAPTestProduct2 = @"com.laohu.sdkdemo.200";

@implementation CYIAPTestViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    if (indexPath.row == 0) {
        
        cell.textLabel.text = kCYIAPTestProduct1;
    } else if (indexPath.row == 1) {
        
        cell.textLabel.text = kCYIAPTestProduct2;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        [CYIAPUtils addNewIAPWithProductID:kCYIAPTestProduct1
                                  quantity:1
                            additionalInfo:@{ @"identifier": @"kCYIAPTestProduct1" }
                              stateChanged:^(CYIAPTransaction *transaction) {
                                
                                  NSLog(@"%@", transaction);
                            }];
    } else if (indexPath.row == 1) {
        
        [CYIAPUtils addNewIAPWithProductID:kCYIAPTestProduct2
                                  quantity:2
                            additionalInfo:@{ @"identifier": @"kCYIAPTestProduct2" }
                              stateChanged:^(CYIAPTransaction *transaction) {
                                  
                                  NSLog(@"%@", transaction);
                              }];
    }
}

@end
