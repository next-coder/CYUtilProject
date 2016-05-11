//
//  CYAlertView.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/15/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYAlertView.h"

#define CY_ALERT_VIEW_CONTENT_BODER_GAP    15
#define CY_ALERT_VIEW_ACTION_VIEW_HEIGHT    44

// action layouts, 2 actions are layout as CYAlertViewActionViewsLayoutHerizontal,
// more than 2 actions are layout as CYAlertViewActionViewsLayoutVertical
typedef NS_ENUM(NSInteger, CYAlertViewActionViewsLayout) {
    
    CYAlertViewActionViewsLayoutVertical,
    CYAlertViewActionViewsLayoutHerizontal
};

@interface CYAlertView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) CYAlertViewAction *cancelAction;
@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) NSArray *customViews;
@property (nonatomic, strong) NSArray *actionSeparatorLineViews;

@property (nonatomic, assign, readonly) CYAlertViewActionViewsLayout actionLayout;

@property (nonatomic, strong) UIWindow *showWindow;
@property (nonatomic, assign) CGFloat bottomInset;

@end

@implementation CYAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle
                  actionStyle:(CYAlertViewActionStyle)actionStyle
                  customViews:(NSArray<UIView *> *)customViews
                      actions:(NSArray<CYAlertViewAction *> *)actions {
    
    if (self = [super initWithFrame:CGRectZero]) {
        
        _title = title;
        _message = message;
        _cancelTitle = cancelTitle;
        _actionStyle = actionStyle;
        _actions = actions;
        _customViews = customViews;
        
        [self createSubViews];
        
        // background
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.98];
        self.layer.cornerRadius = 10.f;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)createSubViews {
    
    __block UIView *previousView = nil;
    if (_title) {
        
        // create title
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = _title;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        // layout
        [self contentLayout:_titleLabel
           withPreviousView:nil
                     topGap:10];
        [self titleOrMessageHerizontalLayout:_titleLabel];
        previousView = _titleLabel;
    }
    if (_message) {
        
        // create message
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:14.f];
        _messageLabel.textColor = [UIColor darkGrayColor];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.text = _message;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        [self addSubview:_messageLabel];
        
        // layout
        [self contentLayout:_messageLabel
           withPreviousView:previousView
                     topGap:10];
        [self titleOrMessageHerizontalLayout:_messageLabel];
        previousView = _messageLabel;
    }
    
    // layout custom views, layout one by one, from top to bottom,
    [_customViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self addSubview:obj];
        
        if (idx == 0
            && previousView) {
            
            [self contentLayout:obj
               withPreviousView:previousView
                         topGap:10];
        } else {
            
            [self contentLayout:obj
               withPreviousView:previousView
                         topGap:0];
        }
        
        previousView = obj;
    }];
    
    // layout action
    if (_cancelTitle
        && ![_cancelTitle isEqualToString:@""]) {
        
        // create cancel action
        _cancelAction = [[CYAlertViewAction alloc] initWithTitle:_cancelTitle
                                                         handler:nil];
        [self addSubview:_cancelAction];
        _actions = [@[ _cancelAction ] arrayByAddingObjectsFromArray:_actions];
    }
    
    // layout actions, layout one by one, from bottom to top
    __block CYAlertViewAction *previousAcion = nil;
    [_actions enumerateObjectsUsingBlock:^(CYAlertViewAction *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.alertView = self;
        [self addSubview:obj];
        if (self.actionLayout == CYAlertViewActionViewsLayoutHerizontal) {
            
            [self actionHerizontalLayout:obj withPreviousAction:previousAcion];
        } else {
            
            [self actionVerticalLayout:obj withPreviousAction:previousAcion];
        }
        
        previousAcion = obj;
    }];
    
    if (self.actionStyle == CYAlertViewActionStyleDefault) {
        
        // create action separators，only action type is CYAlertViewActionStyleDefault has separators
        NSInteger separatorCount = self.actions.count;
        NSMutableArray *separators = [NSMutableArray arrayWithCapacity:separatorCount];
        for (int i = 0; i < separatorCount; i++) {
            
            UIView *separator = [[UIView alloc] init];
            separator.backgroundColor = [UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.f];
            separator.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:separator];
            [separators addObject:separator];
            
            if (self.actionLayout == CYAlertViewActionViewsLayoutVertical) {
                
                // action layout in vertical, separator layouts
                [self verticalActionSeparatorLayout:separator
                                     previousAction:self.actions[i]];
            } else if (i == (separatorCount - 1)) {
                
                // action layout in herizotal, top separator layouts
                [self herizontalActionTopSeparatorLayout:separator];
            } else {
                
                // action layout in herizotal, separator layouts
                [self herizontalActionSeparatorLayout:separator
                                       previousAction:self.actions[i]];
            }
        }
        self.actionSeparatorLineViews = [separators copy];
    }
    
    // last custom view layout on the top of top action
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:previousView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:previousAcion
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:-10];
    [self addConstraint:bottom];
}

