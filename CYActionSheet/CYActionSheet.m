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

#define CY_ACTION_SHEET_GAP_BETWEEN_SECTIONS    20

@interface CYActionSheet ()

@property (nonatomic, strong, readwrite) NSMutableArray<CYActionSheetSection *> *internalSections;
@property (nonatomic, strong, readwrite) CYActionSheetSection *cancelSection;

@property (nonatomic, strong) UIWindow *showWindow;
@property (nonatomic, strong) UIWindow *originWindow;

@end

@implementation CYActionSheet

- (instancetype)initWithCancelTitle:(NSString *)cancelTitle {
    
    if (self = [super init]) {
        
        _cancelTitle = cancelTitle;
//        _dimissOnBlankAreaTapped = YES;
        
        [self addActionSheetSubviews];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(actionSheetTapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)addActionSheetSubviews {
    
    if (_cancelTitle
        && ![_cancelTitle isEqualToString:@""]) {
        
        CYActionSheetAction *action = [[CYActionSheetAction alloc] initWithTitle:_cancelTitle
                                                                         handler:nil];
        CYActionSheetSection *section = [[CYActionSheetSection alloc] initWithTitle:nil
                                                                            message:nil
                                                                       contentViews:@[ action ]];
        section.actionSheet = self;
        [self addSubview:section];
        _cancelSection = section;
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.frame = self.superview.bounds;
}

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

#pragma mark - add section
- (void)addActionSheetSection:(CYActionSheetSection *)section {
    
    if (section) {
        
        section.actionSheet = self;
        [self.internalSections addObject:section];
        [self addSubview:section];
    }
}

#pragma mark - layout subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    __block CGFloat nextY = self.frame.size.height - CY_ACTION_SHEET_GAP_BETWEEN_SECTIONS;
    
    if (self.cancelSection) {
        
        [self.cancelSection layoutIfNeeded];
        self.cancelSection.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.f, nextY - self.cancelSection.frame.size.height / 2.f);
        nextY -= self.cancelSection.frame.size.height;
        nextY -= CY_ACTION_SHEET_GAP_BETWEEN_SECTIONS;
    }
    
    [self.internalSections enumerateObjectsWithOptions:NSEnumerationReverse
                                            usingBlock:^(CYActionSheetSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                
                                                obj.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.f, nextY - obj.frame.size.height / 2.f);
                                                nextY -= obj.frame.size.height;
                                                nextY -= CY_ACTION_SHEET_GAP_BETWEEN_SECTIONS;
                                            }];
}

#pragma mark - event
- (void)actionSheetTapped:(id)sender {
    
    if (self.dimissOnBlankAreaTapped) {
        
        [self dismissAnimated:YES];
    }
}

#pragma mark - show
- (void)showAnimated:(BOOL)animated {
    
    [self.showWindow addSubview:self];
    [self.showWindow makeKeyAndVisible];
}

- (void)dismissAnimated:(BOOL)animated {
    
    [self.showWindow resignKeyWindow];
    [self removeFromSuperview];
}

@end
