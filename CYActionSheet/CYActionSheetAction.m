//
//  CYActionSheetAction.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/18/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYActionSheetAction.h"
#import "CYActionSheet.h"

@implementation CYActionSheetAction

- (instancetype)initWithTitle:(NSString *)title handler:(CYActionSheetActionHandler)handler {
    
    if (self = [super init]) {
        
        _handler = handler;
        _dismissActionSheet = YES;
        
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [self setTitle:title forState:UIControlStateNormal];
        [self addTarget:self
                 action:@selector(actionDidTapped:)
       forControlEvents:UIControlEventTouchUpInside];
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)actionDidTapped:(id)sender {
    
    if (self.handler) {
        
        self.handler(self);
    }
    if (self.dismissActionSheet) {
        
        [self.actionSheet dismissAnimated:YES];
    }
}

@end
