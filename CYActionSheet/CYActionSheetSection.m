//
//  CYActionSheetSection.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/18/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#import "CYActionSheetSection.h"
#import "CYActionSheetAction.h"

#define CY_ACTION_SHEET_SECTION_MESSAGE_MAX_HEIGHT   200
#define CY_ACTION_SHEET_SECTION_CONTENT_BODER_GAP    15
#define CY_ACTION_SHEET_SECTION_ACTION_VIEW_HEIGHT    44
#define CY_ACTION_SHEET_SECTION_ACTION_SEPARATOR_COLOR ([UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.f].CGColor)

#define CY_ACTION_SHEET_SECTION_BORDER_GAP            20

@interface CYActionSheetSection ()

@property (nonatomic, assign, readonly) CGFloat sectionTotalHeight;
@property (nonatomic, assign, readonly) CGFloat sectionWidth;
@property (nonatomic, assign, readonly) CGFloat contentWidth;

@end

@implementation CYActionSheetSection

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 contentViews:(NSArray<UIView *> *)contentViews {
    
    if (self = [super initWithFrame:CGRectZero]) {
        
        _title = title;
        _message = message;
        _contentViews = contentViews;
        
        [self createSectionSubviews];
        
        self.frame = CGRectMake(0, 0, self.sectionWidth, self.sectionTotalHeight);
        self.layer.cornerRadius = 5.f;
        self.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createSectionSubviews {
    
    if (_title
        && ![_title isEqualToString:@""]) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = _title;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 0, self.contentWidth, 0);
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        [_titleLabel sizeToFit];
    }
    
    if (_message
        && ![_message isEqualToString:@""]) {
        
        UITextView *message = [[UITextView alloc] init];
        message.font = [UIFont systemFontOfSize:14.f];
        message.textColor = [UIColor grayColor];
        message.backgroundColor = [UIColor clearColor];
        message.text = _message;
        message.editable = NO;
        message.textAlignment = NSTextAlignmentCenter;
        message.frame = CGRectMake(0, 0, self.contentWidth, 0);
        [self addSubview:message];
        _messageTextView = message;
        [_messageTextView sizeToFit];
    }
    
    [_contentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self addSubview:obj];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat selfWidth = self.sectionWidth;
    CGFloat contentWidth = self.contentWidth;
    CGRect frame;
    __block CGFloat nextY = 0;
    if (_title
        && ![_title isEqualToString:@""]) {
        
        nextY = CY_ACTION_SHEET_SECTION_CONTENT_BODER_GAP;
        CGSize size = [_titleLabel sizeThatFits:CGSizeMake(contentWidth, 100)];
        frame.size = size;
        frame.origin.x = (selfWidth - size.width) / 2.f;
        frame.origin.y = nextY;
        _titleLabel.frame = frame;
        
        nextY = CGRectGetMaxY(_titleLabel.frame);
    }
    
    if (_message
        && ![_message isEqualToString:@""]) {
        
        CGSize size = [_messageTextView sizeThatFits:CGSizeMake(contentWidth, CY_ACTION_SHEET_SECTION_MESSAGE_MAX_HEIGHT)];
        frame.size = size;
        frame.origin.x = (selfWidth - size.width) / 2.f;
        frame.origin.y = nextY;
        _messageTextView.frame = frame;
        
        nextY = CGRectGetMaxY(_messageTextView.frame) + 5;
    } else if (_title
               && ![_title isEqualToString:@""]) {
        
        // 有title时，增加分割距离
        nextY += CY_ACTION_SHEET_SECTION_CONTENT_BODER_GAP;
    }
    
    [_contentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (self.showSeperatorForContents) {
            
            nextY += 1;
        }
        obj.center = CGPointMake(selfWidth / 2.f, nextY + obj.frame.size.height / 2.f);
        nextY += obj.frame.size.height;
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.showSeperatorForContents) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.5);
        CGContextSetStrokeColorWithColor(context, CY_ACTION_SHEET_SECTION_ACTION_SEPARATOR_COLOR);
        [_contentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat lineY = CGRectGetMinY(obj.frame) - 1;
            CGContextMoveToPoint(context, 0, lineY);
            CGContextAddLineToPoint(context, self.frame.size.width, lineY);
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

#pragma mark - getter
- (CGFloat)sectionWidth {
    
    return [UIScreen mainScreen].bounds.size.width - CY_ACTION_SHEET_SECTION_BORDER_GAP * 2;
}

- (CGFloat)contentWidth {
    
    return self.sectionWidth - 2 * CY_ACTION_SHEET_SECTION_CONTENT_BODER_GAP;
}

- (CGFloat)sectionTotalHeight {
    
    __block CGFloat totalHeight = 0;
    if (_titleLabel) {
        
        totalHeight += CY_ACTION_SHEET_SECTION_CONTENT_BODER_GAP;
        totalHeight += _titleLabel.frame.size.height;
    }
    if (_messageTextView) {
        
        totalHeight += _messageTextView.frame.size.height;
    } else if (_titleLabel) {
        
        totalHeight += CY_ACTION_SHEET_SECTION_CONTENT_BODER_GAP;
    }
    
    [_contentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        totalHeight += obj.frame.size.height;
        
        if (self.showSeperatorForContents) {
            
            totalHeight += 1;
        }
    }];
    
    return totalHeight;
}

@end
