//
//  CYChatInputMorePadView.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/29/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#define CY_CHAT_INPUT_MORE_PAD_ITEMS_PER_ROW 4
#define CY_CHAT_INPUT_MORE_PAD_COLUMNS_PER_PAGE 2
#define CY_CHAT_INPUT_MORE_PAD_ITEM_WIDTH 59
#define CY_CHAT_INPUT_MORE_PAD_ITEM_HEIGHT 85
#define CY_CHAT_INPUT_MORE_PAD_VERTICAL_GAP 20

#import "CYChatInputMorePadView.h"
#import "NSString+CYUtils.h"

@interface CYChatInputMorePadView ()

@end

@implementation CYChatInputMorePadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
//        [self createChatInputMorePadViewSubviews];
        _items = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_pageControl sizeToFit];
    _pageControl.center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height - _pageControl.frame.size.height);
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat herizontalGap = (screenWidth - CY_CHAT_INPUT_MORE_PAD_ITEM_WIDTH * CY_CHAT_INPUT_MORE_PAD_ITEMS_PER_ROW) / (CY_CHAT_INPUT_MORE_PAD_ITEMS_PER_ROW + 1);
    [_items enumerateObjectsUsingBlock:^(CYChatInputMorePadItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        NSInteger coloumn = (idx -1) % CY_CHAT_INPUT_MORE_PAD_ITEMS_PER_ROW;
        NSInteger page = (idx - 1) / (CY_CHAT_INPUT_MORE_PAD_ITEMS_PER_ROW * CY_CHAT_INPUT_MORE_PAD_COLUMNS_PER_PAGE);
        NSInteger row = (idx - page * (CY_CHAT_INPUT_MORE_PAD_ITEMS_PER_ROW * CY_CHAT_INPUT_MORE_PAD_COLUMNS_PER_PAGE)) / CY_CHAT_INPUT_MORE_PAD_ITEMS_PER_ROW;
        CGFloat originX = page * screenWidth + coloumn * (CY_CHAT_INPUT_MORE_PAD_ITEM_WIDTH + herizontalGap) + herizontalGap;
        CGFloat originY = row * (CY_CHAT_INPUT_MORE_PAD_VERTICAL_GAP + CY_CHAT_INPUT_MORE_PAD_ITEM_HEIGHT) + CY_CHAT_INPUT_MORE_PAD_VERTICAL_GAP;
        
        item.frame = CGRectMake(originX, originY, CY_CHAT_INPUT_MORE_PAD_ITEM_WIDTH, CY_CHAT_INPUT_MORE_PAD_ITEM_HEIGHT);
    }];
    
}

- (void)createChatInputMorePadViewSubviews {
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.backgroundColor = [UIColor clearColor];
    [self addSubview:scroll];
    _scrollView = scroll;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:pageControl];
    _pageControl = pageControl;
}

- (void)addItem:(CYChatInputMorePadItem *)item {
    
    [_items addObject:item];
    [_scrollView addSubview:item];
}

@end
