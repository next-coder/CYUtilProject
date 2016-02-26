//
//  CYChatBaseCell.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/19/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatBaseCell.h"

@implementation CYChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _contentBackgroundCornerRadius = 5.f;
        _contentBackgroundArrowWidth = 6;
        _contentBackgroundArrowHeight = 10;
//        _contentInsets = UIEdgeInsetsZero;
        [self createHeadAndName];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)createHeadAndName {
    
//    UIImageView *head = [[UIImageView alloc] init];
//    head.userInteractionEnabled = YES;
//    head.backgroundColor = [UIColor clearColor];
//    [self addSubview:head];
//    _headImageView = head;
    UIButton *head = [UIButton buttonWithType:UIButtonTypeCustom];
    head.backgroundColor = [UIColor clearColor];
    [head addTarget:self
             action:@selector(headImageTapped:)
   forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:head];
    _headImageButton = head;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTapped:)];
//    [head addGestureRecognizer:tap];
    
    UILabel *name = [[UILabel alloc] init];
    name.backgroundColor = [UIColor clearColor];
    name.font = [UIFont systemFontOfSize:14.f];
    name.textColor = [UIColor darkGrayColor];
    [self addSubview:name];
    _nameLabel = name;
    
    UIImageView *contentBackground = [[UIImageView alloc] init];
    contentBackground.userInteractionEnabled = YES;
    contentBackground.backgroundColor = [UIColor clearColor];
    [self addSubview:contentBackground];
    _contentBackgroundImageView = contentBackground;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)];
    [contentBackground addGestureRecognizer:tap];
}

#pragma mark - event

- (IBAction)headImageTapped:(id)sender {
    
    if (_delegate
        && [_delegate respondsToSelector:@selector(cellDidSelectHeadImage:)]) {
        
        [_delegate cellDidSelectHeadImage:self];
    }
}

- (IBAction)contentTapped:(id)sender {
    
    if (_delegate
        && [_delegate respondsToSelector:@selector(cellDidSelectContent:)]) {
        
        [_delegate cellDidSelectContent:self];
    }
}

+ (CGSize)maxContentSize {
    
    CGSize maxContentSize = CGSizeMake(180, CGFLOAT_MAX);
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat defaultWidth = 320.f;
    
    maxContentSize.width = maxContentSize.width * screenWidth / defaultWidth;
    
    return maxContentSize;
}

+ (CGSize)minContentSize {
    
    return CGSizeMake(5, CY_CHAT_CELL_HEAD_WIDTH);
}

@end
