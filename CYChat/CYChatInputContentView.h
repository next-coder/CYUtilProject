//
//  CYChatInputView.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/20/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYChatInputContentView;

typedef NS_ENUM(NSInteger, CYChatInputContentInputType) {
    
    CYChatInputContentInputTypeText,
    CYChatInputContentInputTypeVoice,
    CYChatInputContentInputTypeEmotion,
    CYChatInputContentInputTypeMore
};

typedef NS_ENUM(NSInteger, CYChatInputContentVoiceRecordState) {
    
    CYChatInputContentVoiceRecordStateStart,
    CYChatInputContentVoiceRecordStatePause,
    CYChatInputContentVoiceRecordStateResume,
    CYChatInputContentVoiceRecordStateCancel,
    CYChatInputContentVoiceRecordStateEnded
};

@protocol CYChatInputContentViewDelegate <NSObject>

@optional
- (void)chatInputContentDidChangeInputType:(CYChatInputContentInputType)inputType;
- (void)chatInputContentDidChangeVoiceRecordState:(CYChatInputContentVoiceRecordState)status;
- (BOOL)chatInputContentShouldSendText:(NSString *)text;

@end

@interface CYChatInputContentView : UIView

@property (nonatomic, weak) id<CYChatInputContentViewDelegate> delegate;

@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIImageView *textBackgroundImageView;

@property (nonatomic, weak) UITextView *textView;               // 输入框，不要改变textView的delegate属性
@property (nonatomic, weak) UIButton *moreInputButton;          // 更多输入
@property (nonatomic, weak) UIButton *voiceInputButton;         // 语音输入
@property (nonatomic, weak) UIButton *emotionInputButton;       // 表情输入
@property (nonatomic, weak) UIButton *voiceContentButton;       // 按住说话按钮

// 一下三个必须在CYChatInputContentView被addSubview之前调用
@property (nonatomic, assign) BOOL hideMoreInputButton;
@property (nonatomic, assign) BOOL hideVoiceInputButton;
@property (nonatomic, assign) BOOL hideEmotionInputButton;

@property (nonatomic, assign) CYChatInputContentInputType inputType;
@property (nonatomic, assign, readonly) CYChatInputContentVoiceRecordState recordState;

- (void)resetInputType:(CYChatInputContentInputType)type
               editing:(BOOL)editing;

@end
