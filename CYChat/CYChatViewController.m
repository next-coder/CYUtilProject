//
//  CYChatViewController.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/19/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatViewController.h"

#import "CYChatView.h"
#import "CYChatImageLeftArrowCell.h"
#import "CYChatImageRightArrowCell.h"
#import "CYChatTextLeftArrowCell.h"
#import "CYChatTextRightArrowCell.h"
#import "CYChatVoiceLeftArrowCell.h"
#import "CYChatVoiceRightArrowCell.h"

#import "UIScrollView+CYUtils.h"
#import "CYCache.h"

@interface CYChatViewController () <CYChatViewDelegate>

@property (nonatomic, weak) CYChatView *chatView;
@property (nonatomic, strong) NSMutableArray *messages;

@end

@implementation CYChatViewController

static NSString *imageLeftArrowCellIdentifier = @"CYChatImageLeftArrowCell";
static NSString *imageRightArrowCellIdentifier = @"CYChatImageRightArrowCell";
static NSString *textLeftArrowCellIdentifier = @"CYChatTextLeftArrowCell";
static NSString *textRightArrowCellIdentifier = @"CYChatTextRightArrowCell";
static NSString *voiceLeftArrowCellIdentifier = @"CYChatVoiceLeftArrowCell";
static NSString *voiceRightArrowCellIdentifier = @"CYChatVoiceRightArrowCell";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        _messages = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithDataSource:(CYChatDataSource *)dataSource {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        _messages = [NSMutableArray array];
        _chatDataSource = dataSource;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    CYChatView *chatView = [[CYChatView alloc] initWithFrame:self.view.frame];
    chatView.tableView.dataSource = self;
    chatView.tableView.delegate = self;
    self.view = chatView;
    _chatView = chatView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_chatView.tableView registerClass:[CYChatImageLeftArrowCell class]
                forCellReuseIdentifier:imageLeftArrowCellIdentifier];
    [_chatView.tableView registerClass:[CYChatImageRightArrowCell class]
                forCellReuseIdentifier:imageRightArrowCellIdentifier];
    [_chatView.tableView registerClass:[CYChatTextLeftArrowCell class]
                forCellReuseIdentifier:textLeftArrowCellIdentifier];
    [_chatView.tableView registerClass:[CYChatTextRightArrowCell class]
                forCellReuseIdentifier:textRightArrowCellIdentifier];
    [_chatView.tableView registerClass:[CYChatVoiceLeftArrowCell class]
                forCellReuseIdentifier:voiceLeftArrowCellIdentifier];
    [_chatView.tableView registerClass:[CYChatVoiceRightArrowCell class]
                forCellReuseIdentifier:voiceRightArrowCellIdentifier];
    
    _chatDataSource.delegate = self;
    [_chatDataSource loadHistoryMessagesAsynWithPageIndex:0];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CYChatMessageViewModel *message = [_messages objectAtIndex:indexPath.row];
    
    // 根据消息创建cell
    CYChatBaseCell *cell = [self chatMessageCellWithMessage:message tableView:tableView];
    
    // 设置头像
    cell.hideHeadImage = !(_chatDataSource.showUserHeadImage);
    if (_chatDataSource.showUserHeadImage) {
        
        [cell.headImageButton cy_setImageWithURLString:[_chatDataSource headImageUrlWithUserId:message.from]
                                           placeholder:[UIImage imageNamed:@"CYChat.bundle/chat_default_head.png"]];
    }
    
    // 设置昵称
    cell.hideName = !(_chatDataSource.showUserNickname);
    if (_chatDataSource.showUserNickname) {
        
        cell.nameLabel.text = [_chatDataSource nicknameWithUserId:message.from];
    }
    
    cell.message = message;
    // 设置内容
    switch (message.type) {
        case CYChatMessageTypeText: {
            
            cell.contentLabel.text = message.messageContent;
            break;
        }
            
        case CYChatMessageTypeImage: {
            
            [self setImage:message.imageIconUrl
                   forCell:cell
               atIndexPath:indexPath];
            break;
        }
            
        case CYChatMessageTypeVoice: {
            
            cell.voiceLengthLabel.text = [NSString stringWithFormat:@"%ld\"", message.voiceLength];
            cell.unreadImageView.hidden = !(message.unread);
            break;
        }
            
        default:
            break;
    }
    return cell;
}

