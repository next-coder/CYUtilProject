//
//  CYChatInputMorePadView.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/29/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CYChatInputMorePadItem.h"

@interface CYChatInputMorePadView : UIView

@property (nonatomic, strong, readonly) NSMutableArray *items;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

- (void)addItem:(CYChatInputMorePadItem *)item;

@end
