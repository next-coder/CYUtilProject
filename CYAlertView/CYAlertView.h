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

@interface CYAlertView : UIView

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) NSString *cancelTitle;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id)delegate
                  cancelTitle:(NSString *)cancelTitle
                        style:(CYAlertViewStyle)style;

- (void)addCustomMessageView:(UIView *)view;
- (void)addAction:(CYAlertViewAction *)action;

#pragma mark - show
- (void)show;
- (void)dismiss;

@end
