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

#import "UIScrollView+CYUtils.h"
#import "CYCache.h"

@interface CYChatViewController () <CYChatInputContentViewDelegate>

@property (nonatomic, weak) CYChatView *chatView;
@property (nonatomic, strong) NSMutableArray *messages;

@end

@implementation CYChatViewController

static NSString *imageLeftArrowCellIdentifier = @"CYChatImageLeftArrowCell";
static NSString *imageRightArrowCellIdentifier = @"CYChatImageRightArrowCell";

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
    if (message.type == CYChatMessageTypeImage) {
        
        CYChatImageRightArrowCell *cell = nil;
        if ([message.from isEqualToString:_chatDataSource.currentLoginUser.userId]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:imageRightArrowCellIdentifier];
            [cell.headImageButton cy_setImageWithURLString:[_chatDataSource headImageUrlWithUserId:_chatDataSource.currentLoginUser.headImageUrl]
                                               placeholder:[UIImage imageNamed:@"CYChat.bundle/chat_default_head.png"]];
            cell.nameLabel.text = _chatDataSource.currentLoginUser.nickname;
        } else {
            
            
            cell = [tableView dequeueReusableCellWithIdentifier:imageLeftArrowCellIdentifier];
            [cell.headImageButton cy_setImageWithURLString:[_chatDataSource headImageUrlWithUserId:message.from]
                                               placeholder:[UIImage imageNamed:@"CYChat.bundle/chat_default_head.png"]];
            cell.nameLabel.text = [_chatDataSource nicknameWithUserId:message.from];
        }
        
        UIImage *image = [[CYWebImageCache defaultCache] imageCacheWithUrlString:message.imageIconUrl];
        cell.contentImageView.image = image;
        if (!image) {
            
            NSInteger section = indexPath.section;
            NSInteger row = indexPath.row;
            [[CYWebImageCache defaultCache] imageWithURLString:message.imageIconUrl
                                                    completion:^(UIImage *image, NSError *error) {
                                                        
                                                        [_chatView.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:section inSection:row] ]
                                                                                   withRowAnimation:UITableViewRowAnimationAutomatic];
                                                    }];
        }
        
        cell.hideHeadImage = !(_chatDataSource.showUserHeadImage);
        cell.hideName = !(_chatDataSource.showUserNickname);
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CYChatMessageViewModel *message = [_messages objectAtIndex:indexPath.row];
    return [CYChatImageCell heightOfCellWithImage:[[CYWebImageCache defaultCache] imageCacheWithUrlString:message.imageIconUrl]
                                    hideHeadImage:!(_chatDataSource.showUserHeadImage)
                                         hideName:!(_chatDataSource.showUserNickname)];
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
    
    _messages = [[_chatDataSource messages] mutableCopy];
    [_chatView.tableView reloadData];
}

@end
