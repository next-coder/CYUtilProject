//
//  CYActionSheet.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/18/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYActionSheet.h"
#import "CYActionSheetAction.h"
#import "CYActionSheetSection.h"

#define CY_ACTION_SHEET_GAP_BETWEEN_SECTIONS        10
#define CY_ACTION_SHEET_SECTION_BORDER_GAP          20

#define CY_ACTION_SHEET_SECTION_SEPARATOR_COLOR ([UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.f])

@interface CYActionSheet ()

@property (nonatomic, strong, readwrite) NSMutableArray<CYActionSheetSection *> *internalSections;
@property (nonatomic, strong, readwrite) CYActionSheetSection *cancelSection;

@property (nonatomic, strong, readwrite) NSMutableArray<UIView *> *separatorViews;

@property (nonatomic, strong) UIWindow *showWindow;
@property (nonatomic, strong) UIWindow *originWindow;

@end

@implementation CYActionSheet

- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                              style:(CYActionSheetStyle)style {
    
    if (self = [super init]) {
        
        _cancelTitle = cancelTitle;
        _style = style;
        _dimissOnBlankAreaTapped = YES;
        _showSeperatorForSections = YES;
        
        [self addActionSheetSubviews];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(actionSheetTapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)addActionSheetSubviews {
    
    UIView *content = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:content];
    _contentView = content;
    if (self.style == CYActionSheetStyleGrouped) {
        
        content.backgroundColor = [UIColor clearColor];
    } else {
        
        content.backgroundColor = [UIColor whiteColor];
    }
    
    if (_cancelTitle
        && ![_cancelTitle isEqualToString:@""]) {
        
        CYActionSheetAction *action = [[CYActionSheetAction alloc] initWithTitle:_cancelTitle
                                                                         handler:nil];
        CYActionSheetSection *section = [[CYActionSheetSection alloc] initWithTitle:nil
                                                                            message:nil
                                                                       contentViews:@[ action ]];
        section.actionSheet = self;
        [_contentView addSubview:section];
        _cancelSection = section;
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.frame = self.superview.bounds;
}

#pragma mark - getter
- (UIWindow *)showWindow {
    
    if (!_showWindow) {
        
        _showWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _showWindow.backgroundColor = [UIColor clearColor];
    }
    return _showWindow;
}

#pragma mark - getter
- (NSMutableArray<CYActionSheetSection *> *)internalSections {
    
    if (!_internalSections) {
        
        _internalSections = [NSMutableArray array];
    }
    return _internalSections;
}

- (NSArray<CYActionSheetSection *> *)sections {
    
    return [self.internalSections copy];
}

- (BOOL)showSeperatorForSections {
    
    return (_showSeperatorForSections && self.style == CYActionSheetStylePlain);
}

#pragma mark - add section
- (void)addActionSheetSection:(CYActionSheetSection *)section {
    
    if (section) {
        
        section.actionSheet = self;
        [self.internalSections addObject:section];
        [self.contentView addSubview:section];
        
        if (self.style == CYActionSheetStyleGrouped) {
            
            section.layer.cornerRadius = 10.f;
            section.clipsToBounds = YES;
        }
        
        if (self.showSeperatorForSections) {
            
            if (!self.separatorViews) {
                
                self.separatorViews = [NSMutableArray array];
            }
            
            UIView *separator = [[UIView alloc] init];
            separator.backgroundColor = CY_ACTION_SHEET_SECTION_SEPARATOR_COLOR;
            [self.contentView addSubview:separator];
            [self.separatorViews addObject:separator];
        }
    }
}

#pragma mark - layout
- (void)refreshLayout {
    
    CGFloat sectionFrameWidth = 0;
    CGFloat sectionFrameX = 0;
    if (self.style == CYActionSheetStylePlain) {
        
        sectionFrameWidth = self.frame.size.width;
    } else {
        
        sectionFrameWidth = self.frame.size.width - 2 * CY_ACTION_SHEET_SECTION_BORDER_GAP;
        sectionFrameX = CY_ACTION_SHEET_SECTION_BORDER_GAP;
    }
    __block CGFloat nextY = 0;
    [self.internalSections enumerateObjectsUsingBlock:^(CYActionSheetSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.frame = CGRectMake(sectionFrameX, nextY, sectionFrameWidth, obj.frame.size.height);
        nextY += obj.frame.size.height;
        if (self.style == CYActionSheetStyleGrouped) {
            
            nextY += CY_ACTION_SHEET_GAP_BETWEEN_SECTIONS;
        }
        if (self.showSeperatorForSections) {
            
            // layout separator
            UIView *separator = self.separatorViews[idx];
            separator.frame = CGRectMake(self.separatorInsets.left,
                                         nextY,
                                         self.frame.size.width - self.separatorInsets.left - self.separatorInsets.right,
                                         0.5);
            
            nextY += 1;
        }
    }];
    
    if (self.cancelSection) {
        
        self.cancelSection.frame = CGRectMake(sectionFrameX, nextY, sectionFrameWidth, self.cancelSection.frame.size.height);
        nextY += self.cancelSection.frame.size.height;
        if (self.style == CYActionSheetStyleGrouped) {
            
            nextY += CY_ACTION_SHEET_GAP_BETWEEN_SECTIONS;
        }
    } else {
        
        // 没有cancel section时，减去多加的分割线高度
        nextY -= 1;
    }
    
    self.contentView.frame = CGRectMake(0, self.frame.size.height - nextY, self.frame.size.width, nextY);
}

//- (void)layoutSection:(CYActionSheetSection *)section
//     withUnderSection:(CYActionSheetSection *)underSection
//     verticalConstant:(CGFloat)verticalConstant {
//    
//    section.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    NSLayoutConstraint *layoutLeft = [NSLayoutConstraint constraintWithItem:section
//                                                                  attribute:NSLayoutAttributeLeft
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:self.contentView
//                                                                  attribute:NSLayoutAttributeLeft
//                                                                 multiplier:1
//                                                                   constant:0];
//    NSLayoutConstraint *layoutRight = [NSLayoutConstraint constraintWithItem:section
//                                                                   attribute:NSLayoutAttributeRight
//                                                                   relatedBy:NSLayoutRelationEqual
//                                                                      toItem:self.contentView
//                                                                   attribute:NSLayoutAttributeRight
//                                                                  multiplier:1
//                                                                    constant:0];
//    NSLayoutConstraint *layoutTop = nil;
//    
//    if (!underSection) {
//        
//        layoutTop = [NSLayoutConstraint constraintWithItem:section
//                                                 attribute:NSLayoutAttributeBottom
//                                                 relatedBy:NSLayoutRelationEqual
//                                                    toItem:self.contentView
//                                                 attribute:NSLayoutAttributeBottom
//                                                multiplier:1
//                                                  constant:-verticalConstant];
//    } else {
//        
//        layoutTop = [NSLayoutConstraint constraintWithItem:section
//                                                 attribute:NSLayoutAttributeBottom
//                                                 relatedBy:NSLayoutRelationEqual
//                                                    toItem:underSection
//                                                 attribute:NSLayoutAttributeTop
//                                                multiplier:1
//                                                  constant:verticalConstant];
//    }
//    
//    [self.contentView addConstraints:@[ layoutLeft, layoutRight, layoutTop ]];
//}
//
//#pragma mark - draw line
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
//    if (self.showSeperatorForSections) {
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context, 0.5);
//        CGContextSetStrokeColorWithColor(context, CY_ACTION_SHEET_SECTION_SEPARATOR_COLOR);
//        [self.sections enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            CGFloat lineY = CGRectGetMinY([self convertRect:obj.frame fromView:obj]) - 1;
//            CGContextMoveToPoint(context, self.separatorInsets.left, lineY);
//            CGContextAddLineToPoint(context, self.frame.size.width - self.separatorInsets.left + self.separatorInsets.right, lineY);
//            CGContextStrokePath(context);
//        }];
//        
//        if (self.cancelSection) {
//            
//            CGFloat lineY = CGRectGetMinY([self convertRect:self.cancelSection.frame fromView:self.cancelSection]) - 1;
//            CGContextMoveToPoint(context, self.separatorInsets.left, lineY);
//            CGContextAddLineToPoint(context, self.frame.size.width - self.separatorInsets.left + self.separatorInsets.right, lineY);
//            CGContextStrokePath(context);
//        }
//    }
//}

#pragma mark - event
- (void)actionSheetTapped:(UITapGestureRecognizer *)sender {
    
    CGPoint touchPoint = [sender locationInView:self];
    
//    __block BOOL touchInBlank = YES;
//    [self.internalSections enumerateObjectsUsingBlock:^(CYActionSheetSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        // 点击在section内时，不处理点击事件
//        if (CGRectContainsPoint(obj.frame, touchPoint)) {
//            
//            touchInBlank = NO;
//            *stop = YES;
//        }
//    }];
//    
//    if ()
    
    if (!CGRectContainsPoint(self.contentView.frame, touchPoint)
        && self.dimissOnBlankAreaTapped) {
        
        [self dismissAnimated:YES];
    }
}

#pragma mark - show
- (void)showAnimated:(BOOL)animated {
    
    [self.showWindow addSubview:self];
    [self refreshLayout];
    
    [self.showWindow makeKeyAndVisible];
    
    if (animated) {
        
        self.contentView.center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height + self.contentView.frame.size.height / 2.f);
        self.backgroundColor = [UIColor clearColor];
        
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
                             self.contentView.center = CGPointMake(self.frame.size.width / 2.f,
                                                                   self.frame.size.height - self.contentView.frame.size.height / 2.f);
                         }
                         completion:nil];
    }
}

- (void)dismissAnimated:(BOOL)animated {
    
    if (animated) {
        
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             self.backgroundColor = [UIColor clearColor];
                             self.contentView.center = CGPointMake(self.frame.size.width / 2.f,
                                                                   self.frame.size.height + self.contentView.frame.size.height / 2.f);
                         }
                         completion:^(BOOL finished) {
                             
                             [self.showWindow resignKeyWindow];
                             [self removeFromSuperview];
                         }];
    } else {
        
        [self.showWindow resignKeyWindow];
        [self removeFromSuperview];
    }
}

@end