- (CYChatBaseCell *)chatMessageCellWithMessage:(CYChatMessageViewModel *)message
                                     tableView:(UITableView *)tableView {
    
    // 创建cell
    CYChatBaseCell *cell = nil;
    switch (message.type) {
        case CYChatMessageTypeText: {
            
            if ([self isMySendMessage:message]) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:textRightArrowCellIdentifier];
            } else {
                
                cell = [tableView dequeueReusableCellWithIdentifier:textLeftArrowCellIdentifier];
            }
            break;
        }
            
        case CYChatMessageTypeImage: {
            
            if ([self isMySendMessage:message]) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:imageRightArrowCellIdentifier];
            } else {
                
                cell = [tableView dequeueReusableCellWithIdentifier:imageLeftArrowCellIdentifier];
            }
            break;
        }
            
        case CYChatMessageTypeVoice: {
            
            if ([self isMySendMessage:message]) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:voiceRightArrowCellIdentifier];
            } else {
                
                cell = [tableView dequeueReusableCellWithIdentifier:voiceLeftArrowCellIdentifier];
            }
            break;
        }
            
        default:
            break;
    }
    return cell;
}

// 图片消息，设置图片显示。缓存图片
- (void)setImage:(NSString *)imageUrl
         forCell:(CYChatBaseCell *)cell
     atIndexPath:(NSIndexPath *)indexPath {
    
    if (!imageUrl
        || [imageUrl isEqualToString:@""]) {
        
        return;
    }
    UIImage *image = [[CYWebImageCache defaultCache] imageCacheWithUrlString:imageUrl];
    cell.contentImageView.image = image;
    if (!image) {
        
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        
        [[CYWebImageCache defaultCache] imageWithURLString:imageUrl
                                                completion:^(UIImage *image, NSError *error) {
                                                    if (image) {
                                                        
                                                        [_chatView.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:row    inSection:section] ]
                                                                                   withRowAnimation:UITableViewRowAnimationAutomatic];
                                                    }
                                                }];
    }
}

- (BOOL)isMySendMessage:(CYChatMessageViewModel *)message {
    
    return [message.from isEqualToString:_chatDataSource.currentLoginUser.userId];
}

#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    // default size
//    return 210;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CYChatMessageViewModel *message = [_messages objectAtIndex:indexPath.row];
    
    switch (message.type) {
        case CYChatMessageTypeText:
            return [CYChatTextCell heightOfCellWithMessage:message
                                             hideHeadImage:!(_chatDataSource.showUserHeadImage)
                                                  hideName:!(_chatDataSource.showUserNickname)];
            break;
            
            
        case CYChatMessageTypeImage:
            return [CYChatImageCell heightOfCellWithMessage:message
                                              hideHeadImage:!(_chatDataSource.showUserHeadImage)
                                                   hideName:!(_chatDataSource.showUserNickname)];
            break;
            
            
        case CYChatMessageTypeVoice:
            return 100;
            break;
            
        default:
            return 200;
            break;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [_chatView endInput];
}

#pragma mark - CYChatDataSourceDelegate

- (void)didReceiveMessage:(CYChatMessageViewModel *)message {
    
    [_messages addObject:message];
    [_chatView.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:(_messages.count - 1) inSection:0] ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMessages:(NSArray *)messages {
    
    [_messages addObjectsFromArray:messages];
    [_chatView.tableView reloadData];
}

// 消息历史加载完成通知，在主线程回调，
// historyMessages：新加载出的历史消息
// pageIndex：加载的第几页
// allHistoryLoaded 所有历史消息是否加载完成
- (void)messageHistoryDidEndLoading:(NSArray *)historyMessages
                      withPageIndex:(NSUInteger)pageIndex
                   allHistoryLoaded:(BOOL)allHistoryLoaded {
    
    CGFloat contentOffsetY = _chatView.tableView.contentOffset.y;
    if (contentOffsetY < 0) {
        
        contentOffsetY = 0;
    }
    
    _messages = [[_chatDataSource messages] mutableCopy];
    [_chatView.tableView reloadData];
    
    // reset contentoffset to show messages which show in the front before loading
    _chatView.tableView.contentOffset = CGPointMake(0, _chatView.tableView.contentSize.height - contentOffsetY - _chatView.tableView.frame.size.height);
}

#pragma mark - CYChatViewDelegate
- (BOOL)chatViewShouldSendTextMessage:(NSString *)textMessage {
    
    CYChatMessageViewModel *message = [self.chatDataSource sendTextMessage:textMessage];
    
    [_messages addObject:message];
    [_chatView.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:(_messages.count - 1) inSection:0] ] withRowAnimation:UITableViewRowAnimationAutomatic];
    return YES;
}

- (void)chatViewShouldSendImageFromAlbum:(CYChatView *)chatView {
    
#warning here select image
}

- (void)chatViewShouldSendVideoFromCamera:(CYChatView *)chatView {
    
#warning take photo or video
}

@end
