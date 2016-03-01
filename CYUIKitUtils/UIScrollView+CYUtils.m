//
//  UIScrollView+CYUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/28/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "UIScrollView+CYUtils.h"

@implementation UIScrollView (CYUtils)

- (void)scrollToBottomAnimated:(BOOL)animated {
    
    CGRect bottomRect = CGRectMake(self.contentOffset.x,
                                   self.contentSize.height,
                                   self.frame.size.width,
                                   self.frame.size.height);
    
    if (animated) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self scrollRectToVisible:bottomRect animated:NO];
        }];
    } else {
        
        [self scrollRectToVisible:bottomRect animated:NO];
    }
}

- (void)scrollToTopAnimated:(BOOL)animated {
    
    CGRect topRect = CGRectMake(self.contentOffset.x,
                                0,
                                self.frame.size.width,
                                self.frame.size.height);
    
    if (animated) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self scrollRectToVisible:topRect animated:NO];
        }];
    } else {
        
        [self scrollRectToVisible:topRect animated:NO];
    }
}

@end
