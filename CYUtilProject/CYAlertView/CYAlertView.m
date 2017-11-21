//
//  CYAlertView.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/15/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYAlertView.h"

#define CY_ALERT_VIEW_ACTION_SEPARATOR_COLOR ([UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.f].CGColor)

typedef NS_ENUM(NSInteger, CYAlertViewActionViewsLayout) {

    CYAlertViewActionViewsLayoutVertical,
    CYAlertViewActionViewsLayoutHerizontal
};

@interface CYAlertViewAction (CYAlertView)

@property (nonatomic, weak, readwrite) CYAlertView *alertView;

@end

@implementation CYAlertViewAction (CYAlertView)

@dynamic alertView;

@end

@interface CYAlertView ()

@property (nonatomic, strong) UIView *alertBackgroundView;

@property (nonatomic, strong) CYAlertViewAction *cancelAction;
// action 列表, contain cancel action
@property (nonatomic, strong) NSMutableArray *actions;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *messageTextView;
// contain title and message
@property (nonatomic, strong) NSMutableArray *messageViews;

@property (nonatomic, assign, readonly) CYAlertViewActionViewsLayout actionLayout;

@property (nonatomic, strong) UIWindow *showWindow;
@property (nonatomic, strong) UIWindow *originWindow;
@property (nonatomic, strong) UITapGestureRecognizer *alertBackgroundTap;

// UI config
@property (nonatomic, readonly) CGFloat alertWidth;
@property (nonatomic, readonly) CGFloat contentGap;
@property (nonatomic, readonly) CGFloat contentWidth;
@property (nonatomic, readonly) CGFloat maxMessageHeight;
@property (nonatomic, readonly) CGFloat actionHeight;
@property (nonatomic, readonly) CGFloat screenWidth;

@end

@implementation CYAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithTitle:nil
                       message:nil
                   cancelTitle:nil
                   actionStyle:CYAlertViewActionStyleDefault];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle
                  actionStyle:(CYAlertViewActionStyle)actionStyle {

    if (self = [super initWithFrame:CGRectZero]) {

        _title = title;
        _message = message;
        _cancelTitle = cancelTitle;
        _actionStyle = actionStyle;

        _actions = [NSMutableArray array];
        _messageViews = [NSMutableArray array];

        _alertWidth = 280;
        _contentGap = 15;
        _maxMessageHeight = 200;
        _actionHeight = 44;
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
        _contentWidth = _alertWidth - _contentGap * 2;

        [self createSubViews];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)createSubViews {

    _alertBackgroundView = [[UIView alloc] init];
    _alertBackgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.98];
    _alertBackgroundView.layer.cornerRadius = 10.f;
    _alertBackgroundView.clipsToBounds = YES;
    [self addSubview:_alertBackgroundView];

    if (_title) {

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = _title;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addMessageView:_titleLabel];

        CGRect frame = CGRectZero;
        CGSize size = [_titleLabel sizeThatFits:CGSizeMake(_contentWidth, _maxMessageHeight)];
        frame.size = size;
        _titleLabel.frame = frame;
    }
    if (_message) {

        _messageTextView = [[UITextView alloc] init];
        _messageTextView.font = [UIFont systemFontOfSize:14.f];
        _messageTextView.textColor = [UIColor darkGrayColor];
        _messageTextView.backgroundColor = [UIColor clearColor];
        _messageTextView.text = _message;
        _messageTextView.editable = NO;
        _messageTextView.textAlignment = NSTextAlignmentCenter;
        [self addMessageView:_messageTextView];

        CGRect frame = CGRectZero;
        CGSize size = [_messageTextView sizeThatFits:CGSizeMake(_contentWidth, _maxMessageHeight)];
        frame.size = size;
        _messageTextView.frame = frame;
    }
    if (_cancelTitle
        && ![_cancelTitle isEqualToString:@""]) {

        _cancelAction = [[CYAlertViewAction alloc] initWithTitle:_cancelTitle
                                                         handler:^(CYAlertView *alertView, CYAlertViewAction *action) {

                                                             [alertView dismiss];
                                                         }];
        [self addAction:_cancelAction];
    }
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
        _showWindow.backgroundColor = [UIColor clearColor];
        _showWindow.windowLevel = 10;
        [_showWindow addSubview:self];

        self.center = CGPointMake(_showWindow.frame.size.width / 2.f,
                                  _showWindow.frame.size.height / 2.f);
    }
    return _showWindow;
}

- (void)setDismissOnBlankAreaTapped:(BOOL)dismissOnBlankAreaTapped {
    _dismissOnBlankAreaTapped = dismissOnBlankAreaTapped;

    if (_dismissOnBlankAreaTapped
        && !self.alertBackgroundTap) {

        self.alertBackgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertTapped:)];
    }
    self.alertBackgroundTap.enabled = _dismissOnBlankAreaTapped;
}

#pragma mark - custom alert
- (void)addMessageView:(UIView *)view {

    if (!view) {
        return;
    }
    [self.alertBackgroundView addSubview:view];
    [self.messageViews addObject:view];
}

