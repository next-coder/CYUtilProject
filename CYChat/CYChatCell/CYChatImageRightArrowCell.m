//
//  CYChatImageRightArrowCell.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/19/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatImageRightArrowCell.h"

@implementation CYChatImageRightArrowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat nextX = self.frame.size.width - CY_CHAT_CELL_RIGHT_MARGIN;
    CGFloat nextY = CY_CHAT_CELL_TOP_MARGIN;
    if (!self.isHideHeadImage) {
        
        self.headImageButton.frame = CGRectMake(nextX - CY_CHAT_CELL_HEAD_WIDTH,
                                                nextY,
                                                CY_CHAT_CELL_HEAD_WIDTH,
                                                CY_CHAT_CELL_HEAD_WIDTH);
        nextX -= (CY_CHAT_CELL_HEAD_WIDTH + 10);
    }
    if (!self.isHideName) {
        
        CGFloat nameLabelWidth = [CYChatImageRightArrowCell maxContentSize].width;
        self.nameLabel.frame = CGRectMake(nextX - nameLabelWidth, nextY, nameLabelWidth, CY_CHAT_CELL_NAME_HEIGHT);
        nextY += (CY_CHAT_CELL_NAME_HEIGHT + CY_CHAT_CELL_NAME_VERTICAL_GAP);
    }
    nextX += 5;
    
    CGSize contentSize = [self contentImageViewSize];
    self.contentBackgroundImageView.frame = CGRectMake(nextX - contentSize.width,
                                                       nextY,
                                                       contentSize.width,
                                                       contentSize.height);
    self.contentImageView.frame = CGRectMake(0,
                                             0,
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
    
    UIImage *resizableImage = [[UIImage imageNamed:@"CYChat.bundle/chat_message_image_right_arrow_mask.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 30, 19, 25)];
    UIGraphicsBeginImageContext(self.contentBackgroundImageView.bounds.size);
    [resizableImage drawInRect:CGRectMake(0,
                                          0,
                                          self.contentBackgroundImageView.bounds.size.width,
                                          self.contentBackgroundImageView.bounds.size.height)];
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
//    CGFloat minContentHeight = [CYChatImageRightArrowCell minContentSize].height;
//    
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path,
//                      nil,
//                      contentBackgroundBounds.size.width - contentArrowWidth,
//                      (minContentHeight + contentArrowHeight) / 2.f + 2);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        contentBackgroundBounds.size.width - contentArrowWidth,
//                        contentBackgroundBounds.size.height,
//                        contentBackgroundBounds.size.width - contentArrowWidth - cornerRadius,
//                        contentBackgroundBounds.size.height,
//                        cornerRadius);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        0,
//                        contentBackgroundBounds.size.height,
//                        0,
//                        contentBackgroundBounds.size.height - cornerRadius,
//                        cornerRadius);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        0,
//                        0,
//                        cornerRadius,
//                        0,
//                        cornerRadius);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        contentBackgroundBounds.size.width - contentArrowWidth,
//                        0,
//                        contentBackgroundBounds.size.width - contentArrowWidth,
//                        cornerRadius,
//                        cornerRadius);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        contentBackgroundBounds.size.width - contentArrowWidth,
//                        (minContentHeight - contentArrowHeight) / 2.f - 2,
//                        contentBackgroundBounds.size.width - contentArrowWidth + 3,
//                        (minContentHeight - contentArrowHeight) / 2.f + 4,
//                        4);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        contentBackgroundBounds.size.width,
//                        minContentHeight / 2.f,
//                        contentBackgroundBounds.size.width - contentArrowWidth + 2,
//                        (minContentHeight + contentArrowHeight) / 2.f - 2,
//                        0.5);
//    CGPathAddArcToPoint(path,
//                        nil,
//                        contentBackgroundBounds.size.width - contentArrowWidth,
//                        (minContentHeight + contentArrowHeight) / 2.f,
//                        contentBackgroundBounds.size.width - contentArrowWidth,
//                        (minContentHeight + contentArrowHeight) / 2.f + 2,
//                        4);
//    CGPathCloseSubpath(path);
//    return path;
//}

@end
