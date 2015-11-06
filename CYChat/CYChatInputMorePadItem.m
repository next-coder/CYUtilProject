//
//  CYChatInputMorePadItem.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/30/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatInputMorePadItem.h"

@implementation CYChatInputMorePadItem

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createChatInputMorePadItemSubviews];
        [self createConstraintsForChatInputMorePadItem];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)createChatInputMorePadItemSubviews {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"chat_input_more_cell_background.png"]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"chat_input_more_cell_background_hl.png"]
                      forState:UIControlStateHighlighted];
    [self addSubview:button];
    _itemButton = button;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    _itemLabel = label;
}

- (void)createConstraintsForChatInputMorePadItem {
    
    _itemButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *buttonLayoutCenterX = [NSLayoutConstraint constraintWithItem:_itemButton
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1
                                                                            constant:0];
    NSLayoutConstraint *buttonLayoutCenterY = [NSLayoutConstraint constraintWithItem:_itemButton
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1
                                                                            constant:-10];
    NSLayoutConstraint *buttonLayoutWidth = [NSLayoutConstraint constraintWithItem:_itemButton
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1
                                                                            constant:59];
    NSLayoutConstraint *buttonLayoutHeight = [NSLayoutConstraint constraintWithItem:_itemButton
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1
                                                                            constant:59];
    [self addConstraints:@[ buttonLayoutCenterX, buttonLayoutCenterY, buttonLayoutWidth, buttonLayoutHeight ]];
    
    _itemLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *labelLayoutCenterX = [NSLayoutConstraint constraintWithItem:_itemLabel
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1
                                                                            constant:0];
    NSLayoutConstraint *labelLayoutTop = [NSLayoutConstraint constraintWithItem:_itemLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_itemButton
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1
                                                                       constant:3];
    [self addConstraints:@[ labelLayoutCenterX, labelLayoutTop ]];
}

- (void)addTarget:(id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents {
    
    [_itemButton addTarget:target action:action forControlEvents:controlEvents];
}

@end
