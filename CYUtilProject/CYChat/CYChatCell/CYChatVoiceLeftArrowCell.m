//
//  CYChatVoiceLeftArrowCell.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 2/29/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYChatVoiceLeftArrowCell.h"

@implementation CYChatVoiceLeftArrowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentBackgroundImageView.image = [[UIImage imageNamed:@"CYChat.bundle/chat_message_receiver_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 20, 20)];
        self.contentImageView.image = [UIImage imageNamed:@"CYChat.bundle/chat_message_voice_left_arrow_icon.png"];
        [self.contentImageView sizeToFit];
        
        self.contentImageView.animationImages = @[ [UIImage imageNamed:@"CYChat.bundle/chat_message_voice_left_arrow_playing_001.png"],
                                                   [UIImage imageNamed:@"CYChat.bundle/chat_message_voice_left_arrow_playing_002.png"],
                                                   [UIImage imageNamed:@"CYChat.bundle/chat_message_voice_left_arrow_playing_003.png"]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat nextX = CY_CHAT_CELL_LEFT_MARGIN;
    CGFloat nextY = CY_CHAT_CELL_TOP_MARGIN;
    if (!self.isHideHeadImage) {
        
        self.headImageButton.frame = CGRectMake(nextX, nextY, CY_CHAT_CELL_HEAD_WIDTH, CY_CHAT_CELL_HEAD_WIDTH);
        nextX += (CY_CHAT_CELL_HEAD_WIDTH + 10);
    }
    if (!self.isHideName) {
        
        self.nameLabel.frame = CGRectMake(nextX, nextY, [[self class] maxContentSize].width, CY_CHAT_CELL_NAME_HEIGHT);
        nextY += (CY_CHAT_CELL_NAME_VERTICAL_GAP + CY_CHAT_CELL_NAME_HEIGHT);
    }
    nextX -= 5;
    
    CGSize contentSize = [self contentSize];
    self.contentBackgroundImageView.frame = CGRectMake(nextX,
                                                       nextY,
                                                       contentSize.width,
                                                       contentSize.height);
    
    CGRect frame = self.contentImageView.frame;
    frame.origin.x = CY_CHAT_VOICE_MESSAGE_ARROW_GAP;
    frame.origin.y = CY_CHAT_VOICE_MESSAGE_NORMAL_GAP;
    self.contentImageView.frame = frame;
    
    frame = self.unreadImageView.frame;
    frame.origin.x = CGRectGetMaxX(self.contentBackgroundImageView.frame);
    frame.origin.y = CGRectGetMinY(self.contentBackgroundImageView.frame);
    self.unreadImageView.frame = frame;
    
    [self.voiceLengthLabel sizeToFit];
    frame = self.voiceLengthLabel.frame;
    frame.origin.x = self.unreadImageView.frame.origin.x;
    frame.origin.y = CGRectGetMaxY(self.contentBackgroundImageView.frame) - CY_CHAT_VOICE_MESSAGE_NORMAL_GAP - frame.size.height;
    self.voiceLengthLabel.frame = frame;
}


@end
