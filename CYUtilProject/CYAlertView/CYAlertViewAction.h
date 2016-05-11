//
//  CYAlertViewAction.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/15/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CYAlertViewAction;
@class CYAlertView;

typedef void (^CYAlertViewActionHandler)(CYAlertView *alertView, CYAlertViewAction *action);

@interface CYAlertViewAction : UIButton

// background color for highlighted state
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
// background color for other state
@property (nonatomic, strong) UIColor *normalBackgroundColor;

// default YES, 点击后，自动dismiss alert
@property (nonatomic, assign) BOOL dismissAlert;

@property (nonatomic, weak) CYAlertView *alertView;

// handler should not have an strong refrence to CYAlertView, or it may be memory leaks
@property (nonatomic, copy, readonly) CYAlertViewActionHandler handler;

- (instancetype)initWithTitle:(NSString *)title
                      handler:(CYAlertViewActionHandler)handler;

@end

