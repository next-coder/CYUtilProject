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
    
    return [[self class] contentSizeWithText:self.contentLabel.text];
}

// static calculate content size, include content background size
+ (CGSize)contentSizeWithText:(NSString *)text {
    
    if (!text || [text isEqualToString:@""]) {
        
        // text is empty, return min size
        return [self minContentSize];
    } else {
        
        // calculate pure text size
        CGRect bounding = [text boundingRectWithSize:[self maxContentSize]
                                             options:0
                                          attributes:@{ NSFontAttributeName: CY_CHAT_TEXT_MESSAGE_SHOW_FONT }
                                             context:nil];
        CGSize size = bounding.size;
        
        // calculate whole content size from text size
        CGSize contentSize = CGSizeMake(size.width + CY_CHAT_TEXT_MESSAGE_ARROW_GAP + CY_CHAT_TEXT_MESSAGE_NORMAL_GAP, size.height + CY_CHAT_TEXT_MESSAGE_NORMAL_GAP * 2);
        if (contentSize.height < [self minContentSize].height) {
            
            // set to min height if calculated content height is too short
            contentSize.height = [self minContentSize].height;
        }
        return contentSize;
    }
}

#pragma mark - cell height
+ (CGFloat)heightOfCellWithText:(NSString *)text
                  hideHeadImage:(BOOL)hideHeadImage
                       hideName:(BOOL)hideName {
    
    CGFloat height = 0.f;
    
    // add content size to cell height
    CGSize contentSize = [self contentSizeWithText:text];
    height += contentSize.height;
    
    if (!hideName) {
        
        // if not hide nickname, add it's size and margin with other contents
        height += (CY_CHAT_CELL_NAME_VERTICAL_GAP + CY_CHAT_CELL_NAME_HEIGHT);
    }
    
    // add top add bottom margin
    height += (CY_CHAT_CELL_TOP_MARGIN + CY_CHAT_CELL_BOTTOM_MARGIN);
    return height;
}

@end
