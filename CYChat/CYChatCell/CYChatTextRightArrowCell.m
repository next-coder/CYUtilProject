//
//  CYChatTextRightArrowCell.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 2/26/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYChatTextRightArrowCell.h"

@implementation CYChatTextRightArrowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentBackgroundImageView.image = [[UIImage imageNamed:@"CYChat.bundle/chat_message_sender_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 20, 20)];
        self.nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat nextX = self.frame.size.width - CY_CHAT_CELL_RIGHT_MARGIN;
    CGFloat nextY = CY_CHAT_CELL_TOP_MARGIN;
    if (!self.isHideHeadImage) {
        
        self.headImageButton.frame = CGRectMake(nextX - CY_CHAT_CELL_HEAD_WIDTH,
                                                nextY,
                                                CY_CHAT_CELL_HEAD_WIDTH,
                                                CY_CHAT_CELL_HEAD_WIDTH);
        nextX -= (CY_CHAT_CELL_HEAD_WIDTH + 10);
    }
    if (!self.isHideName) {
        
        CGFloat nameLabelWidth = [[self class] maxContentSize].width;
        self.nameLabel.frame = CGRectMake(nextX - nameLabelWidth, nextY, nameLabelWidth, CY_CHAT_CELL_NAME_HEIGHT);
        nextY += (CY_CHAT_CELL_NAME_HEIGHT + CY_CHAT_CELL_NAME_VERTICAL_GAP);
    }
    nextX += 5;
    
    CGSize contentSize = [self contentSize];
    self.contentBackgroundImageView.frame = CGRectMake(nextX - contentSize.width,
                                                       nextY,
                                                       contentSize.width,
                                                       contentSize.height);
    self.contentLabel.frame = CGRectMake(CY_CHAT_TEXT_MESSAGE_ARROW_GAP,
                                         CY_CHAT_TEXT_MESSAGE_NORMAL_GAP,
                                         contentSize.width - CY_CHAT_TEXT_MESSAGE_ARROW_GAP * 2,
                                         contentSize.height - 3 * CY_CHAT_TEXT_MESSAGE_NORMAL_GAP);
}

@end
