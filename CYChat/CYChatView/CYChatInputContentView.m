//
//  CYChatInputView.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/20/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatInputContentView.h"

@interface CYChatInputContentView () <UITextViewDelegate>

@property (nonatomic, assign) CGFloat originTextHeight;

@property (nonatomic, assign) NSLayoutConstraint *constraintHeight;

@end

@implementation CYChatInputContentView

static const CGFloat maxInputContentHeight = 110;
static const CGFloat minInputContentHeight = 45;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createInputContentSubviews];
        
        
        NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:self
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1
                                                                             constant:minInputContentHeight];
        [self addConstraint:constraintHeight];
        _constraintHeight = constraintHeight;
    }
    return self;
}

- (void)setInputType:(CYChatInputContentInputType)inputType {
    
    _inputType = inputType;
    [self refreshInputContentViewEditing:YES];
}

- (void)setHideEmotionInputButton:(BOOL)hideEmotionInputButton {
    
    _hideEmotionInputButton = hideEmotionInputButton;
    _emotionInputButton.hidden = _hideEmotionInputButton;
}

- (void)setHideMoreInputButton:(BOOL)hideMoreInputButton {
    
    _hideMoreInputButton = hideMoreInputButton;
    _moreInputButton.hidden = _hideMoreInputButton;
}

- (void)setHideVoiceInputButton:(BOOL)hideVoiceInputButton {
    
    _hideVoiceInputButton = hideVoiceInputButton;
    _voiceInputButton.hidden = _hideVoiceInputButton;
    _voiceContentButton.hidden = _hideVoiceInputButton;
}

