//
//  CYChatDataSource.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatDataSource.h"

#define CY_CHAT_DATA_SOURCE_HISTORY_MESSAGE_COUNT_PER_PAGE   20

@interface CYChatDataSource ()

@property (nonatomic, strong) NSMutableArray *internalMessages;

@property (nonatomic, strong) dispatch_queue_t defaultQueue;

@end

@implementation CYChatDataSource

- (instancetype)initWithChattingUser:(CYChatUserViewModel *)user
                    currentLoginUser:(CYChatUserViewModel *)currentUser {
    
    if (self = [super init]) {
        
        _chattingUser = user;
        _currentLoginUser = currentUser;
        
        _defaultQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
        _showUserHeadImage = YES;
        _showUserNickname = YES;
    }
    return self;
}

- (void)loadHistoryMessagesAsynWithPageIndex:(NSUInteger)pageIndex {
    
    dispatch_async(_defaultQueue, ^{
        
#warning test
        NSArray *historyMessages = [self testHistories];
        
        if (!_internalMessages) {
            
            _internalMessages = [NSMutableArray array];
            [_internalMessages addObjectsFromArray:historyMessages];
        } else {
            
            [_internalMessages insertObjects:historyMessages
                                   atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 15)]];
        }
        
        BOOL allHistoryLoaded = ([historyMessages count] < CY_CHAT_DATA_SOURCE_HISTORY_MESSAGE_COUNT_PER_PAGE);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_delegate
                && [_delegate respondsToSelector:@selector(messageHistoryDidEndLoading:withPageIndex:allHistoryLoaded:)]) {
                [_delegate messageHistoryDidEndLoading:historyMessages
                                         withPageIndex:pageIndex
                                      allHistoryLoaded:allHistoryLoaded];
            }
        });
    });
}

- (NSArray *)messages {
    
    if (!_internalMessages) {
        
        [self loadHistoryMessagesAsynWithPageIndex:0];
        return nil;
    }
    return [_internalMessages copy];
}

#pragma mark - 用户信息
- (NSString *)nicknameWithUserId:(NSString *)userId {
    
    return _chattingUser.nickname;
}

- (NSString *)headImageUrlWithUserId:(NSString *)userId {
    
    return _chattingUser.headImageUrl;
}

#pragma mark - send message
- (CYChatMessageViewModel *)sendTextMessage:(NSString *)messageText {
    
    CYChatMessageViewModel *message = [CYChatMessageViewModel instance];
    message.messageContent = messageText;
    message.type = CYChatMessageTypeText;
    message.from = _currentLoginUser.userId;
    message.to = _chattingUser.userId;
    dispatch_async(_defaultQueue, ^{
        
#warning send message
    });
    return message;
}

- (CYChatMessageViewModel *)sendVoiceMessage:(NSString *)voiceFileUrl {
    
    CYChatMessageViewModel *message = [CYChatMessageViewModel instance];
    message.voiceUrl = voiceFileUrl;
    message.type = CYChatMessageTypeVoice;
    message.from = _currentLoginUser.userId;
    message.to = _chattingUser.userId;
    dispatch_async(_defaultQueue, ^{
        
#warning send message
    });
    return message;
}

- (CYChatMessageViewModel *)sendImageMessage:(NSString *)imageFileUrl {
    
    CYChatMessageViewModel *message = [CYChatMessageViewModel instance];
    message.imageUrl = imageFileUrl;
#warning 缩放
    message.imageIconUrl = imageFileUrl;
    message.type = CYChatMessageTypeImage;
    message.from = _currentLoginUser.userId;
    message.to = _chattingUser.userId;
    dispatch_async(_defaultQueue, ^{
        
#warning send message
    });
    return message;
}

#warning test message
- (NSArray *)testHistories {
    
    NSString *fileUrl = @"https://m.xiaoniuapp.com/AD/banner/picc/picc.png";
    
    CYChatMessageViewModel *message1 = [CYChatMessageViewModel instance];
    message1.from = @"11";
    message1.to = @"22";
    message1.type = CYChatMessageTypeText;
    message1.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message1.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message2 = [CYChatMessageViewModel instance];
    message2.from = @"11";
    message2.to = @"22";
    message2.type = CYChatMessageTypeImage;
    message2.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message2.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message3 = [CYChatMessageViewModel instance];
    message3.from = @"11";
    message3.to = @"22";
    message3.type = CYChatMessageTypeImage;
    message3.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message3.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message4 = [CYChatMessageViewModel instance];
    message4.from = @"11";
    message4.to = @"22";
    message4.type = CYChatMessageTypeImage;
    message4.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message4.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message5 = [CYChatMessageViewModel instance];
    message5.from = @"22";
    message5.to = @"11";
    message5.type = CYChatMessageTypeImage;
    message5.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message5.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message6 = [CYChatMessageViewModel instance];
    message6.from = @"11";
    message6.to = @"22";
    message6.type = CYChatMessageTypeImage;
    message6.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message6.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message7 = [CYChatMessageViewModel instance];
    message7.from = @"11";
    message7.to = @"22";
    message7.type = CYChatMessageTypeImage;
    message7.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message7.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message8 = [CYChatMessageViewModel instance];
    message8.from = @"11";
    message8.to = @"22";
    message8.type = CYChatMessageTypeImage;
    message8.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message8.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message9 = [CYChatMessageViewModel instance];
    message9.from = @"22";
    message9.to = @"11";
    message9.type = CYChatMessageTypeImage;
    message9.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message9.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message10 = [CYChatMessageViewModel instance];
    message10.from = @"22";
    message10.to = @"11";
    message10.type = CYChatMessageTypeImage;
    message10.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message10.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message11 = [CYChatMessageViewModel instance];
    message11.from = @"11";
    message11.to = @"22";
    message11.type = CYChatMessageTypeImage;
    message11.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message11.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message12 = [CYChatMessageViewModel instance];
    message12.from = @"11";
    message12.to = @"22";
    message12.type = CYChatMessageTypeImage;
    message12.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message12.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message13 = [CYChatMessageViewModel instance];
    message13.from = @"22";
    message13.to = @"11";
    message13.type = CYChatMessageTypeImage;
    message13.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message13.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message14 = [CYChatMessageViewModel instance];
    message14.from = @"11";
    message14.to = @"22";
    message14.type = CYChatMessageTypeImage;
    message14.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message14.imageIconUrl = fileUrl;
    
    CYChatMessageViewModel *message15 = [CYChatMessageViewModel instance];
    message15.from = @"22";
    message15.to = @"11";
    message15.type = CYChatMessageTypeImage;
    message15.messageContent = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message15.imageIconUrl = fileUrl;
    
    NSArray *historyMessages = @[ message1, message2, message3, message4, message5, message6, message7, message8, message9, message10, message11, message12, message13, message14, message15 ];
    return historyMessages;
}

@end
