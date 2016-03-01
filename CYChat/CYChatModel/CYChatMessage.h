//
//  CYChatMessage.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 2/29/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYChatBaseModel.h"
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, CYChatMessageType) {
    
    CYChatMessageTypeText,
    CYChatMessageTypeVoice,
    CYChatMessageTypeImage
};

@interface CYChatMessage : CYChatBaseModel

@property (nonatomic, assign) CYChatMessageType type;

// common
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;

// text message
@property (nonatomic, strong) NSString *content;

// image message
@property (nonatomic, strong) NSString *imageIconUrl;
//@property (nonatomic, strong) NSString *imageIconFileUrl;
@property (nonatomic, strong) NSString *imageUrl;
//@property (nonatomic, strong) NSString *imageFileUrl;

// voice message
@property (nonatomic, strong) NSString *voiceUrl;
@property (nonatomic, assign) NSUInteger voiceLength;
@property (nonatomic, assign) BOOL unread;

@end
