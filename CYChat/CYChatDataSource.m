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
    
    CYChatMessage *message = [[CYChatMessage alloc] init];
    message.content = messageText;
    message.type = CYChatMessageTypeText;
    message.from = _currentLoginUser.userId;
    message.to = _chattingUser.userId;
    dispatch_async(_defaultQueue, ^{
        
#warning send message
    });
    return [[CYChatMessageViewModel alloc] initWithMessage:message];
}

- (CYChatMessageViewModel *)sendVoiceMessage:(NSString *)voiceFileUrl {
    
    CYChatMessage *message = [[CYChatMessage alloc] init];
    message.voiceUrl = voiceFileUrl;
    message.type = CYChatMessageTypeVoice;
    message.from = _currentLoginUser.userId;
    message.to = _chattingUser.userId;
    dispatch_async(_defaultQueue, ^{
        
#warning send message
    });
    return [[CYChatMessageViewModel alloc] initWithMessage:message];
}

- (CYChatMessageViewModel *)sendImageMessage:(NSString *)imageFileUrl {
    
    CYChatMessage *message = [[CYChatMessage alloc] init];
    message.imageUrl = imageFileUrl;
#warning 缩放
    message.imageIconUrl = imageFileUrl;
    message.type = CYChatMessageTypeImage;
    message.from = _currentLoginUser.userId;
    message.to = _chattingUser.userId;
    dispatch_async(_defaultQueue, ^{
        
#warning send message
    });
    return [[CYChatMessageViewModel alloc] initWithMessage:message];
}

#warning test message
- (NSArray *)testHistories {
    
    NSString *fileUrl = @"https://m.xiaoniuapp.com/AD/banner/picc/picc.png";
    
    CYChatMessage *message1 = [[CYChatMessage alloc] init];
    message1.from = @"11";
    message1.to = @"22";
    message1.type = CYChatMessageTypeText;
    message1.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message1.voiceLength = 60.f;
    message1.imageIconUrl = fileUrl;
    
    CYChatMessage *message2 = [[CYChatMessage alloc] init];
    message2.from = @"11";
    message2.to = @"22";
    message2.type = CYChatMessageTypeText;
    message2.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message2.voiceLength = 40.f;
    message2.imageIconUrl = fileUrl;
    
    CYChatMessage *message3 = [[CYChatMessage alloc] init];
    message3.from = @"11";
    message3.to = @"22";
    message3.type = CYChatMessageTypeImage;
    message3.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message3.voiceLength = 10.f;
    message3.imageIconUrl = fileUrl;
    
    CYChatMessage *message4 = [[CYChatMessage alloc] init];
    message4.from = @"11";
    message4.to = @"22";
    message4.type = CYChatMessageTypeImage;
    message4.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message4.voiceLength = 6.f;
    message4.imageIconUrl = fileUrl;
    
    CYChatMessage *message5 = [[CYChatMessage alloc] init];
    message5.from = @"22";
    message5.to = @"11";
    message5.type = CYChatMessageTypeImage;
    message5.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message5.voiceLength = 3.f;
    message5.imageIconUrl = fileUrl;
    
    CYChatMessage *message6 = [[CYChatMessage alloc] init];
    message6.from = @"11";
    message6.to = @"22";
    message6.type = CYChatMessageTypeImage;
    message6.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message6.voiceLength = 30.f;
    message6.imageIconUrl = fileUrl;
    
    CYChatMessage *message7 = [[CYChatMessage alloc] init];
    message7.from = @"11";
    message7.to = @"22";
    message7.type = CYChatMessageTypeText;
    message7.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message7.voiceLength = 40.f;
    message7.imageIconUrl = fileUrl;
    
    CYChatMessage *message8 = [[CYChatMessage alloc] init];
    message8.from = @"11";
    message8.to = @"22";
    message8.type = CYChatMessageTypeText;
    message8.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message8.voiceLength = 5.f;
    message8.imageIconUrl = fileUrl;
    
    CYChatMessage *message9 = [[CYChatMessage alloc] init];
    message9.from = @"22";
    message9.to = @"11";
    message9.type = CYChatMessageTypeText;
    message9.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣";
    message9.voiceLength = 6.f;
    message9.imageIconUrl = fileUrl;
    
    CYChatMessage *message10 = [[CYChatMessage alloc] init];
    message10.from = @"22";
    message10.to = @"11";
    message10.type = CYChatMessageTypeText;
    message10.content = @"就是一个\ue415消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；\ue415\ue415\ue415阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦\ue415\ue415撒旦就快疯了；啊圣诞节快乐飞；\ue415\ue415\ue415啊";
    message10.voiceLength = 8.f;
    message10.imageIconUrl = fileUrl;
    
    CYChatMessage *message11 = [[CYChatMessage alloc] init];
    message11.from = @"11";
    message11.to = @"22";
    message11.type = CYChatMessageTypeImage;
    message11.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message11.voiceLength = 9.f;
    message11.imageIconUrl = fileUrl;
    
    CYChatMessage *message12 = [[CYChatMessage alloc] init];
    message12.from = @"11";
    message12.to = @"22";
    message12.type = CYChatMessageTypeImage;
    message12.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message12.voiceLength = 1.f;
    message12.imageIconUrl = fileUrl;
    
    CYChatMessage *message13 = [[CYChatMessage alloc] init];
    message13.from = @"22";
    message13.to = @"11";
    message13.type = CYChatMessageTypeVoice;
    message13.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message13.voiceLength = 3.f;
    message13.imageIconUrl = fileUrl;
    
    CYChatMessage *message14 = [[CYChatMessage alloc] init];
    message14.from = @"11";
    message14.to = @"22";
    message14.type = CYChatMessageTypeVoice;
    message14.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message14.voiceLength = 3.f;
    message14.imageIconUrl = fileUrl;
    
    CYChatMessage *message15 = [[CYChatMessage alloc] init];
    message15.from = @"22";
    message15.to = @"11";
    message15.type = CYChatMessageTypeImage;
    message15.content = @"就是一个消息测试啦哈佛舒服撒发生的烦恼萨克拉飞机和撒地方就卡死了；反抗拉伸的；放假快乐；爱神的箭；阿萨德能否考虑；爱的世界；受打击罚款了；阿萨德积分卡那里；啊短时间内付款了；多撒谎交罚款了；撒旦就恢复快乐；爱上反抗拉伸的合法开讲啦撒旦就快疯了；啊圣诞节快乐飞；啊";
    message15.voiceLength = 7.f;
    message15.imageIconUrl = fileUrl;
    
    NSArray *historyMessages = @[ message1, message2, message3, message4, message5, message6, message7, message8, message9, message10, message11, message12, message13, message14, message15 ];
    return [CYChatMessageViewModel viewModelArrayFromMessageArray:historyMessages];
}

@end
