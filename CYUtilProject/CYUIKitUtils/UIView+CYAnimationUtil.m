//
//  UIView+CYAnimationUtil.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 12/30/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "UIView+CYAnimationUtil.h"

@interface CYViewAnimatedLayer : CALayer

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat animationProperty;

@property (nonatomic, copy) CYAnimationProgress animationProgress;
@property (nonatomic, copy) CYAnimationCompletion animationCompletion;

@end

@implementation CYViewAnimatedLayer

@dynamic animationProperty;

- (void)dealloc {
    
    _animationProgress = nil;
    _animationCompletion = nil;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        _animationDuration = 2.f;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    
    if ([@"animationProperty" isEqualToString:key]) {
        
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (id<CAAction>)actionForKey:(NSString *)key {
    
    if ([key isEqualToString:@"animationProperty"]) {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = @0;
        animation.duration = _animationDuration;
        animation.delegate = self;
        return animation;
    }
    return [super actionForKey:key];
}

- (void)display {
    
    if (_animationProgress) {
        
        CGFloat totalValue = self.animationProperty;
        CGFloat currentValue = [[self presentationLayer] animationProperty];
        CGFloat progress = currentValue / totalValue;
        _animationProgress(progress);
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if ([anim isKindOfClass:[CABasicAnimation class]]) {
        
        NSString *keyPath = ((CABasicAnimation *)anim).keyPath;
        if ([keyPath isEqualToString:@"animationProperty"]
            && _animationCompletion) {
            
            _animationCompletion(YES);
        }
    }
    self.animationProgress = nil;
    self.animationCompletion = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self removeFromSuperlayer];
    });
}

@end

@implementation UIView (CYAnimationUtil)

- (void)cy_animateWithDuration:(NSTimeInterval)duration
             animationProgress:(CYAnimationProgress)progress
           animationCompletion:(CYAnimationCompletion)completion {
    
    CYViewAnimatedLayer *layer = [[CYViewAnimatedLayer alloc] init];
    layer.animationProgress = progress;
    layer.animationCompletion = completion;
    layer.animationDuration = duration;
    layer.animationProperty += duration;
    [self.layer addSublayer:layer];
}

@end
