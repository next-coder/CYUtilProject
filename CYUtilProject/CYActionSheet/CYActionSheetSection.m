//
//  CYActionSheetSection.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/18/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYActionSheetSection.h"
#import "CYActionSheetAction.h"

#define CY_ACTION_SHEET_SECTION_CONTENT_BODER_GAP    15
#define CY_ACTION_SHEET_SECTION_ACTION_SEPARATOR_COLOR ([UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.f].CGColor)

@implementation CYActionSheetSection

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 contentViews:(NSArray<UIView *> *)contentViews {
    
    if (self = [super initWithFrame:CGRectZero]) {
        
        _title = title;
        _message = message;
        _contentViews = contentViews;
        
        [self createSectionSubviews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createSectionSubviews {
    
    __block UIView *previousView = nil;
    if (_title
        && ![_title isEqualToString:@""]) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = _title;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        [_titleLabel sizeToFit];
        
        // add common layouts
        [self contentLayout:_titleLabel
           withPreviousView:nil
                     topGap:CY_ACTION_SHEET_SECTION_CONTENT_BODER_GAP];
        // add left and right layout
        [self titleOrMessageHerizontalLayout:_titleLabel];
        previousView = _titleLabel;
    }
    
    if (_message
        && ![_message isEqualToString:@""]) {
        
        UILabel *message = [[UILabel alloc] init];
        message.font = [UIFont systemFontOfSize:14.f];
        message.textColor = [UIColor grayColor];
        message.backgroundColor = [UIColor clearColor];
        message.text = _message;
        message.textAlignment = NSTextAlignmentCenter;
        message.numberOfLines = 0;
        [self addSubview:message];
        _messageLabel = message;
        
        // add common layouts
        [self contentLayout:_messageLabel
           withPreviousView:_titleLabel
                     topGap:10];
        // add left and right layout
        [self titleOrMessageHerizontalLayout:_messageLabel];
        previousView = _messageLabel;
    }
    
    [_contentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self addSubview:obj];
        
        if (idx == 0
            && previousView) {
            
            [self contentLayout:obj
               withPreviousView:previousView
                         topGap:10];
        } else {
            
            [self contentLayout:obj
               withPreviousView:previousView
                         topGap:0];
        }
        
        previousView = obj;
    }];
    
    NSLayoutConstraint *lastBottom = [NSLayoutConstraint constraintWithItem:previousView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1
                                                                   constant:0];
    [self addConstraint:lastBottom];
}

- (void)titleOrMessageHerizontalLayout:(UILabel *)titleOrMessage {
    
    // since title and message are labels, to fit the content size, we must set the left and right constraints of them
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:titleOrMessage
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:CY_ACTION_SHEET_SECTION_CONTENT_BODER_GAP];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:titleOrMessage
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-CY_ACTION_SHEET_SECTION_CONTENT_BODER_GAP];
    [self addConstraints:@[ left, right ]];
}

- (void)contentLayout:(UIView *)contentView
     withPreviousView:(UIView *)previousView
               topGap:(CGFloat)topGap {
    
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    // all the following constraints priority are all low, user can add their own constraints to replace the default behavior
    // content x in the center of section
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:contentView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0];
    centerX.priority = UILayoutPriorityDefaultLow;
    // content height equal to the default frame.size.height
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:contentView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:contentView.frame.size.height];
    height.priority = UILayoutPriorityDefaultLow;
    
    // content width equal to the default frame.size.width
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:contentView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:contentView.frame.size.width];
    width.priority = UILayoutPriorityDefaultLow;
    
    // top is the bottom of the previous view
    NSLayoutConstraint *top = nil;
    if (previousView) {
        
        top = [NSLayoutConstraint constraintWithItem:contentView
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:previousView
                                           attribute:NSLayoutAttributeBottom
                                          multiplier:1
                                            constant:topGap];
    } else {
        
        top = [NSLayoutConstraint constraintWithItem:contentView
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                           attribute:NSLayoutAttributeTop
                                          multiplier:1
                                            constant:topGap];
    }
    
    [self addConstraints:@[ centerX, width, height, top ]];
}

#pragma mark - draw separator
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.showSeperatorForContents) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.5);
        CGContextSetStrokeColorWithColor(context, CY_ACTION_SHEET_SECTION_ACTION_SEPARATOR_COLOR);
        [self.contentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat lineY = CGRectGetMinY(obj.frame) - 1;
            CGContextMoveToPoint(context, self.separatorInsets.left, lineY);
            CGContextAddLineToPoint(context, self.frame.size.width - self.separatorInsets.left + self.separatorInsets.right, lineY);
            CGContextStrokePath(context);
        }];
    }
}

#pragma mark - setter
- (void)setShowSeperatorForContents:(BOOL)showSeperatorForContents {
    
    if (_showSeperatorForContents != showSeperatorForContents) {
        
        _showSeperatorForContents = showSeperatorForContents;
        [self setNeedsDisplay];
    }
}

- (void)setActionSheet:(CYActionSheet *)actionSheet {
    
    _actionSheet = actionSheet;
    
    [self.contentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[CYActionSheetAction class]]) {
            
            ((CYActionSheetAction *)obj).actionSheet = actionSheet;
        }
    }];
}

@end
