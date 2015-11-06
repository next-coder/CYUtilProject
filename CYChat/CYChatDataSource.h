//
//  CYChatDataSource.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CYChatUserViewModel.h"
#import "CYChatMessageViewModel.h"

@protocol CYChatDataSourceDelegate <NSObject>

@optional
- (void)didReceiveMessage:(CYChatMessageViewModel *)message;
- (void)didReceiveMessages:(NSArray *)messages;

// 消息历史加载完成通知，在主线程回调，
// historyMessages：新加载出的历史消息
// pageIndex：加载的第几页
// allHistoryLoaded 所有历史消息是否加载完成
- (void)messageHistoryDidEndLoading:(NSArray *)historyMessages
                      withPageIndex:(NSUInteger)pageIndex
                   allHistoryLoaded:(BOOL)allHistoryLoaded;

@end

@interface CYChatDataSource : NSObject

@property (nonatomic, weak) id<CYChatDataSourceDelegate> delegate;

// CYChatMessageViewModel对象数组
@property (nonatomic, strong, readonly) NSArray *messages;

// 正在聊天对象。群聊时，为群信息；单聊时，为聊天信息的接受者
@property (nonatomic, strong, readonly) CYChatUserViewModel *chattingUser;
// 当前登录用户(自己)
@property (nonatomic, strong, readonly) CYChatUserViewModel *currentLoginUser;

// 是否显示头像，默认YES
@property (nonatomic, assign) BOOL showUserHeadImage;
// 是否显示昵称，默认YES
@property (nonatomic, assign) BOOL showUserNickname;

// 初始化方法
- (instancetype)initWithChattingUser:(CYChatUserViewModel *)user
                    currentLoginUser:(CYChatUserViewModel *)currentUser;

// 聊天用户信息，不包含当前主用户，当前主用户请使用属性currentLoginUser获取用户信息
- (NSString *)nicknameWithUserId:(NSString *)userId;
- (NSString *)headImageUrlWithUserId:(NSString *)userId;

// 发送消息
- (CYChatMessageViewModel *)sendTextMessage:(NSString *)messageText;
- (CYChatMessageViewModel *)sendVoiceMessage:(NSString *)voiceFileUrl;
- (CYChatMessageViewModel *)sendImageMessage:(NSString *)imageFileUrl;


#pragma mark - 消息历史
- (void)loadHistoryMessagesAsynWithPageIndex:(NSUInteger)pageIndex;

@end
