//
//  CYChatVoiceCell.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 2/29/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYChatVoiceCell.h"

@implementation CYChatVoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
    
    UIImageView *content = [[UIImageView alloc] init];
    content.userInteractionEnabled = YES;
    content.backgroundColor = [UIColor clearColor];
    content.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentBackgroundImageView addSubview:content];
    self.contentImageView = content;
    
    UIImageView *unread = [[UIImageView alloc] init];
    unread.backgroundColor = [UIColor clearColor];
    [self addSubview:unread];
    self.unreadImageView = unread;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:10.f];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    self.voiceLengthLabel = label;
}

#pragma mark - content size
- (CGSize)contentSize {
    
    return [[self class] contentSizeWithMessage:self.message];
}

// static calculate content size, include content background size
+ (CGSize)contentSizeWithMessage:(CYChatMessageViewModel *)message {
    
    if (!CGSizeEqualToSize(message.messageContentSize, CGSizeZero)) {
        
        return message.messageContentSize;
    }
    
    if (message.voiceLength == 0) {
        
        // text is empty, return min size
        return [self minContentSize];
    } else {
        
        CGSize minContentSize = [self minContentSize];
        CGSize maxContentSize = [self maxContentSize];
        
        // calculate size
        CGFloat leftWidth = maxContentSize.width - minContentSize.width;
        CGFloat width = minContentSize.width + (1 - pow(0.95, (message.voiceLength - 1))) * leftWidth;
        
        CGSize contentSize = CGSizeMake(width, minContentSize.height);
        message.messageContentSize = contentSize;
        return contentSize;
    }
}

#pragma mark - cell height
+ (CGFloat)heightOfCellWithMessage:(CYChatMessageViewModel *)message
                     hideHeadImage:(BOOL)hideHeadImage
                          hideName:(BOOL)hideName {
    
    CGFloat height = 0.f;
    
    // add content size to cell height
    CGSize contentSize = [self contentSizeWithMessage:message];
    height += contentSize.height;
    
    if (!hideName) {
        
        // if not hide nickname, add it's size and margin with other contents
        height += (CY_CHAT_CELL_NAME_VERTICAL_GAP + CY_CHAT_CELL_NAME_HEIGHT);
    }
    height += CY_CHAT_CELL_BOTTOM_MARGIN;
    return height;
}

@end
