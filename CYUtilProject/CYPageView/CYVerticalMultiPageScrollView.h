//
//  CYVerticalMultiPageView.h
//  CYUtilProject
//
//  Created by xn011644 on 6/8/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYVerticalMultiPageScrollView : UIView

@property (nonatomic, strong, readonly) NSArray *contentViews;

@property (nonatomic, assign, readonly) NSUInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame
                 contentViews:(NSArray *)contentViews;

// add content view,
// you can add content view at any time you want,
// even after the the view has showed
- (void)addContentView:(UIView *)contentView;

// show view
- (void)showPreviousViewAnimated:(BOOL)animated;
- (void)showNextViewAnimated:(BOOL)animated;
- (void)showViewAtIndex:(NSUInteger)index
               animated:(BOOL)animated;

@end