- (void)createInputContentSubviews {
    
    UIImageView *background = [[UIImageView alloc] init];
    background.translatesAutoresizingMaskIntoConstraints = NO;
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"CYChat.bundle/chat_input_content_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 9, 4, 9)];
    [self addSubview:background];
    _backgroundImageView = background;
    
    UIImageView *textBackground = [[UIImageView alloc] init];
    textBackground.translatesAutoresizingMaskIntoConstraints = NO;
    textBackground.backgroundColor = [UIColor clearColor];
    textBackground.image = [[UIImage imageNamed:@"CYChat.bundle/chat_input_content_text_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 19, 19, 19)];
    [self addSubview:textBackground];
    _textBackgroundImageView = textBackground;
    
    UITextView *text = [[UITextView alloc] init];
    text.font = [UIFont systemFontOfSize:17.f];
    text.translatesAutoresizingMaskIntoConstraints = NO;
    text.textContainerInset = UIEdgeInsetsMake(5, 0, 5, 0);
    text.backgroundColor = [UIColor clearColor];
    text.returnKeyType = UIReturnKeySend;
    text.delegate = self;
    [self addSubview:text];
    _textView = text;
    
    UIButton *voiceContent = [[UIButton alloc] init];
    voiceContent.translatesAutoresizingMaskIntoConstraints = NO;
    voiceContent.backgroundColor = [UIColor clearColor];
    voiceContent.hidden = YES;
    UIImage *normalBG = [[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice_record_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 19, 19, 19)];
    UIImage *highlightedBG = [[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice_record_bg_hl.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 19, 19, 19)];
    [voiceContent setBackgroundImage:normalBG forState:UIControlStateNormal];
    [voiceContent setBackgroundImage:highlightedBG forState:UIControlStateHighlighted];
    [voiceContent setTitle:@"按下说话" forState:UIControlStateNormal];
    [voiceContent setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [voiceContent setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    voiceContent.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [voiceContent addTarget:self
                     action:@selector(voiceContentTouchDown:)
           forControlEvents:UIControlEventTouchDown];
    [voiceContent addTarget:self
                     action:@selector(voiceContentDragOutside:)
           forControlEvents:UIControlEventTouchDragOutside];
    [voiceContent addTarget:self
                     action:@selector(voiceContentDragInside:)
           forControlEvents:UIControlEventTouchDragInside];
    [voiceContent addTarget:self
                     action:@selector(voiceContentTouchUpInside:)
           forControlEvents:UIControlEventTouchUpInside];
    [voiceContent addTarget:self
                     action:@selector(voiceContentTouchUpOutside:)
           forControlEvents:UIControlEventTouchUpOutside];
    [voiceContent addTarget:self
                     action:@selector(voiceContentTouchCancel:)
           forControlEvents:UIControlEventTouchCancel];
    [self addSubview:voiceContent];
    _voiceContentButton = voiceContent;
    
    UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
    more.translatesAutoresizingMaskIntoConstraints = NO;
    more.backgroundColor = [UIColor clearColor];
    [more setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_more.png"]
                    forState:UIControlStateNormal];
    [more setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_more_hl.png"]
                    forState:UIControlStateHighlighted];
    [more addTarget:self
             action:@selector(showMoreInput:)
   forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:more];
    _moreInputButton = more;
    
    UIButton *voice = [UIButton buttonWithType:UIButtonTypeCustom];
    voice.translatesAutoresizingMaskIntoConstraints = NO;
    voice.backgroundColor = [UIColor clearColor];
    [voice setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice.png"]
                     forState:UIControlStateNormal];
    [voice setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice_hl.png"]
                     forState:UIControlStateHighlighted];
    [voice addTarget:self
              action:@selector(showVoiceInput:)
    forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:voice];
    _voiceInputButton = voice;
    
    UIButton *emotion = [UIButton buttonWithType:UIButtonTypeCustom];
    emotion.translatesAutoresizingMaskIntoConstraints = NO;
    emotion.backgroundColor = [UIColor clearColor];
    [emotion setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_emotion.png"]
                       forState:UIControlStateNormal];
    [emotion setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_emotion_hl.png"]
                       forState:UIControlStateHighlighted];
    [emotion addTarget:self
                action:@selector(showEmotionInput:)
      forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emotion];
    _emotionInputButton = emotion;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self createConstraintsForInputContentSubviews];
}

- (void)createConstraintsForInputContentSubviews {
    
    static CGFloat defaultHerizontalGap = 0;
    static CGFloat defaultVerticalGap = 2;
    static CGFloat defaultButtonWidth = 35;
    
    {
        NSLayoutConstraint *constraint0 = [NSLayoutConstraint constraintWithItem:_backgroundImageView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1
                                                                        constant:0];
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_backgroundImageView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1
                                                                        constant:0];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_backgroundImageView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1
                                                                        constant:0];
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_backgroundImageView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:0];
        [self addConstraints:@[ constraint0, constraint1, constraint2, constraint3 ]];
    }
    
    id textLeftLayoutItem = nil;
    NSLayoutAttribute textLeftLayoutItemAttribute;
    if (!_hideVoiceInputButton) {
        
        [_voiceInputButton sizeToFit];
        NSLayoutConstraint *constraint0 = [NSLayoutConstraint constraintWithItem:_voiceInputButton
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1
                                                                        constant:defaultHerizontalGap];
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_voiceInputButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:-5];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_voiceInputButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:defaultButtonWidth];
        [self addConstraints:@[ constraint0, constraint1, constraint2 ]];
        textLeftLayoutItem = _voiceInputButton;
        textLeftLayoutItemAttribute = NSLayoutAttributeRight;
    } else {
        
        textLeftLayoutItem = self;
        textLeftLayoutItemAttribute = NSLayoutAttributeLeft;
    }
    
    id emotionRightLayoutItem = nil;
    NSLayoutAttribute emotionRightLayoutItemAttribute;
    if (!_hideMoreInputButton) {
        
        [_moreInputButton sizeToFit];
        NSLayoutConstraint *constraint0 = [NSLayoutConstraint constraintWithItem:_moreInputButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1
                                                                        constant:-defaultHerizontalGap];
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_moreInputButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:-5];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_moreInputButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:defaultButtonWidth];
        [self addConstraints:@[ constraint0, constraint1, constraint2 ]];
        emotionRightLayoutItem = _moreInputButton;
        emotionRightLayoutItemAttribute = NSLayoutAttributeLeft;
    } else {
        
        emotionRightLayoutItem = self;
        emotionRightLayoutItemAttribute = NSLayoutAttributeRight;
    }
    
    id textRightLayoutItem = nil;
    NSLayoutAttribute textRightLayoutItemAttribute;
    if (!_hideEmotionInputButton) {
        
        [_emotionInputButton sizeToFit];
        NSLayoutConstraint *constraint0 = [NSLayoutConstraint constraintWithItem:_emotionInputButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:emotionRightLayoutItem
                                                                       attribute:emotionRightLayoutItemAttribute
                                                                      multiplier:1
                                                                        constant:-defaultHerizontalGap];
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_emotionInputButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:-5];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_emotionInputButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:defaultButtonWidth];
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_emotionInputButton
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:defaultButtonWidth];
        [self addConstraints:@[ constraint0, constraint1, constraint2, constraint3 ]];
        textRightLayoutItem = _emotionInputButton;
        textRightLayoutItemAttribute = NSLayoutAttributeLeft;
    } else {
        
        textRightLayoutItem = emotionRightLayoutItem;
        textRightLayoutItemAttribute = emotionRightLayoutItemAttribute;
    }
    
    if (!_hideVoiceInputButton) {
        
        NSLayoutConstraint *constraint0 = [NSLayoutConstraint constraintWithItem:_voiceContentButton
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:textLeftLayoutItem
                                                                       attribute:textLeftLayoutItemAttribute
                                                                      multiplier:1
                                                                        constant:defaultHerizontalGap];
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_voiceContentButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:textRightLayoutItem
                                                                       attribute:textRightLayoutItemAttribute
                                                                      multiplier:1
                                                                        constant:-defaultHerizontalGap];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_voiceContentButton
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1
                                                                        constant:defaultVerticalGap];
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_voiceContentButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:-defaultVerticalGap];
        [self addConstraints:@[ constraint0, constraint1, constraint2, constraint3 ]];
    }
    
    NSLayoutConstraint *constraint0 = [NSLayoutConstraint constraintWithItem:_textView
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:textLeftLayoutItem
                                                                   attribute:textLeftLayoutItemAttribute
                                                                  multiplier:1
                                                                    constant:defaultHerizontalGap + 5];
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_textView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:textRightLayoutItem
                                                                   attribute:textRightLayoutItemAttribute
                                                                  multiplier:1
                                                                    constant:-(defaultHerizontalGap + 5)];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_textView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1
                                                                    constant:7];
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_textView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1
                                                                    constant:-7];
    [self addConstraints:@[ constraint0, constraint1, constraint2, constraint3 ]];
    
    NSLayoutConstraint *textBGConstraint0 = [NSLayoutConstraint constraintWithItem:_textBackgroundImageView
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:textLeftLayoutItem
                                                                         attribute:textLeftLayoutItemAttribute
                                                                        multiplier:1
                                                                          constant:defaultHerizontalGap];
    NSLayoutConstraint *textBGConstraint1 = [NSLayoutConstraint constraintWithItem:_textBackgroundImageView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:textRightLayoutItem
                                                                         attribute:textRightLayoutItemAttribute
                                                                        multiplier:1
                                                                          constant:-defaultHerizontalGap];
    NSLayoutConstraint *textBGConstraint2 = [NSLayoutConstraint constraintWithItem:_textBackgroundImageView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1
                                                                          constant:defaultVerticalGap];
    NSLayoutConstraint *textBGConstraint3 = [NSLayoutConstraint constraintWithItem:_textBackgroundImageView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:-defaultVerticalGap];
    [self addConstraints:@[ textBGConstraint0, textBGConstraint1, textBGConstraint2, textBGConstraint3 ]];
}

