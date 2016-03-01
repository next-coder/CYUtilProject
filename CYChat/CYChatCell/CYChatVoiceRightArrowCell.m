//
//  CYChatVoiceRightArrowCell.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 2/29/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYChatVoiceRightArrowCell.h"

@implementation CYChatVoiceRightArrowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentBackgroundImageView.image = [[UIImage imageNamed:@"CYChat.bundle/chat_message_sender_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 20, 20)];
        self.contentImageView.image = [UIImage imageNamed:@"CYChat.bundle/chat_message_voice_right_arrow_icon.png"];
        [self.contentImageView sizeToFit];
        
        self.contentImageView.animationImages = @[ [UIImage imageNamed:@"CYChat.bundle/chat_message_voice_right_arrow_playing_001.png"],
                                                   [UIImage imageNamed:@"CYChat.bundle/chat_message_voice_right_arrow_playing_002.png"],
                                                   [UIImage imageNamed:@"CYChat.bundle/chat_message_voice_right_arrow_playing_003.png"]];
        
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
    
    CGRect frame = self.contentImageView.frame;
    frame.origin.x = CGRectGetWidth(self.contentBackgroundImageView.frame) - CY_CHAT_VOICE_MESSAGE_ARROW_GAP - frame.size.width;
    frame.origin.y = CY_CHAT_VOICE_MESSAGE_NORMAL_GAP;
    self.contentImageView.frame = frame;
    
    frame = self.unreadImageView.frame;
    frame.origin.x = CGRectGetMinX(self.contentBackgroundImageView.frame) - frame.size.width;
    frame.origin.y = CGRectGetMinY(self.contentBackgroundImageView.frame);
    self.unreadImageView.frame = frame;
    
    [self.voiceLengthLabel sizeToFit];
    frame = self.voiceLengthLabel.frame;
    frame.origin.x = CGRectGetMinX(self.contentBackgroundImageView.frame) - frame.size.width;
    frame.origin.y = CGRectGetMaxY(self.contentBackgroundImageView.frame) - CY_CHAT_VOICE_MESSAGE_NORMAL_GAP - frame.size.height;
    self.voiceLengthLabel.frame = frame;
}

@end
