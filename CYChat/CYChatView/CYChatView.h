//
//  CYChatView.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/20/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CYChatInputContentView.h"
#import "CYChatInputMorePadView.h"
#import "CYChatInputEmotionPadView.h"

@class CYChatView;

@protocol CYChatViewDelegate <NSObject>

// send message
- (BOOL)chatViewShouldSendTextMessage:(NSString *)textMessage;

// 更多选项回调
- (void)chatViewShouldSendImageFromAlbum:(CYChatView *)chatView;
- (void)chatViewShouldSendVideoFromCamera:(CYChatView *)chatView;

@end

@interface CYChatView : UIView

@property (nonatomic, weak) id<CYChatViewDelegate> delegate;

@property (nonatomic, weak, readonly) UITableView *tableView;
@property (nonatomic, weak, readonly) CYChatInputContentView *chatInputContentView;
@property (nonatomic, weak, readonly) CYChatInputMorePadView *chatInputMorePadView;
@property (nonatomic, weak, readonly) CYChatInputEmotionPadView *chatInputEmotionPadView;

//- (void)replaceChatInputContentViewBottomConstraint:(NSLayoutConstraint *)constraint
//                                           animated:(BOOL)animated;

- (void)endInput;

@end