- (void)addAction:(CYAlertViewAction *)action {

    if (!action) {

        return;
    }
    if (self.actionStyle == CYAlertViewActionStyleRoundRect) {

        // 圆角
        action.layer.cornerRadius = 4;
    } else {

        // 边框，用于显示按钮之间的分割线
        action.layer.borderColor = CY_ALERT_VIEW_ACTION_SEPARATOR_COLOR;
        action.layer.borderWidth = 0.5;
    }
    action.alertView = self;
    [self.alertBackgroundView addSubview:action];
    [self.actions addObject:action];
}

#pragma mark - layout content views
- (void)layoutSubviews {
    [super layoutSubviews];

    [self layoutAlert];
}

- (void)layoutAlert {

    CGRect frame = CGRectZero;
    __block CGFloat nextY = self.contentGap;
    if ([self.messageViews count] > 0) {

        [self.messageViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {

            CGRect frame = view.frame;
            frame.origin.x = (self.alertWidth - frame.size.width) / 2.f;
            frame.origin.y = nextY;
            view.frame = frame;

            nextY = CGRectGetMaxY(view.frame) + self.contentGap;
        }];
    }

    if (self.actions.count > 0) {

        if (self.actionLayout == CYAlertViewActionViewsLayoutVertical) {
            // 按钮竖着布局
            CGFloat buttonOriginX = 0;
            CGFloat buttonWidth = self.alertWidth;
            if (self.actionStyle == CYAlertViewActionStyleRoundRect) {

                buttonOriginX = self.contentGap;
                buttonWidth = self.contentWidth;
            }

            [self.actions enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(CYAlertViewAction *action, NSUInteger idx, BOOL * _Nonnull stop) {

                CGRect frame;
                frame.origin.x = buttonOriginX;
                // 减少0.5，防止分割线重叠，导致分割线颜色加深
                frame.origin.y = nextY - 0.5;
                frame.size.width = buttonWidth;
                frame.size.height = self.actionHeight;
                action.frame = frame;

                nextY = CGRectGetMaxY(action.frame);
                if (self.actionStyle == CYAlertViewActionStyleRoundRect) {

                    nextY += self.contentGap;
                }
            }];
        } else {

            // 按钮水平布局
            NSInteger actionCount = self.actions.count;
            __block CGFloat nextX = 0;
            CGFloat buttonWidth = 0;
            if (self.actionStyle == CYAlertViewActionStyleRoundRect) {

                buttonWidth = (self.alertWidth - self.contentGap * (actionCount + 1)) / actionCount;
            } else {

                buttonWidth = self.alertWidth / actionCount;
            }
            CGSize buttonSize = CGSizeMake(buttonWidth + 1, self.actionHeight + 1);
            if (self.actionStyle == CYAlertViewActionStyleRoundRect) {
                nextX = self.contentGap;
            }
            [self.actions enumerateObjectsUsingBlock:^(CYAlertViewAction *action, NSUInteger idx, BOOL * _Nonnull stop) {

                CGRect frame;
                // 减少0.5，防止分割线重叠，导致分割线颜色加深
                frame.origin.x = nextX - 0.5;
                frame.origin.y = nextY;
                frame.size = buttonSize;
                action.frame = frame;

                if (self.actionStyle == CYAlertViewActionStyleRoundRect) {

                    nextX = CGRectGetMaxX(action.frame) + self.contentGap;
                } else {

                    nextX = CGRectGetMaxX(action.frame);
                }
            }];
            nextY += self.actionHeight;
            if (self.actionStyle == CYAlertViewActionStyleRoundRect) {

                nextY += self.contentGap;
            }
        }

    } else {

        nextY += self.contentGap;
    }
    frame = CGRectMake(0, 0, self.alertWidth, nextY);
    self.alertBackgroundView.frame = frame;
    self.alertBackgroundView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
}

#pragma mark - show

- (void)show {

    [self.showWindow makeKeyAndVisible];

    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    keyframeAnimation.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)] ];
    keyframeAnimation.keyTimes = @[ @0, @0.5, @1 ];
    keyframeAnimation.duration = 0.3f;
    keyframeAnimation.removedOnCompletion = YES;
    keyframeAnimation.fillMode = kCAFillModeForwards;
    [self.alertBackgroundView.layer addAnimation:keyframeAnimation forKey:@"showAlert"];
}

- (void)dismissAnimated:(BOOL)animated {

    if (animated) {

        [UIView animateWithDuration:0.2
                         animations:^{

                             self.alpha = 0;
                         } completion:^(BOOL finished) {

                             [self removeGestureRecognizer:self.alertBackgroundTap];
                             [self.showWindow resignKeyWindow];
                             self.showWindow = nil;
                             [self removeFromSuperview];
                         }];
    } else {

        [self removeGestureRecognizer:self.alertBackgroundTap];
        [self.showWindow resignKeyWindow];
        self.showWindow = nil;
        [self removeFromSuperview];
    }
}

- (void)dismiss {
    [self dismissAnimated:YES];
}

#pragma mark - event
- (void)alertTapped:(UITapGestureRecognizer *)sender {

    [self endEditing:YES];
    if (self.dismissOnBlankAreaTapped) {

        CGPoint touchPoint = [sender locationInView:self];
        if (!CGRectContainsPoint(self.bounds, touchPoint)) {

            [self dismiss];
        }
    }
}

@end
