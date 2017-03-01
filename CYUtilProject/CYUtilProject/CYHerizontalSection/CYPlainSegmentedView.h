//
//  XNSegmentedView.h
//  MoneyJar2
//
//  Created by HuangQiSheng on 6/30/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CYPlainSegmentedViewDelegate <NSObject>

- (void)segmentedViewDidSelectItemAtIndex:(NSUInteger)index;

@end

@interface CYPlainSegmentedView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<CYPlainSegmentedViewDelegate> delegate;

@property (nonatomic, strong) NSArray *itemTitles;

// will be ignore if selectedBottomImage is not nil
@property (nonatomic, strong) UIColor *selectedBottomColor;
@property (nonatomic, strong) UIImage *selectedBottomImage;

- (instancetype)initWithItemTitles:(NSArray *)itemTitles;

@end
