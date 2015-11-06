//
//  CYCycleBannerView.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/4/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYCycleBannerView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, weak, readonly) UIPageControl *pageControl;

// 图片数组，可以是UIImage，NSString，NSURL
@property (nonatomic, copy, readonly) NSArray *images;
@property (nonatomic, strong, readonly) UIImage *placeholder;
// 是否循环滚动
@property (nonatomic, assign, readonly, getter=isContinuous) BOOL continuous;

- (void)setImages:(NSArray *)images placeholder:(UIImage *)placeholder continuous:(BOOL)continuous;

@end