- (void)showMoreInput:(id)sender {
    
    if (_inputType == CYChatInputContentInputTypeMore) {
        
        _inputType = CYChatInputContentInputTypeText;
    } else {
        
        _inputType = CYChatInputContentInputTypeMore;
    }
    [self refreshInputContentViewEditing:YES];
    if (_delegate
        && [_delegate respondsToSelector:@selector(chatInputContentDidChangeInputType:)]) {
        
        [_delegate chatInputContentDidChangeInputType:_inputType];
    }
}

- (void)showVoiceInput:(id)sender {
    
    if (_inputType == CYChatInputContentInputTypeVoice) {
        
        _inputType = CYChatInputContentInputTypeText;
    } else {
        
        _inputType = CYChatInputContentInputTypeVoice;
    }
    [self refreshInputContentViewEditing:YES];
    if (_delegate
        && [_delegate respondsToSelector:@selector(chatInputContentDidChangeInputType:)]) {
        
        [_delegate chatInputContentDidChangeInputType:_inputType];
    }
}

- (void)showEmotionInput:(id)sender {
    
    if (_inputType == CYChatInputContentInputTypeEmotion) {
        
        _inputType = CYChatInputContentInputTypeText;
    } else {
        
        _inputType = CYChatInputContentInputTypeEmotion;
    }
    [self refreshInputContentViewEditing:YES];
    if (_delegate
        && [_delegate respondsToSelector:@selector(chatInputContentDidChangeInputType:)]) {
        
        [_delegate chatInputContentDidChangeInputType:_inputType];
    }
}

