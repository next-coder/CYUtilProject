//
//  CYChatViewModel.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "CYChatMessage.h"

@interface CYChatMessageViewModel : NSObject

- (instancetype)initWithMessage:(CYChatMessage *)messsage;

@property (nonatomic, strong, readonly) CYChatMessage *message;

@property (nonatomic, assign, readonly) CYChatMessageType type;

// common
@property (nonatomic, strong, readonly) NSString *from;
@property (nonatomic, strong, readonly) NSString *to;

// text message
@property (nonatomic, strong, readonly) NSString *messageContent;

// image message
@property (nonatomic, strong, readonly) NSString *imageIconUrl;
//@property (nonatomic, strong) NSString *imageIconFileUrl;
@property (nonatomic, strong, readonly) NSString *imageUrl;
//@property (nonatomic, strong) NSString *imageFileUrl;

// voice message
@property (nonatomic, strong, readonly) NSString *voiceUrl;
//@property (nonatomic, strong) NSString *voiceFileUrl;
@property (nonatomic, assign, readonly) NSUInteger voiceLength;
@property (nonatomic, assign, readonly) BOOL unread;

// cached message content size
@property (nonatomic, assign) CGSize messageContentSize;

// array translate from CYChatMessage to CYChatMessageViewModel
+ (NSArray *)viewModelArrayFromMessageArray:(NSArray *)messageArray;

@end
