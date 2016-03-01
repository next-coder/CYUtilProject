//
//  CYChatBaseCell.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/19/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CYChatMessageViewModel.h"

#define CY_CHAT_CELL_NAME_HEIGHT        15
#define CY_CHAT_CELL_NAME_VERTICAL_GAP  5

#define CY_CHAT_CELL_HEAD_WIDTH         54

#define CY_CHAT_CELL_DEFAULT_IMAGE_CONTENT_SIZE     CGSizeMake(100, 150)

#define CY_CHAT_CELL_TOP_MARGIN         10
#define CY_CHAT_CELL_BOTTOM_MARGIN      10
#define CY_CHAT_CELL_LEFT_MARGIN        10
#define CY_CHAT_CELL_RIGHT_MARGIN       10

@class CYChatBaseCell;

@protocol CYChatBaseCellDelegate <NSObject>

@optional
- (void)cellDidSelectHeadImage:(CYChatBaseCell *)cell;
- (void)cellDidSelectContent:(CYChatBaseCell *)cell;

@end

@interface CYChatBaseCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id<CYChatBaseCellDelegate> delegate;

//@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UIButton *headImageButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, weak) IBOutlet UIImageView *contentBackgroundImageView;
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;
@property (nonatomic, weak) IBOutlet UIImageView *unreadImageView;
@property (nonatomic, weak) IBOutlet UILabel *voiceLengthLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@property (nonatomic, assign, getter=isHideHeadImage) BOOL hideHeadImage;
@property (nonatomic, assign, getter=isHideName) BOOL hideName;

//@property (nonatomic, assign) UIEdgeInsets contentInsets;

@property (nonatomic, assign) CGFloat contentBackgroundCornerRadius;
@property (nonatomic, assign) CGFloat contentBackgroundArrowWidth;
@property (nonatomic, assign) CGFloat contentBackgroundArrowHeight;

@property (nonatomic, weak) CYChatMessageViewModel *message;

- (IBAction)headImageTapped:(id)sender;


// 内容背景框的大小限制
+ (CGSize)maxContentSize;
+ (CGSize)minContentSize;

@end
