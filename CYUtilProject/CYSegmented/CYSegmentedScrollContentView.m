//
//  XNSegmentedScrollContentView.m
//  MoneyJar2
//
//  Created by xn011644 on 6/8/16.
//  Copyright © 2016 GK. All rights reserved.
//

#import "CYSegmentedScrollContentView.h"

@implementation CYSegmentedScrollContentView

- (void)dealloc {

    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)releaseResources {

    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (instancetype)initWithFrame:(CGRect)frame
                   itemTitles:(NSArray *)itemTitles
                 contentViews:(NSArray *)contentViews {

    if (self = [super initWithFrame:frame]) {

        _itemTitles = itemTitles;
        _contentViews = contentViews;

        [self createSubviews];
        [self createConstraintsForSubviews];
    }
    return self;
}

- (void)createSubviews {

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    _scrollView = scrollView;

    [_scrollView addObserver:self
                  forKeyPath:@"contentOffset"
                     options:NSKeyValueObservingOptionNew
                     context:nil];

    CYPlainSegmentedView *segmentedView = [[CYPlainSegmentedView alloc] initWithItemTitles:self.itemTitles];
    [self addSubview:segmentedView];
    _segmentedView = segmentedView;
}

- (void)createConstraintsForSubviews {

    NSLayoutConstraint *segmentedTop = [NSLayoutConstraint constraintWithItem:_segmentedView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1
                                                                     constant:0];
    NSLayoutConstraint *segmentedLeft = [NSLayoutConstraint constraintWithItem:_segmentedView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1
                                                                      constant:0];
    NSLayoutConstraint *segmentedRight = [NSLayoutConstraint constraintWithItem:_segmentedView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1
                                                                       constant:0];
    NSLayoutConstraint *segmentedHeight = [NSLayoutConstraint constraintWithItem:_segmentedView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:50];

    [self addConstraints:@[ segmentedTop, segmentedLeft, segmentedRight, segmentedHeight ]];

    NSLayoutConstraint *scrollTop = [NSLayoutConstraint constraintWithItem:_scrollView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_segmentedView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1
                                                                  constant:0];
    NSLayoutConstraint *scrollLeft = [NSLayoutConstraint constraintWithItem:_scrollView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:0];
    NSLayoutConstraint *scrollRight = [NSLayoutConstraint constraintWithItem:_scrollView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:0];
    NSLayoutConstraint *scrollHeight = [NSLayoutConstraint constraintWithItem:_scrollView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:0];
    [self addConstraints:@[ scrollTop, scrollLeft, scrollRight, scrollHeight ]];

    __block UIView *previousView = nil;
    [_contentViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {

        [_scrollView addSubview:view];

        NSLayoutConstraint *contentLeft = nil;
        if (previousView) {

            contentLeft = [NSLayoutConstraint constraintWithItem:view
                                                       attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:previousView
                                                       attribute:NSLayoutAttributeRight
                                                      multiplier:1
                                                        constant:0];
        } else {

            contentLeft = [NSLayoutConstraint constraintWithItem:view
                                                       attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:_scrollView
                                                       attribute:NSLayoutAttributeLeft
                                                      multiplier:1
                                                        constant:0];
        }

        NSLayoutConstraint *contentTop = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_scrollView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1
                                                                       constant:0];
        NSLayoutConstraint *contentBottom = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_scrollView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1
                                                                       constant:0];
        NSLayoutConstraint *contentWidth = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_scrollView
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1
                                                                         constant:0];

        if (idx == (_contentViews.count - 1)) {

            NSLayoutConstraint *contentRight = [NSLayoutConstraint constraintWithItem:view
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_scrollView
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1
                                                                             constant:0];
            [_scrollView addConstraints:@[ contentLeft, contentTop, contentBottom, contentWidth, contentRight ]];
        } else {

            [_scrollView addConstraints:@[ contentLeft, contentTop, contentBottom, contentWidth ]];
        }

        // reset previous view
        previousView = view;
    }];
}

// kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"contentOffset"]) {

        CGPoint contentOffset = self.scrollView.contentOffset;
        CGFloat scrollWidth = self.scrollView.frame.size.width;
        NSInteger index = (NSInteger)((contentOffset.x + scrollWidth / 2.f) / scrollWidth);
        self.segmentedView.selectedIndex = index;
    }
}

@end
