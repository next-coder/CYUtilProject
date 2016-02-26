//
//  CYChatTextLeftArrayCell.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 2/26/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYChatTextLeftArrowCell.h"

@implementation CYChatTextLeftArrowCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.headImageButton.hidden = self.isHideHeadImage;
    self.nameLabel.hidden = self.isHideName;
    
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
    self.contentLabel.frame = CGRectMake(CY_CHAT_TEXT_MESSAGE_ARROW_GAP,
                                         CY_CHAT_TEXT_MESSAGE_NORMAL_GAP,
                                         contentSize.width - CY_CHAT_TEXT_MESSAGE_NORMAL_GAP - CY_CHAT_TEXT_MESSAGE_ARROW_GAP,
                                         contentSize.height - 2 * CY_CHAT_TEXT_MESSAGE_NORMAL_GAP);
}

@end
