//
//  UIView.m
//  CYUtilProject
//
//  Created by xn011644 on 22/08/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "UIView+Animatable.h"

@interface CYViewAnimationLayer : CALayer

@property (nonatomic, assign) CGFloat animationProperty;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

@property (nonatomic, copy, readonly) CYAnimatableProgress progressBlock;
@property (nonatomic, copy, readonly) CYAnimatableCompletion completionBlock;

@end

@implementation CYViewAnimationLayer

- (instancetype)initWithProgress:(CYAnimatableProgress)progress
                      completion:(CYAnimatableCompletion)completion {
    if (self = [super init]) {

        _progressBlock = progress;
        _completionBlock = completion;

        self.opaque = NO;
    }
    return self;
}

@end

@implementation UIView (Animatable)

static NSString *const animationLayerName = @"__animationLayerName__";
static NSString *const animationLayerEvent = @"animationProperty";

- (void)startAnimationWithProgress:(CYAnimatableProgress)progressBlock
                        completion:(CYAnimatableCompletion)completionBlock {

    CYViewAnimationLayer *animationLayer = nil;
    if (!animationLayer) {
        animationLayer = [[CYViewAnimationLayer alloc] initWithProgress:progressBlock
                                                             completion:completionBlock];
        animationLayer.delegate = self;
        animationLayer.name = animationLayerName;
        animationLayer.opaque = NO;
        [self.layer addSublayer:animationLayer];
    }
}

#pragma mark - CALayerDelegate
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {

    if ([layer.name isEqualToString:animationLayerName]
        && [event isEqualToString:animationLayerEvent]) {
        CYViewAnimationLayer *animationLayer = (CYViewAnimationLayer *)layer;

        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.fromValue = @0;
        animation.duration = animationLayer.duration;
        animation.timingFunction = animationLayer.timingFunction;
        animation.delegate = self;
        return animation;
    }
    return nil;
}

- (void)displayLayer:(CALayer *)layer {

    if ([layer.name isEqualToString:animationLayerName]) {

        CYViewAnimationLayer *animationLayer = (CYViewAnimationLayer *)layer;
        CYViewAnimationLayer *presentationLayer = animationLayer.presentationLayer;
        if (animationLayer.animationProperty != 0
            && animationLayer.progressBlock) {

            animationLayer.progressBlock(presentationLayer.animationProperty / animationLayer.animationProperty);
        }
    }

}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {


}

@end
