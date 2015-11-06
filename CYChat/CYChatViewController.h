//
//  CYChatViewController.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/19/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CYChatDataSource.h"

@interface CYChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CYChatDataSourceDelegate>

@property (nonatomic, strong) CYChatDataSource *chatDataSource;

- (instancetype)initWithDataSource:(CYChatDataSource *)dataSource;

@end