- (void)voiceContentTouchDown:(id)sender {
    
    _recordState = CYChatInputContentVoiceRecordStateStart;
    if (_delegate
        && [_delegate respondsToSelector:@selector(chatInputContentDidChangeVoiceRecordState:)]) {
        
        [_delegate chatInputContentDidChangeVoiceRecordState:_recordState];
    }
    
    UIImage *highlightedBG = [[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice_record_bg_hl.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 19, 19, 19)];
    [_voiceContentButton setBackgroundImage:highlightedBG forState:UIControlStateNormal];
    [_voiceContentButton setTitle:@"松开 发送" forState:UIControlStateNormal];
}

- (void)voiceContentDragOutside:(id)sender {
    
    _recordState = CYChatInputContentVoiceRecordStatePause;
    if (_delegate
        && [_delegate respondsToSelector:@selector(chatInputContentDidChangeVoiceRecordState:)]) {
        
        [_delegate chatInputContentDidChangeVoiceRecordState:_recordState];
    }
    
    [_voiceContentButton setTitle:@"按下说话" forState:UIControlStateNormal];
}

- (void)voiceContentDragInside:(id)sender {
    
    _recordState = CYChatInputContentVoiceRecordStateResume;
    if (_delegate
        && [_delegate respondsToSelector:@selector(chatInputContentDidChangeVoiceRecordState:)]) {
        
        [_delegate chatInputContentDidChangeVoiceRecordState:_recordState];
    }
    [_voiceContentButton setTitle:@"松开 发送" forState:UIControlStateNormal];
}

- (void)voiceContentTouchUpInside:(id)sender {
    
    _recordState = CYChatInputContentVoiceRecordStateEnded;
    if (_delegate
        && [_delegate respondsToSelector:@selector(chatInputContentDidChangeVoiceRecordState:)]) {
        
        [_delegate chatInputContentDidChangeVoiceRecordState:_recordState];
    }
    
    UIImage *normalBG = [[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice_record_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 19, 19, 19)];
    [_voiceContentButton setBackgroundImage:normalBG forState:UIControlStateNormal];
    [_voiceContentButton setTitle:@"按下说话" forState:UIControlStateNormal];
}

- (void)voiceContentTouchUpOutside:(id)sender {
    
    _recordState = CYChatInputContentVoiceRecordStateCancel;
    if (_delegate
        && [_delegate respondsToSelector:@selector(chatInputContentDidChangeVoiceRecordState:)]) {
        
        [_delegate chatInputContentDidChangeVoiceRecordState:_recordState];
    }
    
    UIImage *normalBG = [[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice_record_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 19, 19, 19)];
    [_voiceContentButton setBackgroundImage:normalBG forState:UIControlStateNormal];
    [_voiceContentButton setTitle:@"按下说话" forState:UIControlStateNormal];
}

- (void)voiceContentTouchCancel:(id)sender {
    
    _recordState = CYChatInputContentVoiceRecordStateCancel;
    if (_delegate
        && [_delegate respondsToSelector:@selector(chatInputContentDidChangeVoiceRecordState:)]) {
        
        [_delegate chatInputContentDidChangeVoiceRecordState:_recordState];
    }
    
    UIImage *normalBG = [[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice_record_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 19, 19, 19)];
    [_voiceContentButton setBackgroundImage:normalBG forState:UIControlStateNormal];
    [_voiceContentButton setTitle:@"按下说话" forState:UIControlStateNormal];
}

