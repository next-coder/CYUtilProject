//
//  CYVerticalMultiPageView.m
//  CYUtilProject
//
//  Created by xn011644 on 6/8/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYVerticalMultiPageScrollView.h"

@interface CYVerticalMultiPageScrollView ()

@property (nonatomic, strong) NSMutableArray *internalContentViews;
@property (nonatomic, assign) NSUInteger internalCurrentIndex;

@end

@implementation CYVerticalMultiPageScrollView

- (instancetype)initWithFrame:(CGRect)frame
                 contentViews:(NSArray *)contentViews {

    if (self = [super initWithFrame:frame]) {

        if (contentViews
            && contentViews.count > 0) {

            self.internalContentViews = [NSMutableArray arrayWithArray:contentViews];

            UIView *firstView = contentViews[0];

            // add the first view to content
            [self addSubview:firstView];
            firstView.center = CGPointMake(self.frame.size.width / 2.f,
                                           firstView.frame.size.height / 2.f);
        }
    }
    return self;
}


#pragma mark - getter setter
- (NSArray *)contentViews {

    return [self.internalContentViews copy];
}

- (NSUInteger)currentIndex {

    return self.internalCurrentIndex;
}

#pragma mark - add new view
- (void)addContentView:(UIView *)contentView {

    if (!contentView) {

        return;
    }

    if (!self.internalContentViews) {

        self.internalContentViews = [NSMutableArray array];
    }

    if ([self.internalContentViews containsObject:contentView]) {

        return;
    }

    [self.internalContentViews addObject:contentView];
    if (self.internalContentViews.count == 1) {

        // add the first view to content
        [self addSubview:contentView];
        contentView.center = CGPointMake(self.frame.size.width / 2.f,
                                         contentView.frame.size.height / 2.f);
    }
}

#pragma mark - next or previous
static const CGFloat CYContentViewChangeAnimationDuration = 0.3;

- (void)showPreviousViewAnimated:(BOOL)animated {

    [self showViewAtIndex:(self.internalCurrentIndex - 1)
                 animated:animated];
}

- (void)showNextViewAnimated:(BOOL)animated {

    [self showViewAtIndex:(self.internalCurrentIndex + 1)
                 animated:animated];
}

- (void)showViewAtIndex:(NSUInteger)index
               animated:(BOOL)animated {

    if (index == self.currentIndex
        || index > (self.internalContentViews.count - 1)) {

        return;
    }

    // get current show view and will show view
    UIView *currentView = self.internalContentViews[self.internalCurrentIndex];
    UIView *nextShowView = self.internalContentViews[index];

    // add next show view to self, position it at the bottom of self
    [self addSubview:nextShowView];

    CGFloat centerX = self.frame.size.width / 2.f;
    if (animated) {

        if (index > self.currentIndex) {

            nextShowView.center = CGPointMake(centerX,
                                              self.frame.size.height + nextShowView.frame.size.height / 2.f);
            // animated hide current view and show next view
            self.userInteractionEnabled = NO;
            [UIView animateWithDuration:CYContentViewChangeAnimationDuration
                             animations:^{

                                 currentView.center = CGPointMake(centerX,
                                                                  -currentView.frame.size.height);
                                 nextShowView.center = CGPointMake(centerX,
                                                                   nextShowView.frame.size.height / 2.f);
                             }
                             completion:^(BOOL finished) {

                                 self.userInteractionEnabled = YES;
                                 [currentView removeFromSuperview];
                             }];

        } else {

            nextShowView.center = CGPointMake(centerX, -nextShowView.frame.size.height / 2.f);
            // animated hide current view and show next view
            self.userInteractionEnabled = NO;
            [UIView animateWithDuration:CYContentViewChangeAnimationDuration
                             animations:^{

                                 currentView.center = CGPointMake(centerX,
                                                                  self.frame.size.height + currentView.frame.size.height);
                                 nextShowView.center = CGPointMake(centerX,
                                                                   nextShowView.frame.size.height / 2.f);
                             }
                             completion:^(BOOL finished) {

                                 self.userInteractionEnabled = YES;
                                 [currentView removeFromSuperview];
                             }];
        }
    } else {

        nextShowView.center = CGPointMake(centerX,
                                          nextShowView.frame.size.height / 2.f);
        [currentView removeFromSuperview];
    }

    // reset index
    self.internalCurrentIndex = index;
}

@end
