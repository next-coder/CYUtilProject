//
//  CYChatImageCell.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/19/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatImageCell.h"
#import "CYWebImageCache.h"

@implementation CYChatImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        _drawContentBackground = YES;
        [self createContentImageView];
    }
    return self;
}

- (void)createContentImageView {
    
    UIImageView *content = [[UIImageView alloc] init];
    content.userInteractionEnabled = YES;
    content.backgroundColor = [UIColor clearColor];
    content.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentBackgroundImageView addSubview:content];
    self.contentImageView = content;
}

#pragma mark - content size
- (CGSize)contentImageViewSize {
    
    return [CYChatImageCell contentSizeWithMessage:self.message];
}

+ (CGSize)defaultContentImageViewSize {
    
    return CY_CHAT_CELL_DEFAULT_IMAGE_CONTENT_SIZE;
}

+ (CGSize)contentSizeWithMessage:(CYChatMessageViewModel *)message {
    
    if (!CGSizeEqualToSize(message.messageContentSize, CGSizeZero)) {
        
        return message.messageContentSize;
    }
    
    // 根据图片计算size
    UIImage *image = [[CYWebImageCache defaultCache] imageCacheWithUrlString:message.imageIconUrl];
    
    if (!image) {
        
        // 图片未加载完成是，返回默认size
        return [self defaultContentImageViewSize];
    } else {
        
        // 计算size
        CGSize imageSize = image.size;
        CGSize maxContentSize = [CYChatImageCell maxContentSize];
        CGSize minContentSize = [CYChatImageCell minContentSize];
        
        CGSize contentSize = CGSizeZero;
        if (imageSize.width < maxContentSize.width
            && imageSize.height < maxContentSize.height) {
            
            contentSize = imageSize;
        } else if (imageSize.width > maxContentSize.width
                   || imageSize.height > maxContentSize.height) {
            
            // 图片大小超过最大允许大小，则视图的大小是对图片大小进行适当地按比例缩小
            CGFloat widthFactor = imageSize.width / maxContentSize.width;
            CGFloat heightFator = imageSize.height / maxContentSize.height;
            CGFloat factor = MAX(widthFactor, heightFator);
            
            contentSize = CGSizeMake(imageSize.width / factor, imageSize.height / factor);
        }
        
        // 如果某一边小于最小限度，则设置成最小限度
        if (contentSize.width < minContentSize.width) {
            
            contentSize.width = minContentSize.width;
        }
        if (contentSize.width < minContentSize.height) {
            
            contentSize.height = minContentSize.height;
        }
        
        message.messageContentSize = contentSize;
        return contentSize;
    }
}

+ (CGFloat)heightOfCellWithMessage:(CYChatMessageViewModel *)message
                     hideHeadImage:(BOOL)hideHeadImage
                          hideName:(BOOL)hideName {
    
    CGFloat height = 0.f;
    
    CGSize contentImageShowingSize = [self contentSizeWithMessage:message];
    height += contentImageShowingSize.height;
    
    if (!hideName) {
        
        height += (CY_CHAT_CELL_NAME_VERTICAL_GAP + CY_CHAT_CELL_NAME_HEIGHT);
    }
    height += (CY_CHAT_CELL_BOTTOM_MARGIN + CY_CHAT_CELL_TOP_MARGIN);
    return height;
}

@end
