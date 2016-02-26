//
//  CYChatTextCell.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/6/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatBaseCell.h"

#define CY_CHAT_TEXT_MESSAGE_SHOW_FONT      [UIFont systemFontOfSize:15]
#define CY_CHAT_TEXT_MESSAGE_ARROW_GAP      20
#define CY_CHAT_TEXT_MESSAGE_NORMAL_GAP     10

@interface CYChatTextCell : CYChatBaseCell

- (CGSize)contentSize;

// cell height
+ (CGFloat)heightOfCellWithText:(NSString *)text
                  hideHeadImage:(BOOL)hideHeadImage
                       hideName:(BOOL)hideName;

@end