- (CYAlertViewActionViewsLayout)actionLayout {
    
    if (self.actions.count <= 2) {
        
        return CYAlertViewActionViewsLayoutHerizontal;
    } else {
        
        return CYAlertViewActionViewsLayoutVertical;
    }
}

- (UIWindow *)showWindow {
    
    if (!_showWindow) {
        
        _showWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _showWindow.windowLevel = 10;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertTapped:)];
        [_showWindow addGestureRecognizer:tap];
    }
    return _showWindow;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.superview
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:20];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.superview
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:-20];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1
                                                                    constant:-self.bottomInset];
        [self.superview addConstraints:@[ left, right, centerY ]];
    }
}

#pragma mark - layout content views
- (void)titleOrMessageHerizontalLayout:(UILabel *)titleOrMessage {
    
    // since title and message are labels, to fit the content size, we must set the left and right constraints of them
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:titleOrMessage
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:CY_ALERT_VIEW_CONTENT_BODER_GAP];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:titleOrMessage
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-CY_ALERT_VIEW_CONTENT_BODER_GAP];
    [self addConstraints:@[ left, right ]];
}

- (void)contentLayout:(UIView *)contentView
     withPreviousView:(UIView *)previousView
               topGap:(CGFloat)topGap {
    
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    // all the following constraints priority are all low, user can add their own constraints to replace the default behavior
    // content x in the center of section
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:contentView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0];
    centerX.priority = UILayoutPriorityDefaultLow;
    // content height equal to the default frame.size.height
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:contentView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:contentView.frame.size.height];
    height.priority = UILayoutPriorityDefaultLow;
    
    // content width equal to the default frame.size.width
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:contentView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:contentView.frame.size.width];
    width.priority = UILayoutPriorityDefaultLow;
    
    // top is the bottom of the previous view
    NSLayoutConstraint *top = nil;
    if (previousView) {
        
        top = [NSLayoutConstraint constraintWithItem:contentView
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:previousView
                                           attribute:NSLayoutAttributeBottom
                                          multiplier:1
                                            constant:topGap];
    } else {
        
        top = [NSLayoutConstraint constraintWithItem:contentView
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                           attribute:NSLayoutAttributeTop
                                          multiplier:1
                                            constant:topGap];
    }
    
    [self addConstraints:@[ centerX, width, height, top ]];
}

- (void)actionHerizontalLayout:(CYAlertViewAction *)action
            withPreviousAction:(CYAlertViewAction *)previousAction {
    
    CGFloat herizontalGap = 0;
    if (self.actionStyle == CYAlertViewActionStyleRoundRect) {
        
        herizontalGap = CY_ALERT_VIEW_CONTENT_BODER_GAP;
    }
    CGFloat verticalGap = 0;
    if (self.actionStyle == CYAlertViewActionStyleRoundRect) {
        
        verticalGap = 10.f;
    }
    
    action.translatesAutoresizingMaskIntoConstraints = NO;
    // since title and message are labels, to fit the content size, we must set the left and right constraints of them
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:action
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:-verticalGap];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:action
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.0 / self.actions.count
                                                              constant:-(CGFloat)herizontalGap * (self.actions.count + 1) / self.actions.count];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:action
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:CY_ALERT_VIEW_ACTION_VIEW_HEIGHT];
    
    NSLayoutConstraint *left = nil;
    if (previousAction) {
        
        left = [NSLayoutConstraint constraintWithItem:action
                                            attribute:NSLayoutAttributeLeft
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:previousAction
                                            attribute:NSLayoutAttributeRight
                                           multiplier:1
                                             constant:herizontalGap];
    } else {
        
        left = [NSLayoutConstraint constraintWithItem:action
                                            attribute:NSLayoutAttributeLeft
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:self
                                            attribute:NSLayoutAttributeLeft
                                           multiplier:1
                                             constant:herizontalGap];
    }
    
    [self addConstraints:@[ left, width, height, bottom ]];
}

