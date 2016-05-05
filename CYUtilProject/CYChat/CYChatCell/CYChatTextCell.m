//
//  CYChatTextCell.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/6/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatTextCell.h"

@implementation CYChatTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //        _drawContentBackground = YES;
        [self createContentLabel];
    }
    return self;
}

- (void)createContentLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = CY_CHAT_TEXT_MESSAGE_SHOW_FONT;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    [self.contentBackgroundImageView addSubview:label];
    self.contentLabel = label;
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
    
    NSString *text = message.messageContent;
    if (!text || [text isEqualToString:@""]) {
        
        // text is empty, return min size
        return [self minContentSize];
    } else {
        
        // calculate pure text size
        CGRect bounding = [text boundingRectWithSize:[self maxContentSize]
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{ NSFontAttributeName: CY_CHAT_TEXT_MESSAGE_SHOW_FONT }
                                             context:nil];
        CGSize size = CGSizeMake(ceil(bounding.size.width), ceil(bounding.size.height));
        
        // calculate whole content size from text size
        CGSize contentSize = CGSizeMake(size.width + CY_CHAT_TEXT_MESSAGE_ARROW_GAP * 2, size.height + CY_CHAT_TEXT_MESSAGE_NORMAL_GAP * 3);
        if (contentSize.height < [self minContentSize].height) {
            
            // set to min height if calculated content height is too short
            contentSize.height = [self minContentSize].height;
        }
        
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