- (void)refreshInputContentViewEditing:(BOOL)editing {
    
    switch (_inputType) {
        case CYChatInputContentInputTypeText: {
            
            [self textViewContentWillChangeText:_textView.text];
            
            [_voiceInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice.png"]
                                         forState:UIControlStateNormal];
            [_voiceInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice_hl.png"]
                                         forState:UIControlStateHighlighted];
            [_emotionInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_emotion.png"]
                                           forState:UIControlStateNormal];
            [_emotionInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_emotion_hl.png"]
                                           forState:UIControlStateHighlighted];
            if (editing) {
                
                [_textView becomeFirstResponder];
            } else {
                
                [_textView resignFirstResponder];
            }
            _textView.hidden = NO;
            _voiceContentButton.hidden = YES;
            break;
        }
            
        case CYChatInputContentInputTypeVoice: {
            
            CGRect frame = self.frame;
            frame.size.height = minInputContentHeight;
            self.frame = frame;
            _originTextHeight = 0;
            
            [_voiceInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_keyboard.png"]
                                         forState:UIControlStateNormal];
            [_voiceInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_keyboard_hl.png"]
                                         forState:UIControlStateHighlighted];
            [_emotionInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_emotion.png"]
                                           forState:UIControlStateNormal];
            [_emotionInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_emotion_hl.png"]
                                           forState:UIControlStateHighlighted];
            [_textView resignFirstResponder];
            _textView.hidden = YES;
            _voiceContentButton.hidden = NO;
            break;
        }
            
        case CYChatInputContentInputTypeEmotion: {
            
            [self textViewContentWillChangeText:_textView.text];
            
            [_voiceInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice.png"]
                                         forState:UIControlStateNormal];
            [_voiceInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice_hl.png"]
                                         forState:UIControlStateHighlighted];
            [_emotionInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_keyboard.png"]
                                           forState:UIControlStateNormal];
            [_emotionInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_keyboard_hl.png"]
                                           forState:UIControlStateHighlighted];
            [_textView resignFirstResponder];
            _textView.hidden = NO;
            _voiceContentButton.hidden = YES;
            break;
        }
            
        case CYChatInputContentInputTypeMore: {
            
            [self textViewContentWillChangeText:_textView.text];
            
            [_voiceInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice.png"]
                                         forState:UIControlStateNormal];
            [_voiceInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_voice_hl.png"]
                                         forState:UIControlStateHighlighted];
            [_emotionInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_emotion.png"]
                                           forState:UIControlStateNormal];
            [_emotionInputButton setBackgroundImage:[UIImage imageNamed:@"CYChat.bundle/chat_input_content_emotion_hl.png"]
                                           forState:UIControlStateHighlighted];
            [_textView resignFirstResponder];
            _textView.hidden = NO;
            _voiceContentButton.hidden = YES;
            break;
        }
        default:
            break;
    }
}

- (void)resetInputType:(CYChatInputContentInputType)type
               editing:(BOOL)editing {
    
    _inputType = type;
    [self refreshInputContentViewEditing:editing];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (_inputType != CYChatInputContentInputTypeText) {
        
        self.inputType = CYChatInputContentInputTypeText;
    }
    
    if (_delegate
        && [_delegate respondsToSelector:@selector(chatInputContentDidChangeInputType:)]) {
        
        [_delegate chatInputContentDidChangeInputType:_inputType];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if (_delegate
            && [_delegate respondsToSelector:@selector(chatInputContentShouldSendText:)]
            && [_delegate chatInputContentShouldSendText:_textView.text]) {
            
            _textView.text = nil;
            [self textViewContentWillChangeText:nil];
        }
        return NO;
    } else {
        
        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
        [self textViewContentWillChangeText:newText];
        return YES;
    }
}

- (void)textViewContentWillChangeText:(NSString *)text {
    
    if (_originTextHeight == 0) {
        
        CGRect singleLineBouning = [@"小牛" boundingRectWithSize:CGSizeMake(_textView.frame.size.width - 5, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{ NSFontAttributeName: _textView.font }
                                                       context:nil];
        _originTextHeight = singleLineBouning.size.height;
    }
    
    CGRect textBouning = [text boundingRectWithSize:CGSizeMake(_textView.frame.size.width - 10, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{ NSFontAttributeName: _textView.font }
                                            context:nil];
    
    CGFloat diffHeight = textBouning.size.height - _originTextHeight;
    if (diffHeight > 5) {
        
        CGFloat height = self.frame.size.height + diffHeight;
        
        if (height < maxInputContentHeight) {
            
            _constraintHeight.constant = height;
            _originTextHeight = textBouning.size.height;
            [UIView animateWithDuration:0.3 animations:^{
                
                [self layoutIfNeeded];
            }];
        }
    } else if (diffHeight < -5) {
        
        CGFloat height = self.frame.size.height + diffHeight;
        if (height < minInputContentHeight) {
            height = minInputContentHeight;
        }
        _constraintHeight.constant = height;
        _originTextHeight = textBouning.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            
            [self layoutIfNeeded];
        }];
    }
}

@end
