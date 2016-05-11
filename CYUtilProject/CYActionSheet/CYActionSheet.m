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

@property (nonatomic, strong, readwrite) CYActionSheetSection *cancelSection;
@property (nonatomic, strong, readwrite) NSMutableArray<CYActionSheetSection *> *internalSections;
@property (nonatomic, strong, readwrite) NSMutableArray<UIView *> *separatorViews;

@property (nonatomic, strong) UIWindow *showWindow;

// distance between section and screen border
@property (nonatomic, assign) CGFloat borderGap;
// distance between sections
@property (nonatomic, assign) CGFloat sectionGap;

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
        
        [self sectionLayout:_cancelSection withPreviousSection:nil];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.frame = self.superview.bounds;
}

#pragma mark - getter and setter
- (CGFloat)borderGap {
    
    if (self.style == CYActionSheetStylePlain) {
        
        return 0;
    } else {
        
        return CY_ACTION_SHEET_SECTION_BORDER_GAP;
    }
}

- (CGFloat)sectionGap {
    
    if (self.style == CYActionSheetStylePlain) {
        
        return 0;
    } else {
        
        return CY_ACTION_SHEET_GAP_BETWEEN_SECTIONS;
    }
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
        
        // get previous section
        CYActionSheetSection *previousSection = self.internalSections.lastObject;
        if (!previousSection) {
            
            previousSection = _cancelSection;
        }
        
        // add section
        section.actionSheet = self;
        [self.internalSections addObject:section];
        [self.contentView addSubview:section];
        
        // add constraints for section
        [self sectionLayout:section withPreviousSection:previousSection];
        
        // add corner radius for section in grouped style action sheet
        if (self.style == CYActionSheetStyleGrouped) {
            
            section.layer.cornerRadius = 10.f;
            section.clipsToBounds = YES;
        }
        
        // add section separator line if needed
        if (self.showSeperatorForSections) {
            
            if (!self.separatorViews) {
                
                self.separatorViews = [NSMutableArray array];
            }
            
            UIView *separator = [[UIView alloc] init];
            separator.backgroundColor = CY_ACTION_SHEET_SECTION_SEPARATOR_COLOR;
            [self.contentView addSubview:separator];
            [self.separatorViews addObject:separator];
            [self separatorLayout:separator inSection:section];
        }
    }
}

- (void)sectionLayout:(CYActionSheetSection *)section
  withPreviousSection:(CYActionSheetSection *)previousSection {
    
    section.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:section
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_contentView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:self.borderGap];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:section
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-self.borderGap];
    
    NSLayoutConstraint *bottom = nil;
    if (previousSection) {
        
        bottom = [NSLayoutConstraint constraintWithItem:section
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:previousSection
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1
                                               constant:-self.sectionGap];
    } else {
        
        bottom = [NSLayoutConstraint constraintWithItem:section
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_contentView
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1
                                               constant:-self.sectionGap];
    }
    [self.contentView addConstraints:@[ left, right, bottom ]];
}

- (void)separatorLayout:(UIView *)separatorView
              inSection:(CYActionSheetSection *)section {
    
    
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:separatorView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:section
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:self.borderGap];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:separatorView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:section
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-self.borderGap];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:separatorView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:0.5];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:separatorView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:section
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0];
    [self.contentView addConstraints:@[ left, right, bottom, height ]];
}

#pragma mark - layout
- (void)refreshLayout {
    
    if (self.internalSections.count > 0) {
        
        CYActionSheetSection *lastSection = self.internalSections.lastObject;
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:0];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.contentView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:lastSection
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:self.sectionGap];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1
                                                                   constant:0];
        [self addConstraints:@[ left, right, bottom, top ]];
    }
}

#pragma mark - event
- (void)actionSheetTapped:(UITapGestureRecognizer *)sender {
    
    CGPoint touchPoint = [sender locationInView:self];
    
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
        
        [self layoutIfNeeded];
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
                             self.showWindow = nil;
                             [self removeFromSuperview];
                         }];
    } else {
        
        [self.showWindow resignKeyWindow];
        self.showWindow = nil;
        [self removeFromSuperview];
    }
}

@end
