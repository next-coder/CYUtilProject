//
//  CYChatImageLeftArrowCell.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/19/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatImageLeftArrowCell.h"

@implementation CYChatImageLeftArrowCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.headImageButton.hidden = self.isHideHeadImage;
    self.nameLabel.hidden = self.isHideName;

    CGFloat nextX = CY_CHAT_CELL_LEFT_MARGIN;
    CGFloat nextY = CY_CHAT_CELL_TOP_MARGIN;
    if (!self.isHideHeadImage) {
        
        self.headImageButton.frame = CGRectMake(nextX, nextY, CY_CHAT_CELL_HEAD_WIDTH, CY_CHAT_CELL_HEAD_WIDTH);
        nextX += (CY_CHAT_CELL_HEAD_WIDTH + 10);
    }
    if (!self.isHideName) {
        
        self.nameLabel.frame = CGRectMake(nextX, nextY, [CYChatImageLeftArrowCell maxContentSize].width, CY_CHAT_CELL_NAME_HEIGHT);
        nextY += (CY_CHAT_CELL_NAME_VERTICAL_GAP + CY_CHAT_CELL_NAME_HEIGHT);
    }
    nextX -= 5;
    
    CGSize contentSize = [self contentImageViewSize];
    self.contentBackgroundImageView.frame = CGRectMake(nextX,
                                                       nextY,
                                                       contentSize.width + self.contentInsets.left + self.contentInsets.right,
                                                       contentSize.height + self.contentInsets.top + self.contentInsets.bottom);
    self.contentImageView.frame = CGRectMake(self.contentInsets.left,
                                             self.contentInsets.top,
                                             contentSize.width,
                                             contentSize.height);
//    if (self.drawContentBackground) {
    
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)([self scaledMaskImage].CGImage);
        maskLayer.frame = self.contentBackgroundImageView.bounds;
        maskLayer.contentsScale = [UIScreen mainScreen].scale;
        maskLayer.opacity = 1;
        self.contentBackgroundImageView.layer.mask = maskLayer;
//    }
}

- (UIImage *)scaledMaskImage {
    
    UIImage *resizableImage = [[UIImage imageNamed:@"CYChat.bundle/chat_message_image_left_arrow_mask.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 30, 19, 25)];
    UIGraphicsBeginImageContext(self.contentBackgroundImageView.bounds.size);
    [resizableImage drawInRect:CGRectMake(0,
                                          0,
                                          self.contentBackgroundImageView.bounds.size.width,
                                          self.contentBackgroundImageView.bounds.size.height)
                     blendMode:kCGBlendModeNormal
                         alpha:1.f];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//- (CGPathRef)contentBackgroundPath {
//    
//    CGRect contentBackgroundBounds = self.contentBackgroundImageView.bounds;
//    CGFloat cornerRadius = self.contentBackgroundCornerRadius;
//    CGFloat contentArrowWidth = self.contentBackgroundArrowWidth;
//    CGFloat contentArrowHeight = self.contentBackgroundArrowHeight;
//    CGFloat minContentHeight = [CYChatImageLeftArrowCell minContentSize].height;
//    
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path,
//                      nil,
//                      contentArrowWidth,
//                      (minContentHeight - contentArrowHeight) / 2.f);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        contentArrowWidth,
//                        0,
//                        contentArrowWidth + cornerRadius,
//                        0,
//                        cornerRadius);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        contentBackgroundBounds.size.width,
//                        0,
//                        contentBackgroundBounds.size.width,
//                        cornerRadius,
//                        cornerRadius);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        contentBackgroundBounds.size.width,
//                        contentBackgroundBounds.size.height,
//                        contentBackgroundBounds.size.width - cornerRadius,
//                        contentBackgroundBounds.size.height,
//                        cornerRadius);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        contentArrowWidth,
//                        contentBackgroundBounds.size.height,
//                        contentArrowWidth,
//                        contentBackgroundBounds.size.height - cornerRadius,
//                        cornerRadius);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        contentArrowWidth,
//                        (minContentHeight + contentArrowWidth) / 2.f + 2,
//                        contentArrowWidth - 3,
//                        (minContentHeight + contentArrowHeight) / 2.f - 4,
//                        4);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        0,
//                        minContentHeight / 2.f,
//                        contentArrowWidth - 2,
//                        (minContentHeight - contentArrowHeight) / 2.f + 2,
//                        0.5);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        contentArrowWidth,
//                        (minContentHeight - contentArrowHeight) / 2.f,
//                        contentArrowWidth,
//                        (minContentHeight - contentArrowHeight) / 2.f - 2,
//                        4);
//    CGPathCloseSubpath(path);
//    return path;
//}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
//    if (self.drawContentBackground) {
//        
//        
//    }
//}

@end
