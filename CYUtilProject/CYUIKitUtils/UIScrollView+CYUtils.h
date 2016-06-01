//
//  UIScrollView+CYUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/28/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CYUtils)

- (void)cy_scrollToBottomAnimated:(BOOL)animated;
- (void)cy_scrollToTopAnimated:(BOOL)animated;

@end
