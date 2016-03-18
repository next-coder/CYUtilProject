//
//  CYActionSheetAction.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/18/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYActionSheetAction;
@class CYActionSheet;

typedef void (^CYActionSheetActionHandler)(CYActionSheetAction *action);

@interface CYActionSheetAction : UIButton

@property (nonatomic, weak) CYActionSheet *actionSheet;

// handler should not have an strong refrence to CYAlertView, or it may be memory leaks
@property (nonatomic, copy, readonly) CYActionSheetActionHandler handler;

// default YES, 点击后，自动dismiss alert
@property (nonatomic, assign) BOOL dismissActionSheet;

- (instancetype)initWithTitle:(NSString *)title
                      handler:(CYActionSheetActionHandler)handler;

@end
