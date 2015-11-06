//
//  CYBaseViewController.h
//  MoneyJar2
//
//  Created by Charry on 6/3/15.
//  Copyright (c) 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYBaseViewController;

@interface CYBaseViewController : UIViewController <UIGestureRecognizerDelegate, UITextFieldDelegate>

// 返回的地方
@property (nonatomic, weak) UIViewController *backViewController;

@property (nonatomic, weak) UIButton *navigationBackButton;
@property (nonatomic, assign) BOOL hideBackButton;

@property (nonatomic, weak) UITapGestureRecognizer *resignFirstResponderTapGestureRecognizer;

// 返回
- (void)cy_backAction:(id)sender;

#pragma mark - resignFirstResponderTapGestureRecognizer
// 主要用于单击空白区域，消失键盘
- (void)cy_setNeedsResignFirstResponderTap;
- (void)cy_removeResignFirstResponderTap;

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end
