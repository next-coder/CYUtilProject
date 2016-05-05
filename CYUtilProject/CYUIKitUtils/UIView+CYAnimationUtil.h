//
//  UIView+CYAnimationUtil.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 12/30/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CYAnimationProgress)(CGFloat progress);
typedef void (^CYAnimationCompletion)(BOOL completed);

@interface UIView (CYAnimationUtil)

- (void)cy_animateWithDuration:(NSTimeInterval)duration
             animationProgress:(CYAnimationProgress)progress
           animationCompletion:(CYAnimationCompletion)completion;

@end
