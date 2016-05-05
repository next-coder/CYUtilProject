//
//  CYBannerImageBrowserView.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/4/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYBannerImageBrowserView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, copy, readonly) NSArray *images;
@property (nonatomic, strong, readonly) UIImage *placeholder;
@property (nonatomic, assign, readonly) NSInteger firstShowingIndex;

// default YES
@property (nonatomic, assign) BOOL dismissOnTap;
// default YES
@property (nonatomic, assign) BOOL zoomingEnabled;

- (void)setImages:(NSArray *)images placeholder:(UIImage *)placeholder firstShowingIndex:(NSInteger)index;

#pragma mark - show
- (void)showInKeyWindowFromRect:(CGRect)rect;
- (void)showFromRect:(CGRect)rect
              inView:(UIView *)view;

#pragma mark - dismiss
// animated dismiss to specific rect
- (void)dismissToRect:(CGRect)rect;
// animated dismiss to show rect
- (void)dismiss;

#pragma mark - static show
+ (instancetype)showImagesInKeyWindow:(NSArray *)images
                          placeholder:(UIImage *)placeholder
                    firstShowingIndex:(NSInteger)index
                             fromRect:(CGRect)rect;

+ (instancetype)showImages:(NSArray *)images
               placeholder:(UIImage *)placeholder
         firstShowingIndex:(NSInteger)index
                  fromRect:(CGRect)rect
                    inView:(UIView *)view;

@end
