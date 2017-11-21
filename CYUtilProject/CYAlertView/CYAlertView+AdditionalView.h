//
//  CYAlertView+AdditionalView.h
//  CYUtilProject
//
//  Created by xn011644 on 04/05/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYAlertView.h"

@interface CYAlertView (AdditionalView)

// the next two methds add view at anywhere
// add view between dark transparent background and white background area
- (void)addBackgroundView:(UIView *)backgroundView
               atPosition:(CGPoint)position;
// add view on the top
- (void)addGlobalView:(UIView *)view
           atPosition:(CGPoint)position;

@end
