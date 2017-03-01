//
//  XNSegmentedScrollContentView.h
//  MoneyJar2
//
//  Created by xn011644 on 6/8/16.
//  Copyright © 2016 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CYPlainSegmentedView.h"

@interface CYSegmentedScrollContentView : UIView

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, weak, readonly) CYPlainSegmentedView *segmentedView;

@property (nonatomic, strong, readonly) NSArray *itemTitles;
@property (nonatomic, strong, readonly) NSArray *contentViews;

- (instancetype)initWithFrame:(CGRect)frame
                   itemTitles:(NSArray *)itemTitles
                 contentViews:(NSArray *)contentViews;

- (void)releaseResources;

@end
