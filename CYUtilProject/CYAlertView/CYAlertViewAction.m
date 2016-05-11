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

@end

@implementation CYAlertViewAction

- (instancetype)initWithTitle:(NSString *)title handler:(CYAlertViewActionHandler)handler {
    
    if (self = [super init]) {
        
        _handler = handler;
        _dismissAlert = YES;
        [self setTitle:title
              forState:UIControlStateNormal];
        [self addTarget:self
                 action:@selector(actionDidTapped:)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor {
    
    _normalBackgroundColor = normalBackgroundColor;
    if (!self.highlighted) {
        
        self.backgroundColor = normalBackgroundColor;
    }
}

- (void)actionDidTapped:(id)sender {
    
    if (self.handler) {
        
        self.handler(self.alertView, self);
    }
    if (self.dismissAlert) {
        
        [self.alertView dismiss];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (!highlighted) {
        
        self.backgroundColor = (self.normalBackgroundColor ? : [UIColor clearColor]);
    } else {
        
        self.backgroundColor = (self.highlightedBackgroundColor ? : [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.f]);
    }
}

@end
