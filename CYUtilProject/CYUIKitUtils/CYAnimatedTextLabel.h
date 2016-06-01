//
//  CYAnimatedContentLabel.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/29/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CYAnimatedTextLabelDelegate <NSObject>

- (NSString *)textWithAnimationProgress:(CGFloat)progress;

@optional
- (void)textAniamtionDidEnd;

@end

@interface CYAnimatedTextLabel : UILabel

@property (nonatomic, weak) id<CYAnimatedTextLabelDelegate> delegate;

- (void)cy_startAnimatingTextWithDuration:(CGFloat)duration;

@end
