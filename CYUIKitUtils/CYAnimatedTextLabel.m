//
//  CYAnimatedContentLabel.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/29/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYAnimatedTextLabel.h"

@interface CYAnimatedTextLabelLayer : CALayer

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat animationProperty;
@property (nonatomic, weak) CYAnimatedTextLabel *animateLabel;

@end

@interface CYAnimatedTextLabel ()

@property (nonatomic, strong) CYAnimatedTextLabelLayer *animatedTextLabelLayer;

- (void)animationDidProcessing:(CGFloat)progress;
- (void)animationTextDidEnd;

@end

@implementation CYAnimatedTextLabelLayer

@dynamic animationProperty;

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
    
    if (_animateLabel) {
        
        CGFloat totalValue = self.animationProperty;
        CGFloat currentValue = [[self presentationLayer] animationProperty];
        CGFloat progress = currentValue / totalValue;
        [_animateLabel animationDidProcessing:progress];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if ([anim isKindOfClass:[CABasicAnimation class]]) {
        
        NSString *keyPath = ((CABasicAnimation *)anim).keyPath;
        if ([keyPath isEqualToString:@"animationProperty"]) {
            
            [_animateLabel animationTextDidEnd];
        }
    }
}

@end


@implementation CYAnimatedTextLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _animatedTextLabelLayer = [CYAnimatedTextLabelLayer layer];
        _animatedTextLabelLayer.animateLabel = self;
        [self.layer addSublayer:_animatedTextLabelLayer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _animatedTextLabelLayer = [CYAnimatedTextLabelLayer layer];
        _animatedTextLabelLayer.animateLabel = self;
        [self.layer addSublayer:_animatedTextLabelLayer];
    }
    return self;
}

- (void)animationDidProcessing:(CGFloat)progress {
    
    if (_delegate) {
        
        self.text = [_delegate textWithAnimationProgress:progress];
    }
}

- (void)animationTextDidEnd {
    
    if (_delegate) {
        
        [_delegate textAniamtionDidEnd];
    }
}

- (void)startAnimatingTextWithDuration:(CGFloat)duration {
    
    _animatedTextLabelLayer.animationDuration = duration;
    _animatedTextLabelLayer.animationProperty += duration;
}

@end
