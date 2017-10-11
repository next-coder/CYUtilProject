//
//  UIView.h
//  CYUtilProject
//
//  Created by xn011644 on 22/08/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CYAnimatableProgress)(CGFloat progress);
typedef void (^CYAnimatableCompletion)(BOOL finished);

@interface UIView (Animatable) <CALayerDelegate, CAAnimationDelegate>

@end
