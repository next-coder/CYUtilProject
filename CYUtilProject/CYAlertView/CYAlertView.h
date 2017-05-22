//
//  CYAlertView.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/15/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYAlertViewAction.h"

//typedef NS_ENUM(NSInteger, CYAlertViewStyle) {
//
//    CYAlertViewStyleAlert,
//    CYAlertViewStyleActionSheet                 // not implemented
//};

typedef NS_ENUM(NSInteger, CYAlertViewActionStyle) {

    CYAlertViewActionStyleDefault,
    CYAlertViewActionStyleRoundRect
};

@interface CYAlertView : UIView

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) NSString *cancelTitle;

@property (nonatomic, assign, readonly) CYAlertViewActionStyle actionStyle;

// default NO，点击空白区域，是否dismiss
@property (nonatomic, assign) BOOL dismissOnBlankAreaTapped;

//- (instancetype)initWithTitle:(NSString *)title
//                      message:(NSString *)message
//                  cancelTitle:(NSString *)cancelTitle;
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle
                  actionStyle:(CYAlertViewActionStyle)actionStyle;

// the next two methods add view in the white background area
// add view in the white background area
- (void)addMessageView:(UIView *)view;
// add alert action
- (void)addAction:(CYAlertViewAction *)action;

#pragma mark - show
- (void)show;
- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated;

@end
