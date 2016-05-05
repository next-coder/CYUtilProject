//
//  CYChatInputEmotionPadView.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatInputEmotionPadView.h"

@interface CYChatInputEmotionPadView ()

@property (nonatomic, strong) NSMutableArray *emotionButtons;

@property (nonatomic, strong) NSArray *emotions;

@end

@implementation CYChatInputEmotionPadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _emotionButtons = [NSMutableArray array];
        _emotions = @[ @"\ue415", @"\ue056", @"\ue057", @"\ue414", @"\ue405", @"\ue106", @"\ue418", @"\ue417", @"\ue40d", @"\ue40a", @"\ue404", @"\ue105", @"\ue409", @"\ue40e", @"\ue402", @"\ue108", @"\ue403", @"\ue058", @"\ue407", @"\ue401", @"\ue40f", @"\ue40b", @"\ue406", @"\ue413", @"\ue411", @"\ue412", @"\ue410", @"\ue107", @"\ue059", @"\ue416", @"\ue408", @"\ue40c", @"\ue11a", @"\ue10c", @"\ue00e", @"\ue421", @"\ue420", @"\ue00d", @"\ue010", @"\ue011", @"\ue41e", @"\ue012", @"\ue422", @"\ue22e", @"\ue22f", @"\ue231", @"\ue230", @"\ue427", @"\ue41d", @"\ue00f", @"\ue41f", @"\ue14c", @"\ue32c", @"\ue328", @"\ue022", @"\ue023", @"\ue327", @"\ue329", @"\ue32e", @"\ue32f", @"\ue335", @"\ue334", @"\ue021", @"\ue020", @"\ue13c", @"\ue330", @"\ue331", @"\ue326", @"\ue03e", @"\ue11d", @"\ue05a", @"\ue201", @"\ue115", @"\ue428", @"\ue51f", @"\ue429", @"\ue424", @"\ue423", @"\ue253", @"\ue426", @"\ue111", @"\ue425", @"\ue31e", @"\ue31f", @"\ue31d", @"\ue001", @"\ue002", @"\ue005", @"\ue004", @"\ue51a", @"\ue519", @"\ue518", @"\ue515", @"\ue516", @"\ue51b", @"\ue517", @"\ue152", @"\ue04e", @"\ue51c", @"\ue51e", @"\ue11c", @"\ue536", @"\ue003", @"\ue41c", @"\ue419", @"\ue41b", @"\ue41a" ];
        [self createEmotionPad];
    }
    return self;
}

- (void)createEmotionPad {
    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
//    
//    UIButton *button1 = [self emotionButtonWithTitle:@"\ue415"];
//    [self addSubview:button1];
//    [_emotionButtons addObject:button1];
}

- (UIButton *)emotionButtonWithTitle:(NSString *)title {
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:title forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 30, 30);
    return button1;
}

@end
