//
//  CYAlertView+AdditionalView.m
//  CYUtilProject
//
//  Created by xn011644 on 04/05/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYAlertView+AdditionalView.h"

@implementation CYAlertView (AdditionalView)

- (void)addBackgroundView:(UIView *)backgroundView
               atPosition:(CGPoint)position {

    backgroundView.center = position;
    [self addSubview:backgroundView];
    [self sendSubviewToBack:backgroundView];
}

- (void)addGlobalView:(UIView *)view
           atPosition:(CGPoint)position {

    view.center = position;
    [self addSubview:view];
}

@end
