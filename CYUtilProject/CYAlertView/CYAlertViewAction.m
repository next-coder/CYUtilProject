//
//  CYAlertViewAction.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/15/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYAlertViewAction.h"
#import "CYAlertView.h"

@interface CYAlertViewAction ()

// 关联的alertView，在添加到alertView之后有效
@property (nonatomic, weak, readwrite) CYAlertView *alertView;

@end

@implementation CYAlertViewAction

- (instancetype)initWithTitle:(NSString *)title
                      handler:(CYAlertViewActionHandler)handler {

    if (self = [super init]) {

        _handler = handler;
        _dismissAlert = YES;

        [self setTitle:title forState:UIControlStateNormal];
        self.normalBackgroundColor = [UIColor clearColor];
        self.highlightedBackgroundColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.f];
        [self addTarget:self
                 action:@selector(actionDidTapped:)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor {
    _normalBackgroundColor = normalBackgroundColor;

    if (!self.highlighted) {
        self.backgroundColor = _normalBackgroundColor;
    }
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    _highlightedBackgroundColor = highlightedBackgroundColor;

    if (self.highlighted) {
        self.backgroundColor = _highlightedBackgroundColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    self.backgroundColor = (highlighted ? self.highlightedBackgroundColor : self.normalBackgroundColor);
}

- (void)actionDidTapped:(id)sender {

    if (self.handler) {

        self.handler(self.alertView, self);
    }
    if (self.dismissAlert) {

        [self.alertView dismiss];
    }
}

@end
