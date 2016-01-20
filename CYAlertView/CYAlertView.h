//
//  CYAlertView.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/15/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYAlertViewAction.h"

typedef NS_ENUM(NSInteger, CYAlertViewStyle) {
    
    CYAlertViewStyleAlert,
    CYAlertViewStyleActionSheet                 // not implemented
};

// 按钮样式，在CYAlertViewStyleAlert是有效
typedef NS_ENUM(NSInteger, CYAlertViewActionStyle) {
    
    CYAlertViewActionStyleDefault,
    CYAlertViewActionStyleRoundRect
};

@interface CYAlertView : UIView

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) NSString *cancelTitle;

@property (nonatomic, assign) CYAlertViewStyle style;
@property (nonatomic, assign) CYAlertViewActionStyle actionStyle;

// default NO，点击空白区域，是否dismiss
@property (nonatomic, assign) BOOL dimissOnBlankAreaTapped;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle;

- (void)addCustomMessageView:(UIView *)view;
- (void)addAction:(CYAlertViewAction *)action;

#pragma mark - show
- (void)show;
- (void)dismiss;

@end
