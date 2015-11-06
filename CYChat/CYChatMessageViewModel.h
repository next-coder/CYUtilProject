//
//  CYChatViewModel.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CYChatMessageType) {
    
    CYChatMessageTypeText,
    CYChatMessageTypeVoice,
    CYChatMessageTypeImage
};

@interface CYChatMessageViewModel : NSObject

@property (nonatomic, assign) CYChatMessageType type;

// common
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;

// text message
@property (nonatomic, strong) NSString *messageContent;

// image message
@property (nonatomic, strong) NSString *imageIconUrl;
//@property (nonatomic, strong) NSString *imageIconFileUrl;
@property (nonatomic, strong) NSString *imageUrl;
//@property (nonatomic, strong) NSString *imageFileUrl;

// voice message
@property (nonatomic, strong) NSString *voiceUrl;
//@property (nonatomic, strong) NSString *voiceFileUrl;

+ (instancetype)instance;

@end
