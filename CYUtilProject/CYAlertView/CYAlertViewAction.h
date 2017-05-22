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

// default is [UIColor clearColor]
@property (nonatomic, strong) UIColor *normalBackgroundColor;
// defautl is [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.f]
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

// default YES, 点击后，自动dismiss alert
@property (nonatomic, assign) BOOL dismissAlert;

// 关联的alertView，在添加到alertView之后有效
@property (nonatomic, weak, readonly) CYAlertView *alertView;

// handler should not have an strong refrence to CYAlertView, or it may be memory leaks
@property (nonatomic, copy, readonly) CYAlertViewActionHandler handler;

- (instancetype)initWithTitle:(NSString *)title handler:(CYAlertViewActionHandler)handler;

@end

