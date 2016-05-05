//
//  CYChatVoiceCell.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 2/29/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYChatBaseCell.h"

#define CY_CHAT_VOICE_MESSAGE_ARROW_GAP      18
#define CY_CHAT_VOICE_MESSAGE_NORMAL_GAP     13

@interface CYChatVoiceCell : CYChatBaseCell

- (CGSize)contentSize;

+ (CGFloat)heightOfCellWithMessage:(CYChatMessageViewModel *)message
                     hideHeadImage:(BOOL)hideHeadImage
                          hideName:(BOOL)hideName;

@end
