//
//  CYChatViewModel.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatMessageViewModel.h"

#import "CYChatDataSource.h"

@implementation CYChatMessageViewModel

- (instancetype)init {
    
    return [self initWithMessage:nil];
}

- (instancetype)initWithMessage:(CYChatMessage *)messsage {
    
    if (self = [super init]) {
        
        _messageContentSize = CGSizeZero;
        _message = messsage;
    }
    return self;
}

#pragma mark - getter
- (CYChatMessageType)type {
    
    return _message.type;
}

- (NSString *)from {
    
    return _message.from;
}

- (NSString *)to {
    
    return _message.to;
}

- (NSString *)messageContent {
    
    return _message.content;
}

- (NSString *)imageIconUrl {
    
    return _message.imageIconUrl;
}

- (NSString *)imageUrl {
    
    return _message.imageUrl;
}

- (NSString *)voiceUrl {
    
    return _message.voiceUrl;
}

- (NSUInteger)voiceLength {
    
    return _message.voiceLength;
}

- (BOOL)unread {
    
    return _message.unread;
}

#pragma mark - array translate
+ (NSArray *)viewModelArrayFromMessageArray:(NSArray *)messageArray {
    
    if (!messageArray
        || messageArray.count == 0) {
        
        return nil;
    }
    
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:messageArray.count];
    [messageArray enumerateObjectsUsingBlock:^(CYChatMessage *message, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CYChatMessageViewModel *model = [[CYChatMessageViewModel alloc] initWithMessage:message];
        [models addObject:model];
    }];
    
    return models;
}


@end
