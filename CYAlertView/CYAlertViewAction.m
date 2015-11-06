//
//  CYAlertViewAction.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/15/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYAlertViewAction.h"
#import "CYAlertView.h"

@interface CYAlertViewButton : UIButton

@property (nonatomic, weak) CYAlertViewAction *action;

@end

@interface CYAlertViewAction ()

@property (nonatomic, strong, readwrite) UIView *actionView;

@end

@implementation CYAlertViewAction

- (instancetype)initWithTitle:(NSString *)title handler:(CYAlertViewActionHandler)handler {
    
    if (self = [super init]) {
        
        _title = title;
        _handler = handler;
        _enabled = YES;
        _dismissAlert = YES;
    }
    return self;
}

- (UIView *)actionView {
    
    if (!_actionView) {
        
        CYAlertViewButton *actionButton = [CYAlertViewButton buttonWithType:UIButtonTypeCustom];
        actionButton.enabled = _enabled;
        actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        if (_title) {
            [actionButton setTitle:self.title forState:UIControlStateNormal];
        }
        if (_backgroundColor) {
            actionButton.backgroundColor = _backgroundColor;
        } else {
            actionButton.backgroundColor = [UIColor clearColor];
        }
        if (_titleColor) {
            [actionButton setTitleColor:_titleColor forState:UIControlStateNormal];
        } else {
            [actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        if (_highlightedTitleColor) {
            [actionButton setTitleColor:_highlightedTitleColor forState:UIControlStateHighlighted];
        } else {
            [actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        }
        if (_backgroundImage) {
            [actionButton setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
        }
        if (_highlightedBackgroundImage) {
            [actionButton setBackgroundImage:_highlightedBackgroundImage forState:UIControlStateHighlighted];
        }
        if (_image) {
            [actionButton setImage:_image forState:UIControlStateNormal];
        }
        if (_highlightedImage) {
            [actionButton setImage:_highlightedImage forState:UIControlStateHighlighted];
        }
        actionButton.action = self;
        [actionButton addTarget:self
                         action:@selector(actionDidTapped:)
               forControlEvents:UIControlEventTouchUpInside];
        _actionView = actionButton;
    }
    return _actionView;
}

- (void)actionDidTapped:(id)sender {
    
    if (_handler) {
        
        _handler(self);
    }
    if (_dismissAlert) {
        
        [_alertView dismiss];
    }
}

@end

@implementation CYAlertViewButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (!highlighted) {
        
        self.backgroundColor = (_action.backgroundColor ? : [UIColor clearColor]);
    } else {
        
        self.backgroundColor = (_action.highlightedBackgroundColor ? : [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.f]);
    }
}

@end
