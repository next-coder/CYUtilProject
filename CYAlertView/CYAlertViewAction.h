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

typedef void (^CYAlertViewActionHandler)(CYAlertViewAction *action);

@interface CYAlertViewAction : NSObject

@property (nonatomic, strong, readonly) NSString *title;
// default YES
@property (nonatomic, assign) BOOL enabled;
// default YES, 点击后，自动dismiss alert
@property (nonatomic, assign) BOOL dismissAlert;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *highlightedTitleColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *highlightedBackgroundImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;

@property (nonatomic, strong, readonly) UIView *actionView;
@property (nonatomic, weak) CYAlertView *alertView;

// handler should not have an strong refrence to CYAlertView, or it may be memory leaks
@property (nonatomic, copy, readonly) CYAlertViewActionHandler handler;

- (instancetype)initWithTitle:(NSString *)title
                      handler:(CYAlertViewActionHandler)handler;

@end

