//
//  XNSegmentedView.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 6/30/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYPlainSegmentedView.h"

@interface CYPlainSegmentedView ()

@property (nonatomic, weak) UIImageView *selectedBottomImageView;
@property (nonatomic, strong) NSArray *itemViews;
@property (nonatomic, strong) NSArray *itemSeparatorViews;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation CYPlainSegmentedView

static const NSInteger badgeDefaultTag = 57363;

static const NSInteger segmentedItemStartTag = 12313;

- (instancetype)initWithFrame:(CGRect)frame {
    
    return [self initWithItemTitles:nil];
}

- (instancetype)initWithItemTitles:(NSArray *)itemTitles {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)]) {
        
        _itemTitles = itemTitles;
        [self createSelectedBottom];
        [self createItemViews];
        [self createBottomLineView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelectedBottomImage:(UIImage *)selectedBottomImage {
    
    _selectedBottomImage = selectedBottomImage;
    self.selectedBottomImageView.image = _selectedBottomImage;
    if (_selectedBottomImage) {

        self.selectedBottomImageView.backgroundColor = [UIColor clearColor];
    } else if (self.selectedBottomColor) {

        self.selectedBottomImageView.backgroundColor = self.selectedBottomColor;
    }
}

- (void)setSelectedBottomColor:(UIColor *)selectedBottomColor {

    _selectedBottomColor = selectedBottomColor;
    if (!self.selectedBottomImage) {

        self.selectedBottomImageView.backgroundColor = _selectedBottomColor;
    }
}

- (void)setItemTitles:(NSArray *)itemTitles {
    
    _itemTitles = itemTitles;
    [self createItemViews];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    [self refreshSelectedViewsWithIndex:selectedIndex
                    originSelectedIndex:_selectedIndex
                              Animation:YES];
    _selectedIndex = selectedIndex;
}

#pragma mark - action
- (void)didSelectedItem:(UIButton *)item {
    
    NSInteger index = item.tag - segmentedItemStartTag;
    [self refreshSelectedViewsWithIndex:index
                    originSelectedIndex:_selectedIndex
                              Animation:YES];
    
    _selectedIndex = index;
    
    if (_delegate) {
        
        [_delegate segmentedViewDidSelectItemAtIndex:_selectedIndex];
    }
}

- (void)refreshSelectedViewsWithIndex:(NSInteger)currentIndex
                  originSelectedIndex:(NSInteger)originSelectedIndex
                            Animation:(BOOL)animated {
    
    if (currentIndex == originSelectedIndex) {
        
        return;
    }
    UIButton *originSelectedItem = [_itemViews objectAtIndex:_selectedIndex];
    originSelectedItem.selected = NO;
    
    UIButton *selectedItem = [_itemViews objectAtIndex:currentIndex];
    selectedItem.selected = YES;
    
    if (animated) {
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.2f];
    }
    _selectedBottomImageView.center = CGPointMake(selectedItem.center.x,
                                                  _selectedBottomImageView.center.y);
    if (animated) {
        
        [UIView commitAnimations];
    }
}

#pragma mark - subviews
- (void)createSelectedBottom {
    
    UIImageView *bottomSelected = [[UIImageView alloc] init];
    bottomSelected.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomSelected];
    _selectedBottomImageView = bottomSelected;
}

- (void)createItemViews {
    
    if (_itemViews
        && [_itemViews count] > 0) {
        
        [_itemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            
            [view removeFromSuperview];
        }];
    }
    
    if (_itemTitles
        && [_itemTitles count] > 0) {
        
        NSInteger itemCount = [_itemTitles count];
        NSMutableArray *itemViews = [NSMutableArray arrayWithCapacity:itemCount];
        [_itemTitles enumerateObjectsUsingBlock:^(NSString *itemTitle, NSUInteger idx, BOOL *stop) {
            
            UIButton *item = [self getItemButtonWithTitle:itemTitle];
            item.tag = idx + segmentedItemStartTag;
            [self addSubview:item];
            [itemViews addObject:item];

            if (idx == _selectedIndex) {
                
                item.selected = YES;
            }
        }];
        _itemViews = itemViews;
    }
}

- (UIButton *)getItemButtonWithTitle:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:90/255.f green:90/255.f blue:90/255.f alpha:1]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:90/255.f green:90/255.f blue:90/255.f alpha:1]
                 forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:253/255.f green:136/255.f blue:73/255.f alpha:1]
                 forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button addTarget:self
               action:@selector(didSelectedItem:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)getSeparatorView {
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor colorWithRed:200/255.f
                                                green:200/255.f
                                                 blue:200/255.f
                                                alpha:1];
    return separator;
}

- (void)createBottomLineView {
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithRed:238/255.f
                                                 green:238/255.f
                                                  blue:238/255.f
                                                 alpha:1];
    [self addSubview:bottomLine];
    _bottomLineView = bottomLine;
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_itemViews
        && [_itemViews count] > 0) {
        
        NSInteger itemCount = [_itemViews count];
        CGFloat itemGapWidth = 2;
        CGFloat itemWidth = (self.frame.size.width - itemGapWidth * (itemCount - 1)) / (CGFloat)itemCount;
        [_itemViews enumerateObjectsUsingBlock:^(UIButton *itemView, NSUInteger idx, BOOL *stop) {
            
            itemView.frame = CGRectMake(idx * (itemWidth + itemGapWidth),
                                        0,
                                        itemWidth,
                                        self.frame.size.height);
        }];
        [_itemSeparatorViews enumerateObjectsUsingBlock:^(UIView *itemSeparatorView, NSUInteger idx, BOOL *stop) {
            
            itemSeparatorView.frame = CGRectMake((idx + 1) * itemWidth + idx * itemGapWidth,
                                                 10,
                                                 itemGapWidth,
                                                 self.frame.size.height - 10 * 2);
        }];
        _selectedBottomImageView.frame = CGRectMake(_selectedIndex * (itemWidth + itemGapWidth) + itemWidth / 6.f,
                                                    self.frame.size.height - 2.f,
                                                    itemWidth * 2 / 3.f,
                                                    2.f);
        [self bringSubviewToFront:_selectedBottomImageView];
    }
    
    _bottomLineView.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
}

@end