- (void)actionVerticalLayout:(CYAlertViewAction *)action
          withPreviousAction:(CYAlertViewAction *)previousAction {
    
    CGFloat herizontalGap = 0;
    if (self.actionStyle == CYAlertViewActionStyleRoundRect) {
        
        herizontalGap = CY_ALERT_VIEW_CONTENT_BODER_GAP;
    }
    
    // since title and message are labels, to fit the content size, we must set the left and right constraints of them
    action.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:action
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:herizontalGap];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:action
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-herizontalGap];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:action
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:CY_ALERT_VIEW_ACTION_VIEW_HEIGHT];
    
    
    CGFloat bottomGap = 0;
    if (self.actionStyle == CYAlertViewActionStyleRoundRect) {
        
        bottomGap = 10.f;
    }
    NSLayoutConstraint *bottom = nil;
    if (previousAction) {
        
        bottom = [NSLayoutConstraint constraintWithItem:action
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:previousAction
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1
                                               constant:-bottomGap];
    } else {
        
        bottom = [NSLayoutConstraint constraintWithItem:action
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1
                                               constant:-bottomGap];
    }

    [self addConstraints:@[ left, right, height, bottom ]];
}

- (void)verticalActionSeparatorLayout:(UIView *)separator
                       previousAction:(CYAlertViewAction *)previousAction {
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:separator
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:previousAction
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:separator
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:previousAction
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:separator
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:previousAction
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:separator
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:0.5];
    [self addConstraints:@[ left, right, bottom, height ]];
}

- (void)herizontalActionSeparatorLayout:(UIView *)separator
                         previousAction:(CYAlertViewAction *)previousAction {
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:separator
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:previousAction
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:separator
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:previousAction
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:separator
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:previousAction
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:separator
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:0.5];
    [self addConstraints:@[ left, top, bottom, width ]];
}

- (void)herizontalActionTopSeparatorLayout:(UIView *)separator {
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:separator
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:separator
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:separator
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:[self anyAction]
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:separator
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:0.5];
    [self addConstraints:@[ left, right, bottom, height ]];
}

- (CYAlertViewAction *)anyAction {
    
    if (self.cancelAction) {
        
        return self.cancelAction;
    } else {
        
        return self.actions.firstObject;
    }
}

#pragma mark - show

//static UIWindow *alertShowingWindow = nil;
//static UITapGestureRecognizer *alertShowingWindowTap = nil;

- (void)show {
    
    [self showWithBottomInset:0];
}

- (void)showWithBottomInset:(CGFloat)bottomInset {
    
    self.bottomInset = bottomInset;
    self.showWindow.backgroundColor = [UIColor clearColor];
    [self.showWindow addSubview:self];
    [self.showWindow makeKeyAndVisible];
    
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.showWindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
                         self.transform = CGAffineTransformIdentity;
                     }];
    
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    keyframeAnimation.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)] ];
    keyframeAnimation.keyTimes = @[ @0, @0.5, @1 ];
    keyframeAnimation.duration = 0.3f;
    keyframeAnimation.removedOnCompletion = YES;
    keyframeAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:keyframeAnimation forKey:@"showAlert"];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         self.showWindow.alpha = 0;
                     } completion:^(BOOL finished) {
                         
                         [self.showWindow resignKeyWindow];
                         self.showWindow = nil;
                         [self removeFromSuperview];
                     }];
}

#pragma mark - event
- (void)alertTapped:(UITapGestureRecognizer *)sender {
    
    [self endEditing:YES];
    if (self.dimissOnBlankAreaTapped) {
        
        CGPoint touchPoint = [sender locationInView:self];
        if (!CGRectContainsPoint(self.bounds, touchPoint)) {
            
            [self dismiss];
        }
    }
}

@end
