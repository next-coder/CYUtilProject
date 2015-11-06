//
//  CYChatInputMorePadItem.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/30/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYChatInputMorePadItem : UIView

@property (nonatomic, weak, readonly) UIButton *itemButton;
@property (nonatomic, weak, readonly) UILabel *itemLabel;

- (void)addTarget:(nullable id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
